class LocalItem {
  const LocalItem({
    required this.region,
    required this.prefecture,
    required this.name,
    required this.threshold,
    required this.assetPath,
    required this.description,
  });

  final String region;
  final String prefecture;
  final String name;
  final int threshold;
  final String assetPath;
  final String description;
}

const localItems = <LocalItem>[

  LocalItem(region: '北海道', prefecture: '北海道', name: 'カニ', threshold: 5, assetPath: 'assets/local_items/hokkaido/hokkaido/kani.png', description: '濃厚な旨みと甘みが楽しめる北の海の味覚。'),
  LocalItem(region: '北海道', prefecture: '北海道', name: 'じゃがいも', threshold: 10, assetPath: 'assets/local_items/hokkaido/hokkaido/jagaimo.png', description: 'ほくほく食感と自然な甘みが特徴の農産物。'),
  LocalItem(region: '北海道', prefecture: '北海道', name: 'ジンギスカン', threshold: 15, assetPath: 'assets/local_items/hokkaido/hokkaido/jingisukan.png', description: '羊肉と野菜を焼いて味わう北海道の郷土料理。'),
  LocalItem(region: '北海道', prefecture: '北海道', name: 'とうもろこし', threshold: 20, assetPath: 'assets/local_items/hokkaido/hokkaido/tomorokoshi.png', description: 'みずみずしく、強い甘みを楽しめる夏の味覚。'),
  LocalItem(region: '北海道', prefecture: '北海道', name: '夕張メロン', threshold: 25, assetPath: 'assets/local_items/hokkaido/hokkaido/yubari_melon.png', description: '芳醇な香りと、とろける甘さが魅力の高級メロン。'),
  LocalItem(region: '北海道', prefecture: '北海道', name: 'いくら', threshold: 30, assetPath: 'assets/local_items/hokkaido/hokkaido/ikura.png', description: 'ぷちぷち食感と濃厚な旨みが魅力の魚卵。'),

  LocalItem(region: '東北', prefecture: '青森県', name: 'りんご', threshold: 5, assetPath: 'assets/local_items/tohoku/aomori/ringo.png', description: '甘みと酸味のバランスが良い青森の名産。'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'せんべい汁', threshold: 10, assetPath: 'assets/local_items/tohoku/aomori/senbei_jiru.png', description: '南部せんべいを煮込んで味わう郷土料理。'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'にんにく', threshold: 15, assetPath: 'assets/local_items/tohoku/aomori/ninniku.png', description: '香りとコクが強く、粒の大きさも魅力。'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'ほたて', threshold: 20, assetPath: 'assets/local_items/tohoku/aomori/hotate.png', description: '肉厚で甘みがあり、濃厚な旨みが特徴。'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'いか', threshold: 25, assetPath: 'assets/local_items/tohoku/aomori/ika.png', description: '新鮮で甘みがあり、刺身や焼き物で人気。'),
  LocalItem(region: '東北', prefecture: '青森県', name: '長芋', threshold: 30, assetPath: 'assets/local_items/tohoku/aomori/nagaimo.png', description: '粘りが強く、シャキシャキ食感も楽しめる。'),

  LocalItem(region: '東北', prefecture: '岩手県', name: 'わんこそば', threshold: 5, assetPath: 'assets/local_items/tohoku/iwate/wanko_soba.png', description: '小さな椀で次々と味わう岩手名物のそば。'),
  LocalItem(region: '東北', prefecture: '岩手県', name: 'うに', threshold: 10, assetPath: 'assets/local_items/tohoku/iwate/uni.png', description: '濃厚な甘みと、とろける食感が特徴の海の幸。'),
  LocalItem(region: '東北', prefecture: '岩手県', name: 'ひっつみ汁', threshold: 15, assetPath: 'assets/local_items/tohoku/iwate/hittsumi_jiru.png', description: '小麦粉の生地をちぎって煮込む郷土料理。'),
  LocalItem(region: '東北', prefecture: '岩手県', name: 'あわび', threshold: 20, assetPath: 'assets/local_items/tohoku/iwate/awabi.png', description: '肉厚な身と豊かな旨みが魅力の高級貝。'),
  LocalItem(region: '東北', prefecture: '岩手県', name: '牡蠣', threshold: 25, assetPath: 'assets/local_items/tohoku/iwate/kaki.png', description: '濃厚な旨みとクリーミーな味わいが魅力。'),
  LocalItem(region: '東北', prefecture: '岩手県', name: '盛岡冷麺', threshold: 30, assetPath: 'assets/local_items/tohoku/iwate/morioka_reimen.png', description: '強いコシの麺と爽やかなスープが特徴。'),

  LocalItem(region: '東北', prefecture: '宮城県', name: 'はらこ飯', threshold: 5, assetPath: 'assets/local_items/tohoku/miyagi/harako_meshi.png', description: '鮭といくらをたっぷり味わう宮城の郷土料理。'),
  LocalItem(region: '東北', prefecture: '宮城県', name: 'ほや貝', threshold: 10, assetPath: 'assets/local_items/tohoku/miyagi/hoya.png', description: '独特の磯の香りと濃厚な旨みが特徴の海産物。'),
  LocalItem(region: '東北', prefecture: '宮城県', name: '牛たん', threshold: 15, assetPath: 'assets/local_items/tohoku/miyagi/gyutan.png', description: '厚切りで香ばしく焼き上げる仙台名物。'),
  LocalItem(region: '東北', prefecture: '宮城県', name: '笹かまぼこ', threshold: 20, assetPath: 'assets/local_items/tohoku/miyagi/sasa_kamaboko.png', description: '笹の葉形に焼き上げた、香ばしい練り物。'),
  LocalItem(region: '東北', prefecture: '宮城県', name: 'ずんだ餅', threshold: 25, assetPath: 'assets/local_items/tohoku/miyagi/zunda_mochi.png', description: '枝豆をすりつぶした餡を絡める宮城名物。'),
  LocalItem(region: '東北', prefecture: '宮城県', name: 'せり鍋', threshold: 30, assetPath: 'assets/local_items/tohoku/miyagi/seri_nabe.png', description: '香り豊かなせりをたっぷり味わう冬の鍋料理。'),

  LocalItem(region: '東北', prefecture: '秋田県', name: 'きりたんぽ鍋', threshold: 5, assetPath: 'assets/local_items/tohoku/akita/kiritanpo_nabe.png', description: 'つぶしたご飯を焼き、鶏だしで煮込む郷土鍋。'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'じゅんさい', threshold: 10, assetPath: 'assets/local_items/tohoku/akita/junsai.png', description: 'つるりとした食感が楽しい、水生植物の若芽。'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'バター餅', threshold: 15, assetPath: 'assets/local_items/tohoku/akita/butter_mochi.png', description: 'バターのコクと柔らかな食感が魅力の郷土菓子。'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'いぶりがっこ', threshold: 20, assetPath: 'assets/local_items/tohoku/akita/iburigakko.png', description: '大根を燻して漬けた、香ばしい秋田の漬物。'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'ハタハタ', threshold: 25, assetPath: 'assets/local_items/tohoku/akita/hatahata.png', description: '淡白な身と豊かな旨みが特徴の秋田の県魚。'),
  LocalItem(region: '東北', prefecture: '秋田県', name: '稲庭うどん', threshold: 30, assetPath: 'assets/local_items/tohoku/akita/inaniwa_udon.png', description: '細くなめらかで、のど越しの良い手延べうどん。'),

  LocalItem(region: '東北', prefecture: '山形県', name: 'ラ・フランス', threshold: 5, assetPath: 'assets/local_items/tohoku/yamagata/la_france.png', description: '芳醇な香りと、とろける甘さが魅力の洋梨。'),
  LocalItem(region: '東北', prefecture: '山形県', name: '芋煮', threshold: 10, assetPath: 'assets/local_items/tohoku/yamagata/imoni.png', description: '里芋と肉を煮込んだ、山形を代表する郷土料理。'),
  LocalItem(region: '東北', prefecture: '山形県', name: '玉こんにゃく', threshold: 15, assetPath: 'assets/local_items/tohoku/yamagata/tama_konnyaku.png', description: '丸いこんにゃくを醤油味で煮込んだ名物。'),
  LocalItem(region: '東北', prefecture: '山形県', name: '冷たい肉そば', threshold: 20, assetPath: 'assets/local_items/tohoku/yamagata/tsumetai_niku_soba.png', description: '冷たいつゆと鶏肉で味わう山形名物のそば。'),
  LocalItem(region: '東北', prefecture: '山形県', name: 'さくらんぼ', threshold: 25, assetPath: 'assets/local_items/tohoku/yamagata/sakuranbo.png', description: '上品な甘みと爽やかな酸味が魅力の果物。'),
  LocalItem(region: '東北', prefecture: '山形県', name: 'だし', threshold: 30, assetPath: 'assets/local_items/tohoku/yamagata/dashi.png', description: '夏野菜を細かく刻んで味付けした郷土料理。'),

  LocalItem(region: '東北', prefecture: '福島県', name: 'ソースカツ丼', threshold: 5, assetPath: 'assets/local_items/tohoku/fukushima/sauce_katsudon.png', description: '甘辛いソースを絡めたカツをのせる丼料理。'),
  LocalItem(region: '東北', prefecture: '福島県', name: '円盤餃子', threshold: 10, assetPath: 'assets/local_items/tohoku/fukushima/enban_gyoza.png', description: '餃子を円形に並べて香ばしく焼いた福島名物。'),
  LocalItem(region: '東北', prefecture: '福島県', name: '喜多方ラーメン', threshold: 15, assetPath: 'assets/local_items/tohoku/fukushima/kitakata_ramen.png', description: '平打ちの太麺とあっさり醤油スープが特徴。'),
  LocalItem(region: '東北', prefecture: '福島県', name: '赤べこ', threshold: 20, assetPath: 'assets/local_items/tohoku/fukushima/akabeko.png', description: '赤い牛の姿をした、福島を代表する郷土玩具。'),
  LocalItem(region: '東北', prefecture: '福島県', name: '桃', threshold: 25, assetPath: 'assets/local_items/tohoku/fukushima/momo.png', description: 'みずみずしく、豊かな甘みと香りが魅力の果物。'),
  LocalItem(region: '東北', prefecture: '福島県', name: 'あんぽ柿', threshold: 30, assetPath: 'assets/local_items/tohoku/fukushima/anpo_gaki.png', description: 'とろりと柔らかく、濃厚な甘さが特徴の干し柿。'),

  LocalItem(region: '東海', prefecture: '愛知県', name: 'ういろう', threshold: 5, assetPath: 'assets/local_items/tokai/aichi/uiro.png', description: 'もちもち食感が特徴の、米粉を使った和菓子。'),
  LocalItem(region: '東海', prefecture: '愛知県', name: 'えびせんべい', threshold: 10, assetPath: 'assets/local_items/tokai/aichi/ebi_senbei.png', description: 'えびの香ばしい風味を楽しめる薄焼きせんべい。'),
  LocalItem(region: '東海', prefecture: '愛知県', name: 'きしめん', threshold: 15, assetPath: 'assets/local_items/tokai/aichi/kishimen.png', description: '幅広で平たい麺が特徴の、名古屋の郷土麺。'),
  LocalItem(region: '東海', prefecture: '愛知県', name: 'ひつまぶし', threshold: 20, assetPath: 'assets/local_items/tokai/aichi/hitsumabushi.png', description: '細かく切ったうなぎをご飯にのせた名古屋名物。'),
  LocalItem(region: '東海', prefecture: '愛知県', name: '手羽先', threshold: 25, assetPath: 'assets/local_items/tokai/aichi/tebasaki.png', description: '甘辛いタレと香辛料が特徴の鶏手羽料理。'),
  LocalItem(region: '東海', prefecture: '愛知県', name: '味噌カツ', threshold: 30, assetPath: 'assets/local_items/tokai/aichi/miso_katsu.png', description: 'とんかつに濃厚な味噌だれをかけた名古屋名物。'),
  LocalItem(region: '東海', prefecture: '岐阜県', name: '鮎の塩焼き', threshold: 5, assetPath: 'assets/local_items/tokai/gifu/ayu_shioyaki.png', description: '香ばしく焼き上げた、清流育ちの鮎料理。'),
  LocalItem(region: '東海', prefecture: '岐阜県', name: '栗きんとん', threshold: 10, assetPath: 'assets/local_items/tokai/gifu/kuri_kinton.png', description: '栗の甘みを生かした、素朴な和菓子。'),
  LocalItem(region: '東海', prefecture: '岐阜県', name: '鶏ちゃん', threshold: 15, assetPath: 'assets/local_items/tokai/gifu/keichan.png', description: '鶏肉を味噌や醤油で味付けした郷土料理。'),
  LocalItem(region: '東海', prefecture: '岐阜県', name: '五平餅', threshold: 20, assetPath: 'assets/local_items/tokai/gifu/gohei_mochi.png', description: 'ご飯を串に付け、甘辛だれで焼いた郷土食。'),
  LocalItem(region: '東海', prefecture: '岐阜県', name: '飛騨牛', threshold: 25, assetPath: 'assets/local_items/tokai/gifu/hida_gyu.png', description: 'きめ細かな霜降りと柔らかさが特徴の和牛。'),
  LocalItem(region: '東海', prefecture: '岐阜県', name: '朴葉味噌', threshold: 30, assetPath: 'assets/local_items/tokai/gifu/hoba_miso.png', description: '朴葉の上で味噌を焼いて味わう郷土料理。'),
  LocalItem(region: '東海', prefecture: '三重県', name: 'あおさのり', threshold: 5, assetPath: 'assets/local_items/tokai/mie/aosa_nori.png', description: '磯の香り豊かな、鮮やかな緑色の海藻。'),
  LocalItem(region: '東海', prefecture: '三重県', name: 'てこね寿司', threshold: 10, assetPath: 'assets/local_items/tokai/mie/tekone_zushi.png', description: '漬けた魚の切り身を酢飯にのせた郷土寿司。'),
  LocalItem(region: '東海', prefecture: '三重県', name: '伊勢うどん', threshold: 15, assetPath: 'assets/local_items/tokai/mie/ise_udon.png', description: '極太で柔らかな麺に濃厚なたれを絡める名物。'),
  LocalItem(region: '東海', prefecture: '三重県', name: '伊勢海老', threshold: 20, assetPath: 'assets/local_items/tokai/mie/ise_ebi.png', description: 'ぷりっとした身と濃厚な甘みが魅力の高級食材。'),
  LocalItem(region: '東海', prefecture: '三重県', name: '牡蠣', threshold: 25, assetPath: 'assets/local_items/tokai/mie/kaki.png', description: '濃厚な旨みとクリーミーな味わいが特徴の海産物。'),
  LocalItem(region: '東海', prefecture: '三重県', name: '真珠', threshold: 30, assetPath: 'assets/local_items/tokai/mie/shinju.png', description: '美しい光沢を持つ、三重を代表する特産品。'),
  LocalItem(region: '東海', prefecture: '静岡県', name: 'うな重', threshold: 5, assetPath: 'assets/local_items/tokai/shizuoka/unaju.png', description: '香ばしく焼いたうなぎを、ご飯にのせた贅沢料理。'),
  LocalItem(region: '東海', prefecture: '静岡県', name: 'しらす', threshold: 10, assetPath: 'assets/local_items/tokai/shizuoka/shirasu.png', description: 'やわらかな食感と、ほどよい塩味が魅力の海産物。'),
  LocalItem(region: '東海', prefecture: '静岡県', name: 'みかん', threshold: 15, assetPath: 'assets/local_items/tokai/shizuoka/mikan.png', description: '甘みと酸味のバランスが良い、静岡の代表的な果物。'),
  LocalItem(region: '東海', prefecture: '静岡県', name: 'わさび', threshold: 20, assetPath: 'assets/local_items/tokai/shizuoka/wasabi.png', description: '爽やかな香りと、すっきりした辛みが特徴の香辛料。'),
  LocalItem(region: '東海', prefecture: '静岡県', name: '桜えび', threshold: 25, assetPath: 'assets/local_items/tokai/shizuoka/sakura_ebi.png', description: '鮮やかな桜色と、豊かな風味が特徴の小えび。'),
  LocalItem(region: '東海', prefecture: '静岡県', name: '日本茶', threshold: 30, assetPath: 'assets/local_items/tokai/shizuoka/nihoncha.png', description: '香り高く、まろやかな味わいを楽しめる静岡の名産品。'),
];

const localItemRegions = <String>['北海道', '東北', '東海'];
const hokkaidoPrefectures = <String>['北海道'];
const tohokuPrefectures = <String>['青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県'];
const tokaiPrefectures = <String>['岐阜県', '静岡県', '愛知県', '三重県'];

List<String> prefecturesForRegion(String region) {
  return switch (region) {
    '北海道' => hokkaidoPrefectures,
    '東北' => tohokuPrefectures,
    '東海' => tokaiPrefectures,
    _ => localItems
        .where((item) => item.region == region)
        .map((item) => item.prefecture)
        .toSet()
        .toList(growable: false),
  };
}
