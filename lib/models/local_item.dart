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

const localItemRegions = <String>['東海'];
const tokaiPrefectures = <String>['愛知県', '岐阜県', '三重県', '静岡県'];
