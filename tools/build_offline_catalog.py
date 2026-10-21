"""Rebuild the national offline POI catalog from the pinned Geofabrik snapshot."""
import collections,gzip,hashlib,json,math,re,sys
from pathlib import Path
import osmium

SOURCE=Path(sys.argv[1]); DEST=Path(sys.argv[2]); DEST.mkdir(parents=True,exist_ok=True)
CAT=['観光名所・ランドマーク','博物館・美術館','ギャラリー','動物園','水族館','展望台','ホテル・旅館','テーマパーク','寺社・教会','ギャラリー・文化施設','公園','庭園','有名な商業施設','城・史跡','観光施設']
T=dict(zip(['attraction','museum','gallery','zoo','aquarium','viewpoint','hotel','guest_house','theme_park'],[0,1,2,3,4,5,6,6,7]))
def select(t):
 name=t.get('name:ja',t.get('name',t.get('official_name')))
 if not name or not name.strip():return
 if not(re.search('attraction|museum|gallery|zoo|aquarium|viewpoint|hotel|guest_house|theme_park',t.get('tourism','')) or re.search('place_of_worship|arts_centre',t.get('amenity','')) or 'historic' in t or re.search('park|garden',t.get('leisure','')) or 'castle_type' in t or re.search('department_store|mall',t.get('shop',''))):return
 c=T.get(t.get('tourism'))
 if c is None:
  c=8 if t.get('amenity')=='place_of_worship' else 9 if t.get('amenity')=='arts_centre' else 10 if t.get('leisure')=='park' else 11 if t.get('leisure')=='garden' else 12 if t.get('shop') in ('mall','department_store') else 13 if 'historic' in t or 'castle_type' in t else 14
 return name.strip(),c
def read(bits,h,*filters):
 with osmium.io.Reader(str(SOURCE),bits) as r:osmium.apply(r,*filters,h)
def box(pts):
 pts=[p for p in pts if p is not None]
 if pts:return min(p[0] for p in pts),min(p[1] for p in pts),max(p[2] for p in pts),max(p[3] for p in pts)
digest=hashlib.md5()
with SOURCE.open('rb') as f:
 for block in iter(lambda:f.read(8*1024*1024),b''):digest.update(block)
assert digest.hexdigest()=='8a4c1be7b0b42a6b1ac621aa2590a0e5','Source checksum mismatch'
sw={};sr={};rels={};ways={}
class Select(osmium.SimpleHandler):
 def way(self,w):
  s=select(w.tags)
  if s:sw[w.id]=s;ways[w.id]=[n.ref for n in w.nodes]
 def relation(self,r):
  rels[r.id]=[(m.type,m.ref) for m in r.members]
  s=select(r.tags)
  if s:sr[r.id]=s
print('Select ways/relations',flush=True)
read(osmium.osm.WAY,Select(),osmium.filter.KeyFilter('name:ja','name','official_name'))
read(osmium.osm.RELATION,Select())
needed_w=set();needed_n=set();visited=set()
def expand(rid):
 if rid in visited:return
 visited.add(rid)
 for typ,ref in rels.get(rid,[]):
  if typ=='w':needed_w.add(ref)
  elif typ=='n':needed_n.add(ref)
  else:expand(ref)
for rid in sr:expand(rid)
rels={rid:members for rid,members in rels.items() if rid in visited}
class GatherWays(osmium.SimpleHandler):
 def way(self,w):ways[w.id]=[n.ref for n in w.nodes]
read(osmium.osm.WAY,GatherWays(),osmium.filter.IdFilter(needed_w-set(ways)))
for refs in ways.values():needed_n.update(refs)
positions={};records=[]
class Positions(osmium.SimpleHandler):
 def node(self,n):
  if n.location.valid():positions[n.id]=(n.lon,n.lat,n.lon,n.lat)
class Nodes(osmium.SimpleHandler):
 def node(self,n):
  s=select(n.tags)
  if s and n.location.valid():records.append(('n',n.id,s[0],n.lat,n.lon,s[1]))
print('Gather coordinates and named nodes',len(needed_n),flush=True)
read(osmium.osm.NODE,Positions(),osmium.filter.IdFilter(needed_n))
read(osmium.osm.NODE,Nodes(),osmium.filter.KeyFilter('name:ja','name','official_name'))
assert len(positions)==len(needed_n)
wb={wid:box(positions.get(n) for n in refs) for wid,refs in ways.items()};rb={};active=set()
def relbox(rid):
 if rid in rb:return rb[rid]
 if rid in active:return
 active.add(rid)
 b=box(positions.get(ref) if typ=='n' else wb.get(ref) if typ=='w' else relbox(ref) for typ,ref in rels.get(rid,[]))
 active.remove(rid);rb[rid]=b;return b
for typ,selected in [('w',sw),('r',sr)]:
 for oid,(name,c) in selected.items():
  b=wb.get(oid) if typ=='w' else relbox(oid)
  assert b is not None
  records.append((typ,oid,name,(b[1]+b[3])/2,(b[0]+b[2])/2,c))
records.sort(key=lambda r:('nwr'.index(r[0]),r[1]))
seen=set();cells=collections.defaultdict(list)
for typ,oid,name,lat,lon,c in records:
 key=(name,f'{lat:.5f}',f'{lon:.5f}')
 if key in seen:continue
 seen.add(key);cells[f'{math.floor(lat)}_{math.floor(lon)}'].append([f'{typ}{oid}',name,lat,lon,c])
assert len(seen)==216406,(len(seen),'Catalog count differs from original survey')
files={}
for cell,rows in sorted(cells.items()):
 data=gzip.compress(json.dumps(rows,ensure_ascii=False,separators=(',',':')).encode(),compresslevel=9,mtime=0)
 name=cell+'.json.gz';(DEST/name).write_bytes(data)
 files[cell]={'file':name,'count':len(rows),'sha256':hashlib.sha256(data).hexdigest()}
manifest={'schema':1,'snapshot':'2026-10-19','count':len(seen),'categories':CAT,'cells':files,
 'source':'https://download.geofabrik.de/asia/japan-261019.osm.pbf','license':'ODbL-1.0',
 'attribution':'© OpenStreetMap contributors','source_md5':digest.hexdigest()}
(DEST/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
print('DONE',len(seen),'places',len(files),'cells',sum(p.stat().st_size for p in DEST.iterdir()),'bytes',flush=True)
