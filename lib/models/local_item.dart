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

  LocalItem(region: '北海道', prefecture: '北海道', name: 'じゃがいも', threshold: 5, assetPath: 'assets/local_items/北海道地方/北海道/じゃがいも.png', description: '日本一の生産量を誇る\n北海道を代表する農産物'),
  LocalItem(region: '北海道', prefecture: '北海道', name: 'とうもろこし', threshold: 10, assetPath: 'assets/local_items/北海道地方/北海道/とうもろこし.png', description: '広大な大地で育つ甘み豊かな\n北海道の代表野菜'),
  LocalItem(region: '北海道', prefecture: '北海道', name: '昆布', threshold: 15, assetPath: 'assets/local_items/北海道地方/北海道/昆布.png', description: '豊かな北の海で育つ\nうま味たっぷりの海産物'),
  LocalItem(region: '北海道', prefecture: '北海道', name: 'いくら', threshold: 20, assetPath: 'assets/local_items/北海道地方/北海道/いくら.png', description: '鮭の卵を醤油などで味付けした\n北海道の海の幸'),
  LocalItem(region: '北海道', prefecture: '北海道', name: '乳製品', threshold: 25, assetPath: 'assets/local_items/北海道地方/北海道/乳製品.png', description: '酪農王国北海道の\n良質な生乳から作られる名産品'),
  LocalItem(region: '北海道', prefecture: '北海道', name: '二風谷アットゥシ', threshold: 30, assetPath: 'assets/local_items/北海道地方/北海道/二風谷アットゥシ.png', description: '樹皮の繊維を使って織り上げる伝統的な織物'),

  LocalItem(region: '東北', prefecture: '青森県', name: 'りんご', threshold: 5, assetPath: 'assets/local_items/東北地方/青森/りんご.png', description: '日本一の生産量を誇る\n青森を代表する果物'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'にんにく', threshold: 10, assetPath: 'assets/local_items/東北地方/青森/にんにく.png', description: '日本一の生産量を誇る\n大粒で香り豊かな特産品'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'せんべい汁', threshold: 15, assetPath: 'assets/local_items/東北地方/青森/せんべい汁.png', description: '南部せんべいを割り入れて煮込む温かな郷土料理'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'いちご煮', threshold: 20, assetPath: 'assets/local_items/東北地方/青森/いちご煮.png', description: 'うにとあわびを澄まし汁仕立てに\nした海の郷土料理'),
  LocalItem(region: '東北', prefecture: '青森県', name: '生姜味噌おでん', threshold: 25, assetPath: 'assets/local_items/東北地方/青森/生姜味噌おでん.png', description: 'おでんに生姜入り味噌だれを\nかける青森の味'),
  LocalItem(region: '東北', prefecture: '青森県', name: '津軽塗', threshold: 30, assetPath: 'assets/local_items/東北地方/青森/津軽塗.png', description: '幾重にも漆を塗り重ねて\n美しい模様を作る伝統工芸'),

  LocalItem(region: '東北', prefecture: '岩手県', name: 'わんこそば', threshold: 5, assetPath: 'assets/local_items/東北地方/岩手/わんこそば.png', description: '小さな椀へ次々とそばを盛る\n岩手名物の郷土料理'),
  LocalItem(region: '東北', prefecture: '岩手県', name: '盛岡冷麺', threshold: 10, assetPath: 'assets/local_items/東北地方/岩手/盛岡冷麺.png', description: '弾力ある麺と冷たいスープが\n特徴の盛岡名物'),
  LocalItem(region: '東北', prefecture: '岩手県', name: 'ひっつみ汁', threshold: 15, assetPath: 'assets/local_items/東北地方/岩手/ひっつみ汁.png', description: '小麦粉の生地を手でちぎり汁で\n煮込む郷土料理'),
  LocalItem(region: '東北', prefecture: '岩手県', name: '南部せんべい', threshold: 20, assetPath: 'assets/local_items/東北地方/岩手/南部せんべい.png', description: '小麦粉の生地を丸く香ばしく\n焼き上げた素朴な菓子'),
  LocalItem(region: '東北', prefecture: '岩手県', name: 'うに', threshold: 25, assetPath: 'assets/local_items/東北地方/岩手/うに.png', description: '三陸の豊かな海で育つ\n濃厚な甘みを持つ海産物'),
  LocalItem(region: '東北', prefecture: '岩手県', name: '南部鉄器', threshold: 30, assetPath: 'assets/local_items/東北地方/岩手/南部鉄器.png', description: '重厚な鉄瓶や急須で知られる\n岩手伝統の鋳物'),

  LocalItem(region: '東北', prefecture: '宮城県', name: '牛たん', threshold: 5, assetPath: 'assets/local_items/東北地方/宮城/牛たん.png', description: '厚めに切った牛たんを\n香ばしく焼き上げる仙台名物'),
  LocalItem(region: '東北', prefecture: '宮城県', name: '笹かまぼこ', threshold: 10, assetPath: 'assets/local_items/東北地方/宮城/笹かまぼこ.png', description: '笹の葉形に成形して焼き上げる\n宮城の魚肉練り製品'),
  LocalItem(region: '東北', prefecture: '宮城県', name: 'はらこ飯', threshold: 15, assetPath: 'assets/local_items/東北地方/宮城/はらこ飯.png', description: '鮭の煮汁で炊いたご飯に\n鮭といくらをのせる郷土料理'),
  LocalItem(region: '東北', prefecture: '宮城県', name: 'ずんだ餅', threshold: 20, assetPath: 'assets/local_items/東北地方/宮城/ずんだ餅.png', description: '枝豆をすりつぶした\n鮮やかな餡を餅に絡めた郷土菓子'),
  LocalItem(region: '東北', prefecture: '宮城県', name: 'せり鍋', threshold: 25, assetPath: 'assets/local_items/東北地方/宮城/せり鍋.png', description: '根まで味わうせりをたっぷり使った宮城の冬の鍋料理'),
  LocalItem(region: '東北', prefecture: '宮城県', name: '宮城伝統こけし', threshold: 30, assetPath: 'assets/local_items/東北地方/宮城/宮城伝統こけし.png', description: '素朴な表情とろくろ模様が\n美しい木製の伝統人形'),

  LocalItem(region: '東北', prefecture: '秋田県', name: 'きりたんぽ', threshold: 5, assetPath: 'assets/local_items/東北地方/秋田/きりたんぽ.png', description: 'つぶしたご飯を棒に巻いて\n焼き鍋などで味わう郷土食'),
  LocalItem(region: '東北', prefecture: '秋田県', name: '稲庭うどん', threshold: 10, assetPath: 'assets/local_items/東北地方/秋田/稲庭うどん.png', description: '細くなめらかな麺と\n強いコシが特徴の手延べうどん'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'いぶりがっこ', threshold: 15, assetPath: 'assets/local_items/東北地方/秋田/いぶりがっこ.png', description: '大根を燻してから漬け込む\n香ばしい秋田の漬物'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'ハタハタ', threshold: 20, assetPath: 'assets/local_items/東北地方/秋田/ハタハタ.png', description: '秋田の冬を代表する魚で\n鍋や寿司などで親しまれる'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'じゅんさい', threshold: 25, assetPath: 'assets/local_items/東北地方/秋田/じゅんさい.png', description: 'つるりとした食感が特徴の\n水生植物の若芽'),
  LocalItem(region: '東北', prefecture: '秋田県', name: '大館曲げわっぱ', threshold: 30, assetPath: 'assets/local_items/東北地方/秋田/大館曲げわっぱ.png', description: '薄い天然杉を曲げて作る\n美しい木製の伝統工芸品'),

  LocalItem(region: '東北', prefecture: '山形県', name: 'さくらんぼ', threshold: 5, assetPath: 'assets/local_items/東北地方/山形/さくらんぼ.png', description: '日本一の生産量を誇る\n山形を代表する初夏の果物'),
  LocalItem(region: '東北', prefecture: '山形県', name: 'ラ・フランス', threshold: 10, assetPath: 'assets/local_items/東北地方/山形/ラ・フランス.png', description: '芳醇な香りと\nなめらかな食感を持つ西洋なし'),
  LocalItem(region: '東北', prefecture: '山形県', name: '芋煮', threshold: 15, assetPath: 'assets/local_items/東北地方/山形/芋煮.png', description: '里芋や肉などを大鍋で煮込む\n山形を代表する郷土料理'),
  LocalItem(region: '東北', prefecture: '山形県', name: '玉こんにゃく', threshold: 20, assetPath: 'assets/local_items/東北地方/山形/玉こんにゃく.png', description: '丸いこんにゃくを醤油味で煮込んだ山形名物'),
  LocalItem(region: '東北', prefecture: '山形県', name: '冷たい肉そば', threshold: 25, assetPath: 'assets/local_items/東北地方/山形/冷たい肉そば.png', description: '冷たいつゆと歯応えある鶏肉を\n楽しむ山形のそば'),
  LocalItem(region: '東北', prefecture: '山形県', name: '天童将棋駒', threshold: 30, assetPath: 'assets/local_items/東北地方/山形/天童将棋駒.png', description: '一文字ずつ美しく仕上げられる\n天童伝統の将棋駒'),

  LocalItem(region: '東北', prefecture: '福島県', name: '喜多方ラーメン', threshold: 5, assetPath: 'assets/local_items/東北地方/福島/喜多方ラーメン.png', description: '平打ちの縮れ麺と\n醤油系スープが特徴のご当地麺'),
  LocalItem(region: '東北', prefecture: '福島県', name: 'ソースカツ丼', threshold: 10, assetPath: 'assets/local_items/東北地方/福島/ソースカツ丼.png', description: 'ご飯にキャベツとソースを絡めた\nカツをのせる料理'),
  LocalItem(region: '東北', prefecture: '福島県', name: '円盤餃子', threshold: 15, assetPath: 'assets/local_items/東北地方/福島/円盤餃子.png', description: '餃子をフライパンへ円形に並べて香ばしく焼いた名物'),
  LocalItem(region: '東北', prefecture: '福島県', name: 'あんぽ柿', threshold: 20, assetPath: 'assets/local_items/東北地方/福島/あんぽ柿.png', description: '柿を乾燥させ、柔らかく濃厚な\n甘みに仕上げた特産品'),
  LocalItem(region: '東北', prefecture: '福島県', name: '赤べこ', threshold: 25, assetPath: 'assets/local_items/東北地方/福島/赤べこ.png', description: '赤い牛をかたどった首が揺れる\n会津伝統の郷土玩具'),
  LocalItem(region: '東北', prefecture: '福島県', name: '会津塗', threshold: 30, assetPath: 'assets/local_items/東北地方/福島/会津塗.png', description: '美しい漆の光沢と多彩な加飾が\n特徴の伝統的な漆器'),

  LocalItem(region: '関東', prefecture: '茨城県', name: 'メロン', threshold: 5, assetPath: 'assets/local_items/関東地方/茨城/メロン.png', description: '日本一の生産量を誇る\n芳醇な甘みの茨城特産フルーツ'),
  LocalItem(region: '関東', prefecture: '茨城県', name: 'れんこん', threshold: 10, assetPath: 'assets/local_items/関東地方/茨城/れんこん.png', description: '日本一の生産量を誇る\n霞ヶ浦周辺を代表する農産物'),
  LocalItem(region: '関東', prefecture: '茨城県', name: '納豆', threshold: 15, assetPath: 'assets/local_items/関東地方/茨城/納豆.png', description: '蒸した大豆を発酵させた\n茨城を代表する伝統的な食品'),
  LocalItem(region: '関東', prefecture: '茨城県', name: '干し芋', threshold: 20, assetPath: 'assets/local_items/関東地方/茨城/干し芋.png', description: 'さつまいもを蒸して乾燥させ\n自然な甘みを凝縮した食品'),
  LocalItem(region: '関東', prefecture: '茨城県', name: 'あんこう鍋', threshold: 25, assetPath: 'assets/local_items/関東地方/茨城/あんこう鍋.png', description: 'あんこうの身や肝、野菜を煮込む\n冬の名物鍋料理'),
  LocalItem(region: '関東', prefecture: '茨城県', name: '笠間焼', threshold: 30, assetPath: 'assets/local_items/関東地方/茨城/笠間焼.png', description: '自由で多彩な作風が魅力の\n茨城を代表する陶器'),

  LocalItem(region: '関東', prefecture: '栃木県', name: 'いちご', threshold: 5, assetPath: 'assets/local_items/関東地方/栃木/いちご.png', description: '全国屈指の生産を誇る\n栃木を代表する甘酸っぱい果物'),
  LocalItem(region: '関東', prefecture: '栃木県', name: 'かんぴょう', threshold: 10, assetPath: 'assets/local_items/関東地方/栃木/かんぴょう.png', description: '日本一の生産量を誇る\n夕顔の実から作る乾物'),
  LocalItem(region: '関東', prefecture: '栃木県', name: '湯波', threshold: 15, assetPath: 'assets/local_items/関東地方/栃木/湯波.png', description: '豆乳を加熱して表面にできる膜を丁寧に引き上げた食品'),
  LocalItem(region: '関東', prefecture: '栃木県', name: 'しもつかれ', threshold: 20, assetPath: 'assets/local_items/関東地方/栃木/しもつかれ.png', description: '鮭の頭や大豆、野菜などを煮込む栃木の郷土料理'),
  LocalItem(region: '関東', prefecture: '栃木県', name: '佐野ラーメン', threshold: 25, assetPath: 'assets/local_items/関東地方/栃木/佐野ラーメン.png', description: '青竹打ちの縮れ麺とあっさりスープが特徴の麺料理'),
  LocalItem(region: '関東', prefecture: '栃木県', name: '益子焼', threshold: 30, assetPath: 'assets/local_items/関東地方/栃木/益子焼.png', description: '素朴で温かみのある風合いが魅力の伝統的な陶器'),

  LocalItem(region: '関東', prefecture: '群馬県', name: 'こんにゃく', threshold: 5, assetPath: 'assets/local_items/関東地方/群馬/こんにゃく.png', description: '日本一の生産量を誇る\n群馬を代表する農産加工品'),
  LocalItem(region: '関東', prefecture: '群馬県', name: '焼きまんじゅう', threshold: 10, assetPath: 'assets/local_items/関東地方/群馬/焼きまんじゅう.png', description: 'まんじゅうを串に刺し甘い味噌だれで焼く郷土食'),
  LocalItem(region: '関東', prefecture: '群馬県', name: 'おっきりこみ', threshold: 15, assetPath: 'assets/local_items/関東地方/群馬/おっきりこみ.png', description: '幅広の生麺と野菜を一緒に煮込む群馬の郷土料理'),
  LocalItem(region: '関東', prefecture: '群馬県', name: '水沢うどん', threshold: 20, assetPath: 'assets/local_items/関東地方/群馬/水沢うどん.png', description: '透明感のある麺と\n強いコシを楽しめる名物うどん'),
  LocalItem(region: '関東', prefecture: '群馬県', name: '下仁田ねぎ', threshold: 25, assetPath: 'assets/local_items/関東地方/群馬/下仁田ねぎ.png', description: '太く柔らかく、加熱すると強い甘みが出る冬の特産品'),
  LocalItem(region: '関東', prefecture: '群馬県', name: '桐生織', threshold: 30, assetPath: 'assets/local_items/関東地方/群馬/桐生織.png', description: '長い歴史と高度な技術を受け継ぐ群馬の伝統的な織物'),

  LocalItem(region: '関東', prefecture: '埼玉県', name: '草加せんべい', threshold: 5, assetPath: 'assets/local_items/関東地方/埼玉/草加せんべい.png', description: '堅めに焼いた生地へ醤油を塗る\n香ばしい米菓'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: '武蔵野うどん', threshold: 10, assetPath: 'assets/local_items/関東地方/埼玉/武蔵野うどん.png', description: '強いコシの太麺を肉や\n野菜入りのつけ汁で味わう'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: 'ゼリーフライ', threshold: 15, assetPath: 'assets/local_items/関東地方/埼玉/ゼリーフライ.png', description: 'おからとじゃがいもを混ぜて揚げる行田の郷土食'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: 'みそポテト', threshold: 20, assetPath: 'assets/local_items/関東地方/埼玉/みそポテト.png', description: '揚げたじゃがいもに\n甘辛い味噌だれをかける郷土食'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: '川越いも菓子', threshold: 25, assetPath: 'assets/local_items/関東地方/埼玉/川越いも菓子.png', description: 'さつまいもの自然な甘みを生かした川越の名物菓子'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: '岩槻人形', threshold: 30, assetPath: 'assets/local_items/関東地方/埼玉/岩槻人形.png', description: '精巧な顔立ちや衣装が美しい\n伝統的な節句人形'),

  LocalItem(region: '関東', prefecture: '千葉県', name: '日本なし', threshold: 5, assetPath: 'assets/local_items/関東地方/千葉/日本なし.png', description: '日本一の生産量を誇る\nみずみずしく甘い千葉の果物'),
  LocalItem(region: '関東', prefecture: '千葉県', name: '落花生', threshold: 10, assetPath: 'assets/local_items/関東地方/千葉/落花生.png', description: '日本一の生産量を誇る\n香ばしい風味が魅力の農産物'),
  LocalItem(region: '関東', prefecture: '千葉県', name: 'なめろう', threshold: 15, assetPath: 'assets/local_items/関東地方/千葉/なめろう.png', description: '新鮮な魚を味噌や薬味と一緒に\n細かく叩いた郷土料理'),
  LocalItem(region: '関東', prefecture: '千葉県', name: 'さんが焼き', threshold: 20, assetPath: 'assets/local_items/関東地方/千葉/さんが焼き.png', description: 'なめろうを焼いて香ばしく仕上げた房総の漁師料理'),
  LocalItem(region: '関東', prefecture: '千葉県', name: '太巻き祭り寿司', threshold: 25, assetPath: 'assets/local_items/関東地方/千葉/太巻き祭り寿司.png', description: '切り口に花などの模様を描く\n華やかな太巻き寿司'),
  LocalItem(region: '関東', prefecture: '千葉県', name: '房州うちわ', threshold: 30, assetPath: 'assets/local_items/関東地方/千葉/房州うちわ.png', description: '丸い竹の骨と美しい装飾が特徴の伝統的なうちわ'),

  LocalItem(region: '関東', prefecture: '東京都', name: 'もんじゃ焼き', threshold: 5, assetPath: 'assets/local_items/関東地方/東京/もんじゃ焼き.png', description: '具材入りのゆるい生地を\n鉄板で焼いて楽しむ下町料理'),
  LocalItem(region: '関東', prefecture: '東京都', name: '深川めし', threshold: 10, assetPath: 'assets/local_items/関東地方/東京/深川めし.png', description: 'あさりなどの貝を使った江戸から\n親しまれる郷土料理'),
  LocalItem(region: '関東', prefecture: '東京都', name: 'どじょう鍋', threshold: 15, assetPath: 'assets/local_items/関東地方/東京/どじょう鍋.png', description: 'どじょうを割下などで煮て味わう\n江戸の伝統料理'),
  LocalItem(region: '関東', prefecture: '東京都', name: '人形焼', threshold: 20, assetPath: 'assets/local_items/関東地方/東京/人形焼.png', description: '人や動物などをかたどり\n餡を入れて焼き上げる菓子'),
  LocalItem(region: '関東', prefecture: '東京都', name: 'べっこう寿司', threshold: 25, assetPath: 'assets/local_items/関東地方/東京/べっこう寿司.png', description: '島とうがらし醤油に魚を漬けた\n伊豆諸島の郷土寿司'),
  LocalItem(region: '関東', prefecture: '東京都', name: '江戸切子', threshold: 30, assetPath: 'assets/local_items/関東地方/東京/江戸切子.png', description: 'ガラスの表面を繊細に削り美しい文様を描く伝統工芸'),

  LocalItem(region: '関東', prefecture: '神奈川県', name: 'シュウマイ', threshold: 5, assetPath: 'assets/local_items/関東地方/神奈川/シュウマイ.png', description: '肉や玉ねぎなどの餡を\n皮で包んで蒸す横浜名物'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: 'サンマーメン', threshold: 10, assetPath: 'assets/local_items/関東地方/神奈川/サンマーメン.png', description: '野菜入りの熱い餡をのせた\n神奈川発祥の麺料理'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: 'しらす丼', threshold: 15, assetPath: 'assets/local_items/関東地方/神奈川/しらす丼.png', description: '新鮮なしらすをご飯に\nたっぷりのせて味わう海の料理'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: 'かまぼこ', threshold: 20, assetPath: 'assets/local_items/関東地方/神奈川/かまぼこ.png', description: '魚のすり身を蒸したり焼いたりして仕上げる小田原名物'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: '牛鍋', threshold: 25, assetPath: 'assets/local_items/関東地方/神奈川/牛鍋.png', description: '牛肉と野菜を甘辛い割下で煮込む横浜ゆかりの料理'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: '鎌倉彫', threshold: 30, assetPath: 'assets/local_items/関東地方/神奈川/鎌倉彫.png', description: '木地に文様を彫り漆を塗って\n仕上げる伝統的な漆工芸'),

  LocalItem(region: '中部', prefecture: '新潟県', name: '米', threshold: 5, assetPath: 'assets/local_items/中部地方/新潟/米.png', description: '全国有数の生産量を誇る\n雪国の水と大地が育む新潟の味'),
  LocalItem(region: '中部', prefecture: '新潟県', name: 'へぎそば', threshold: 10, assetPath: 'assets/local_items/中部地方/新潟/へぎそば.png', description: '海藻をつなぎに使い、へぎへ\n美しく盛り付けるそば'),
  LocalItem(region: '中部', prefecture: '新潟県', name: '笹団子', threshold: 15, assetPath: 'assets/local_items/中部地方/新潟/笹団子.png', description: 'よもぎ入りの餅で餡を包み\n笹の葉で巻いて蒸した菓子'),
  LocalItem(region: '中部', prefecture: '新潟県', name: 'のっぺ', threshold: 20, assetPath: 'assets/local_items/中部地方/新潟/のっぺ.png', description: '里芋や野菜などをとろりと煮込む\n新潟伝統の郷土料理'),
  LocalItem(region: '中部', prefecture: '新潟県', name: '栃尾油揚げ', threshold: 25, assetPath: 'assets/local_items/中部地方/新潟/栃尾油揚げ.png', description: '一般的な油揚げより厚く大きい\n食べ応えのある名物'),
  LocalItem(region: '中部', prefecture: '新潟県', name: '小千谷縮', threshold: 30, assetPath: 'assets/local_items/中部地方/新潟/小千谷縮.png', description: '細かなシボと涼しい肌触りが特徴の伝統的な麻織物'),

  LocalItem(region: '中部', prefecture: '富山県', name: 'ます寿司', threshold: 5, assetPath: 'assets/local_items/中部地方/富山/ます寿司.png', description: '酢飯に鱒をのせて笹で包み押して作る富山の郷土寿司'),
  LocalItem(region: '中部', prefecture: '富山県', name: '白えび', threshold: 10, assetPath: 'assets/local_items/中部地方/富山/白えび.png', description: '透明感ある白い姿と\n上品な甘みから珍重される海の幸'),
  LocalItem(region: '中部', prefecture: '富山県', name: 'ホタルイカ', threshold: 15, assetPath: 'assets/local_items/中部地方/富山/ホタルイカ.png', description: '春の富山湾を代表する\n小さく青白く光る海産物'),
  LocalItem(region: '中部', prefecture: '富山県', name: '富山ブラックラーメン', threshold: 20, assetPath: 'assets/local_items/中部地方/富山/富山ブラックラーメン.png', description: '濃い色の醤油スープが特徴の\nご当地ラーメン'),
  LocalItem(region: '中部', prefecture: '富山県', name: '昆布締め', threshold: 25, assetPath: 'assets/local_items/中部地方/富山/昆布締め.png', description: '刺身を昆布で挟み、うま味を移して味わう郷土料理'),
  LocalItem(region: '中部', prefecture: '富山県', name: '井波彫刻', threshold: 30, assetPath: 'assets/local_items/中部地方/富山/井波彫刻.png', description: '木材に立体的で緻密な模様を\n刻み込む伝統的な木彫'),

  LocalItem(region: '中部', prefecture: '石川県', name: '治部煮', threshold: 5, assetPath: 'assets/local_items/中部地方/石川/治部煮.png', description: '鴨肉などに粉をまぶし野菜と\n煮合わせる加賀の郷土料理'),
  LocalItem(region: '中部', prefecture: '石川県', name: 'かぶら寿司', threshold: 10, assetPath: 'assets/local_items/中部地方/石川/かぶら寿司.png', description: 'かぶに魚を挟み米麹で発酵させる冬の伝統的な食品'),
  LocalItem(region: '中部', prefecture: '石川県', name: 'のどぐろ', threshold: 15, assetPath: 'assets/local_items/中部地方/石川/のどぐろ.png', description: '脂のりと上品な甘みで知られる\n日本海の高級魚'),
  LocalItem(region: '中部', prefecture: '石川県', name: 'ハントンライス', threshold: 20, assetPath: 'assets/local_items/中部地方/石川/ハントンライス.png', description: 'ケチャップライスに卵や揚げ物を\nのせる洋食料理'),
  LocalItem(region: '中部', prefecture: '石川県', name: '加賀棒茶', threshold: 25, assetPath: 'assets/local_items/中部地方/石川/加賀棒茶.png', description: '茶の茎を香ばしく焙煎した\nすっきり風味のお茶'),
  LocalItem(region: '中部', prefecture: '石川県', name: '輪島塗', threshold: 30, assetPath: 'assets/local_items/中部地方/石川/輪島塗.png', description: '丈夫な下地と美しい漆の艶を持つ石川伝統の漆器'),

  LocalItem(region: '中部', prefecture: '福井県', name: '越前がに', threshold: 5, assetPath: 'assets/local_items/中部地方/福井/越前がに.png', description: '冬の日本海で水揚げされる\n身の甘みが豊かなズワイガニ'),
  LocalItem(region: '中部', prefecture: '福井県', name: '越前おろしそば', threshold: 10, assetPath: 'assets/local_items/中部地方/福井/越前おろしそば.png', description: 'そばに辛味大根おろしを合わせる福井の郷土食'),
  LocalItem(region: '中部', prefecture: '福井県', name: 'へしこ', threshold: 15, assetPath: 'assets/local_items/中部地方/福井/へしこ.png', description: '魚を塩漬け後に米ぬかへ漬け込み熟成させた保存食'),
  LocalItem(region: '中部', prefecture: '福井県', name: '羽二重餅', threshold: 20, assetPath: 'assets/local_items/中部地方/福井/羽二重餅.png', description: 'きめ細かく柔らかな食感が特徴の福井を代表する和菓子'),
  LocalItem(region: '中部', prefecture: '福井県', name: '越前和紙', threshold: 25, assetPath: 'assets/local_items/中部地方/福井/越前和紙.png', description: '丈夫で美しい質感を持ち長い歴史を誇る伝統的な和紙'),
  LocalItem(region: '中部', prefecture: '福井県', name: '若狭塗', threshold: 30, assetPath: 'assets/local_items/中部地方/福井/若狭塗.png', description: '貝殻などを用いた華やかな模様が特徴の伝統漆器'),

  LocalItem(region: '中部', prefecture: '山梨県', name: 'ぶどう', threshold: 5, assetPath: 'assets/local_items/中部地方/山梨/ぶどう.png', description: '日本一の生産量を誇る\n山梨を代表する果物'),
  LocalItem(region: '中部', prefecture: '山梨県', name: 'もも', threshold: 10, assetPath: 'assets/local_items/中部地方/山梨/もも.png', description: '日本一の生産量を誇る\n香りと甘み豊かな山梨の果物'),
  LocalItem(region: '中部', prefecture: '山梨県', name: 'ほうとう', threshold: 15, assetPath: 'assets/local_items/中部地方/山梨/ほうとう.png', description: '幅広の麺と野菜を味噌仕立ての\n汁で煮込む郷土料理'),
  LocalItem(region: '中部', prefecture: '山梨県', name: '鳥もつ煮', threshold: 20, assetPath: 'assets/local_items/中部地方/山梨/鳥もつ煮.png', description: '鶏のもつを甘辛いたれで\n照りよく煮付けた料理'),
  LocalItem(region: '中部', prefecture: '山梨県', name: '吉田のうどん', threshold: 25, assetPath: 'assets/local_items/中部地方/山梨/吉田のうどん.png', description: '非常に強いコシの太麺と\n味噌系つゆが特徴のうどん'),
  LocalItem(region: '中部', prefecture: '山梨県', name: '甲州水晶貴石細工', threshold: 30, assetPath: 'assets/local_items/中部地方/山梨/甲州水晶貴石細工.png', description: '水晶などの天然石を磨き加工する伝統的な工芸'),

  LocalItem(region: '中部', prefecture: '長野県', name: 'おやき', threshold: 5, assetPath: 'assets/local_items/中部地方/長野/おやき.png', description: '小麦などの生地で野菜や餡を包み焼いた山里の郷土食'),
  LocalItem(region: '中部', prefecture: '長野県', name: '信州そば', threshold: 10, assetPath: 'assets/local_items/中部地方/長野/信州そば.png', description: '冷涼な土地で育ったそばを使う\n長野を代表する麺料理'),
  LocalItem(region: '中部', prefecture: '長野県', name: '野沢菜漬け', threshold: 15, assetPath: 'assets/local_items/中部地方/長野/野沢菜漬け.png', description: '野沢菜を塩などで漬け込んだ\n信州定番の漬物'),
  LocalItem(region: '中部', prefecture: '長野県', name: '山賊焼き', threshold: 20, assetPath: 'assets/local_items/中部地方/長野/山賊焼き.png', description: '味付けした大きな鶏肉を衣で\n豪快に揚げた郷土料理'),
  LocalItem(region: '中部', prefecture: '長野県', name: '寒天', threshold: 25, assetPath: 'assets/local_items/中部地方/長野/寒天.png', description: '海藻から作られ、和菓子や料理に広く使われる伝統食品'),
  LocalItem(region: '中部', prefecture: '長野県', name: '木曽漆器', threshold: 30, assetPath: 'assets/local_items/中部地方/長野/木曽漆器.png', description: '木地に漆を重ねて丈夫に仕上げる木曽地方の伝統工芸'),

  LocalItem(region: '中部', prefecture: '岐阜県', name: '朴葉味噌', threshold: 5, assetPath: 'assets/local_items/中部地方/岐阜/朴葉味噌.png', description: '朴葉の上で味噌や具材を\n焼きながら味わう飛騨の料理'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '鶏ちゃん', threshold: 10, assetPath: 'assets/local_items/中部地方/岐阜/鶏ちゃん.png', description: '鶏肉と野菜を味噌や醤油だれで\n炒める岐阜の郷土料理'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '鮎料理', threshold: 15, assetPath: 'assets/local_items/中部地方/岐阜/鮎料理.png', description: '清流で育つ鮎を塩焼きや\n甘露煮などで味わう郷土の味'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '栗きんとん', threshold: 20, assetPath: 'assets/local_items/中部地方/岐阜/栗きんとん.png', description: '炊いた栗をつぶし茶巾形に整えた素朴な和菓子'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '肉寿司', threshold: 25, assetPath: 'assets/local_items/中部地方/岐阜/肉寿司.png', description: '薄切りの牛肉を酢飯にのせた\n旨み豊かな肉の握り寿司。'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '関の刃物', threshold: 30, assetPath: 'assets/local_items/中部地方/岐阜/関の刃物.png', description: '刀鍛冶の技を受け継ぐ\n鋭い切れ味の刃物'),

  LocalItem(region: '中部', prefecture: '静岡県', name: 'わさび', threshold: 5, assetPath: 'assets/local_items/中部地方/静岡/わさび.png', description: '清らかな水で育てられ\n爽やかな辛味と香りを持つ特産品'),
  LocalItem(region: '中部', prefecture: '静岡県', name: '桜えび', threshold: 10, assetPath: 'assets/local_items/中部地方/静岡/桜えび.png', description: '国内では主に駿河湾で漁獲される鮮やかな小型のえび'),
  LocalItem(region: '中部', prefecture: '静岡県', name: 'うなぎ', threshold: 15, assetPath: 'assets/local_items/中部地方/静岡/うなぎ.png', description: '香ばしく焼いてたれを絡める\n浜名湖周辺で有名な料理'),
  LocalItem(region: '中部', prefecture: '静岡県', name: '静岡おでん', threshold: 20, assetPath: 'assets/local_items/中部地方/静岡/静岡おでん.png', description: '黒いだし汁と魚粉などをかけて\n味わう静岡の郷土食'),
  LocalItem(region: '中部', prefecture: '静岡県', name: '安倍川もち', threshold: 25, assetPath: 'assets/local_items/中部地方/静岡/安倍川もち.png', description: '柔らかな餅にきな粉や餡を絡める伝統的な和菓子'),
  LocalItem(region: '中部', prefecture: '静岡県', name: '駿河竹千筋細工', threshold: 30, assetPath: 'assets/local_items/中部地方/静岡/駿河竹千筋細工.png', description: '細い竹ひごを組み、美しい曲線を\n作る伝統工芸'),

  LocalItem(region: '中部', prefecture: '愛知県', name: 'ひつまぶし', threshold: 5, assetPath: 'assets/local_items/中部地方/愛知/ひつまぶし.png', description: '細かく切ったうなぎをご飯と\n薬味やだしで楽しむ料理'),
  LocalItem(region: '中部', prefecture: '愛知県', name: '味噌煮込みうどん', threshold: 10, assetPath: 'assets/local_items/中部地方/愛知/味噌煮込みうどん.png', description: '濃厚な豆味噌のつゆで\n硬めの麺を煮込む料理'),
  LocalItem(region: '中部', prefecture: '愛知県', name: '手羽先', threshold: 15, assetPath: 'assets/local_items/中部地方/愛知/手羽先.png', description: '鶏の手羽を香ばしく揚げ\n甘辛いたれなどで味付けした料理'),
  LocalItem(region: '中部', prefecture: '愛知県', name: 'きしめん', threshold: 20, assetPath: 'assets/local_items/中部地方/愛知/きしめん.png', description: '幅広で平たい麺をだしの効いた\nつゆで味わう名古屋の麺'),
  LocalItem(region: '中部', prefecture: '愛知県', name: 'ういろう', threshold: 25, assetPath: 'assets/local_items/中部地方/愛知/ういろう.png', description: '米粉などを蒸して作る\nもちもち食感の伝統的な菓子'),
  LocalItem(region: '中部', prefecture: '愛知県', name: '瀬戸焼', threshold: 30, assetPath: 'assets/local_items/中部地方/愛知/瀬戸焼.png', description: '長い陶磁器文化を持ち\n日用品にも広く使われる焼き物'),

  LocalItem(region: '近畿', prefecture: '三重県', name: '伊勢うどん', threshold: 5, assetPath: 'assets/local_items/近畿/三重/伊勢うどん.png', description: '極太の柔らかな麺に濃厚なたれを絡めて食べる郷土食'),
  LocalItem(region: '近畿', prefecture: '三重県', name: 'てこね寿司', threshold: 10, assetPath: 'assets/local_items/近畿/三重/てこね寿司.png', description: '醤油だれに漬けた魚を\nご飯にのせる志摩の郷土寿司'),
  LocalItem(region: '近畿', prefecture: '三重県', name: '伊勢えび', threshold: 15, assetPath: 'assets/local_items/近畿/三重/伊勢えび.png', description: '長いひげと鮮やかな姿\n濃厚な甘みが魅力の高級海産物'),
  LocalItem(region: '近畿', prefecture: '三重県', name: 'さんま寿司', threshold: 20, assetPath: 'assets/local_items/近畿/三重/さんま寿司.png', description: '酢で締めたさんまを\nご飯にのせて作る熊野地方の寿司'),
  LocalItem(region: '近畿', prefecture: '三重県', name: '伊賀焼', threshold: 25, assetPath: 'assets/local_items/近畿/三重/伊賀焼.png', description: '粗い土と力強い風合いが特徴の\n三重伝統の陶器'),
  LocalItem(region: '近畿', prefecture: '三重県', name: '伊勢形紙', threshold: 30, assetPath: 'assets/local_items/近畿/三重/伊勢形紙.png', description: '着物の染色文様を彫り抜くために作られる伝統工芸品'),

  LocalItem(region: '近畿', prefecture: '滋賀県', name: '鮒寿司', threshold: 5, assetPath: 'assets/local_items/近畿/滋賀/鮒寿司.png', description: 'ふなを米と塩で長期間発酵させる滋賀伝統のなれずし'),
  LocalItem(region: '近畿', prefecture: '滋賀県', name: '近江牛', threshold: 10, assetPath: 'assets/local_items/近畿/滋賀/近江牛.png', description: '滋賀の豊かな環境で育てられる\nきめ細かな肉質の和牛'),
  LocalItem(region: '近畿', prefecture: '滋賀県', name: '赤こんにゃく', threshold: 15, assetPath: 'assets/local_items/近畿/滋賀/赤こんにゃく.png', description: '鮮やかな赤色と弾力ある食感が\n特徴の滋賀の食品'),
  LocalItem(region: '近畿', prefecture: '滋賀県', name: '焼鯖そうめん', threshold: 20, assetPath: 'assets/local_items/近畿/滋賀/焼鯖そうめん.png', description: '焼いた鯖を甘辛く煮てそうめんと\n合わせる郷土料理'),
  LocalItem(region: '近畿', prefecture: '滋賀県', name: '信楽焼', threshold: 25, assetPath: 'assets/local_items/近畿/滋賀/信楽焼.png', description: '狸の置物などでも親しまれる\n素朴な風合いの陶器'),
  LocalItem(region: '近畿', prefecture: '滋賀県', name: '近江上布', threshold: 30, assetPath: 'assets/local_items/近畿/滋賀/近江上布.png', description: '麻を使い涼しく軽やかに織り上げる滋賀の伝統織物'),

  LocalItem(region: '近畿', prefecture: '京都府', name: '湯豆腐', threshold: 5, assetPath: 'assets/local_items/近畿/京都/湯豆腐.png', description: '昆布だしで豆腐を温め薬味とともに味わう京都の料理'),
  LocalItem(region: '近畿', prefecture: '京都府', name: 'にしんそば', threshold: 10, assetPath: 'assets/local_items/近畿/京都/にしんそば.png', description: '甘辛く煮た身欠きにしんを\nそばにのせた京都の麺料理'),
  LocalItem(region: '近畿', prefecture: '京都府', name: '八つ橋', threshold: 15, assetPath: 'assets/local_items/近畿/京都/八つ橋.png', description: '米粉を使った生地と香りが\n特徴の京都を代表する和菓子'),
  LocalItem(region: '近畿', prefecture: '京都府', name: '千枚漬け', threshold: 20, assetPath: 'assets/local_items/近畿/京都/千枚漬け.png', description: '薄く切ったかぶを昆布などと\n漬け込む京都の伝統漬物'),
  LocalItem(region: '近畿', prefecture: '京都府', name: '鯖寿司', threshold: 25, assetPath: 'assets/local_items/近畿/京都/鯖寿司.png', description: '締めた鯖を酢飯と合わせて作る\n京都で親しまれる押し寿司'),
  LocalItem(region: '近畿', prefecture: '京都府', name: '西陣織', threshold: 30, assetPath: 'assets/local_items/近畿/京都/西陣織.png', description: '多彩な糸を使い豪華な文様を\n織り上げる伝統的な絹織物'),

  LocalItem(region: '近畿', prefecture: '大阪府', name: 'たこ焼き', threshold: 5, assetPath: 'assets/local_items/近畿/大阪/たこ焼き.png', description: '生地にたこを入れて丸く焼き上げる大阪定番の粉もの'),
  LocalItem(region: '近畿', prefecture: '大阪府', name: 'お好み焼き', threshold: 10, assetPath: 'assets/local_items/近畿/大阪/お好み焼き.png', description: '生地にキャベツや具材を混ぜ\n鉄板で焼き上げる料理'),
  LocalItem(region: '近畿', prefecture: '大阪府', name: '串カツ', threshold: 15, assetPath: 'assets/local_items/近畿/大阪/串カツ.png', description: '肉や野菜を串に刺し衣を付けて\n香ばしく揚げる大阪名物'),
  LocalItem(region: '近畿', prefecture: '大阪府', name: 'きつねうどん', threshold: 20, assetPath: 'assets/local_items/近畿/大阪/きつねうどん.png', description: '甘辛く煮た油揚げをうどんにのせた大阪ゆかりの料理'),
  LocalItem(region: '近畿', prefecture: '大阪府', name: 'どて焼き', threshold: 25, assetPath: 'assets/local_items/近畿/大阪/どて焼き.png', description: '牛すじなどを味噌で柔らかく煮込む大阪の庶民料理'),
  LocalItem(region: '近畿', prefecture: '大阪府', name: '大阪浪華錫器', threshold: 30, assetPath: 'assets/local_items/近畿/大阪/大阪浪華錫器.png', description: '錫を加工し美しく丈夫な器に\n仕上げる伝統工芸品'),

  LocalItem(region: '近畿', prefecture: '兵庫県', name: '明石焼き', threshold: 5, assetPath: 'assets/local_items/近畿/兵庫/明石焼き.png', description: '卵を多く使った柔らかな生地に\nたこを入れ、だしで味わう'),
  LocalItem(region: '近畿', prefecture: '兵庫県', name: 'そばめし', threshold: 10, assetPath: 'assets/local_items/近畿/兵庫/そばめし.png', description: '焼きそばの麺を細かく刻み\nご飯と炒める神戸の料理'),
  LocalItem(region: '近畿', prefecture: '兵庫県', name: 'ぼっかけ', threshold: 15, assetPath: 'assets/local_items/近畿/兵庫/ぼっかけ.png', description: '牛すじとこんにゃくを\n甘辛く煮込んだ神戸の郷土料理'),
  LocalItem(region: '近畿', prefecture: '兵庫県', name: 'いかなごのくぎ煮', threshold: 20, assetPath: 'assets/local_items/近畿/兵庫/いかなごのくぎ煮.png', description: '小魚を醤油や砂糖で\n甘辛く炊き上げる春の郷土食'),
  LocalItem(region: '近畿', prefecture: '兵庫県', name: '丹波黒豆', threshold: 25, assetPath: 'assets/local_items/近畿/兵庫/丹波黒豆.png', description: '大粒でふっくらとした\n食感と深い味わいを持つ黒大豆'),
  LocalItem(region: '近畿', prefecture: '兵庫県', name: '播州そろばん', threshold: 30, assetPath: 'assets/local_items/近畿/兵庫/播州そろばん.png', description: '精密な加工技術で作られる\n兵庫伝統のそろばん'),

  LocalItem(region: '近畿', prefecture: '奈良県', name: '柿の葉寿司', threshold: 5, assetPath: 'assets/local_items/近畿/奈良/柿の葉寿司.png', description: '酢飯と魚を柿の葉で包み\n香り豊かに仕上げる郷土寿司'),
  LocalItem(region: '近畿', prefecture: '奈良県', name: '三輪そうめん', threshold: 10, assetPath: 'assets/local_items/近畿/奈良/三輪そうめん.png', description: '細く強いコシと滑らかな\n喉越しを持つ伝統のそうめん'),
  LocalItem(region: '近畿', prefecture: '奈良県', name: '奈良漬', threshold: 15, assetPath: 'assets/local_items/近畿/奈良/奈良漬.png', description: '野菜などを酒粕へ繰り返し漬け\n込み熟成させた伝統漬物'),
  LocalItem(region: '近畿', prefecture: '奈良県', name: '茶粥', threshold: 20, assetPath: 'assets/local_items/近畿/奈良/茶粥.png', description: '米を番茶などでさらりと炊き上げる奈良の素朴な郷土料理'),
  LocalItem(region: '近畿', prefecture: '奈良県', name: '吉野葛', threshold: 25, assetPath: 'assets/local_items/近畿/奈良/吉野葛.png', description: '葛の根から取ったでんぷんを\n精製して作る伝統食材'),
  LocalItem(region: '近畿', prefecture: '奈良県', name: '奈良筆', threshold: 30, assetPath: 'assets/local_items/近畿/奈良/奈良筆.png', description: '選び抜いた獣毛を組み合わせ\n手作業で仕上げる伝統工芸品'),

  LocalItem(region: '近畿', prefecture: '和歌山県', name: '梅', threshold: 5, assetPath: 'assets/local_items/近畿/和歌山/梅.png', description: '日本一の生産量を誇る\n和歌山を代表する果実'),
  LocalItem(region: '近畿', prefecture: '和歌山県', name: 'みかん', threshold: 10, assetPath: 'assets/local_items/近畿/和歌山/みかん.png', description: '日本一の生産量を誇る\n甘み豊かな和歌山の果物'),
  LocalItem(region: '近畿', prefecture: '和歌山県', name: 'めはり寿司', threshold: 15, assetPath: 'assets/local_items/近畿/和歌山/めはり寿司.png', description: 'ご飯を高菜の漬物の葉で\n大きく包んだ郷土料理'),
  LocalItem(region: '近畿', prefecture: '和歌山県', name: '和歌山ラーメン', threshold: 20, assetPath: 'assets/local_items/近畿/和歌山/和歌山ラーメン.png', description: '豚骨醤油などの濃厚なスープで\n親しまれる中華そば'),
  LocalItem(region: '近畿', prefecture: '和歌山県', name: '金山寺味噌', threshold: 25, assetPath: 'assets/local_items/近畿/和歌山/金山寺味噌.png', description: '野菜などを加えて熟成させ\nそのまま食べるなめ味噌'),
  LocalItem(region: '近畿', prefecture: '和歌山県', name: '紀州漆器', threshold: 30, assetPath: 'assets/local_items/近畿/和歌山/紀州漆器.png', description: '温かみある漆の艶と丈夫さが\n魅力の伝統的な漆器'),

  LocalItem(region: '中国・四国', prefecture: '鳥取県', name: '牛骨ラーメン', threshold: 5, assetPath: 'assets/local_items/中国・四国/鳥取/牛骨ラーメン.png', description: '牛骨から取った香ばしいスープが特徴のご当地麺'),
  LocalItem(region: '中国・四国', prefecture: '鳥取県', name: 'とうふちくわ', threshold: 10, assetPath: 'assets/local_items/中国・四国/鳥取/とうふちくわ.png', description: '豆腐と魚のすり身を混ぜて竹輪状に仕上げた食品'),
  LocalItem(region: '中国・四国', prefecture: '鳥取県', name: 'いただき', threshold: 15, assetPath: 'assets/local_items/中国・四国/鳥取/いただき.png', description: '油揚げに米や野菜を詰め\nだしで炊き上げる郷土料理'),
  LocalItem(region: '中国・四国', prefecture: '鳥取県', name: 'らっきょう', threshold: 20, assetPath: 'assets/local_items/中国・四国/鳥取/らっきょう.png', description: '砂丘地などで栽培され\nシャキッとした食感を楽しむ特産品'),
  LocalItem(region: '中国・四国', prefecture: '鳥取県', name: 'あごちくわ', threshold: 25, assetPath: 'assets/local_items/中国・四国/鳥取/あごちくわ.png', description: '飛魚のすり身を使い香ばしく\n焼き上げた魚肉練り製品'),
  LocalItem(region: '中国・四国', prefecture: '鳥取県', name: '因州和紙', threshold: 30, assetPath: 'assets/local_items/中国・四国/鳥取/因州和紙.png', description: '丈夫さと美しい風合いで知られる\n鳥取伝統の和紙'),

  LocalItem(region: '中国・四国', prefecture: '島根県', name: '出雲そば', threshold: 5, assetPath: 'assets/local_items/中国・四国/島根/出雲そば.png', description: '殻ごと挽いた色の濃いそばを\n割子などで楽しむ郷土食'),
  LocalItem(region: '中国・四国', prefecture: '島根県', name: 'しじみ', threshold: 10, assetPath: 'assets/local_items/中国・四国/島根/しじみ.png', description: '宍道湖などで漁獲され、濃いうま味を持つ島根の湖の幸'),
  LocalItem(region: '中国・四国', prefecture: '島根県', name: '赤天', threshold: 15, assetPath: 'assets/local_items/中国・四国/島根/赤天.png', description: '魚のすり身へ唐辛子を加え\n赤く仕上げたピリ辛の練り物'),
  LocalItem(region: '中国・四国', prefecture: '島根県', name: 'うずめ飯', threshold: 20, assetPath: 'assets/local_items/中国・四国/島根/うずめ飯.png', description: 'ご飯の下に具材を隠し、\nだしをかけて味わう郷土料理'),
  LocalItem(region: '中国・四国', prefecture: '島根県', name: '松江の和菓子', threshold: 25, assetPath: 'assets/local_items/中国・四国/島根/松江の和菓子.png', description: '茶の湯文化とともに発達した\n美しく上品な和菓子'),
  LocalItem(region: '中国・四国', prefecture: '島根県', name: '石州和紙', threshold: 30, assetPath: 'assets/local_items/中国・四国/島根/石州和紙.png', description: '強靱で保存性が高く、\n長く使える島根伝統の和紙'),

  LocalItem(region: '中国・四国', prefecture: '岡山県', name: 'きびだんご', threshold: 5, assetPath: 'assets/local_items/中国・四国/岡山/きびだんご.png', description: 'もちもちした柔らかな食感を楽しむ岡山定番の和菓子'),
  LocalItem(region: '中国・四国', prefecture: '岡山県', name: 'デミカツ丼', threshold: 10, assetPath: 'assets/local_items/中国・四国/岡山/デミカツ丼.png', description: 'ご飯に豚カツをのせ濃厚な\nデミグラスソースをかける料理'),
  LocalItem(region: '中国・四国', prefecture: '岡山県', name: 'ばら寿司', threshold: 15, assetPath: 'assets/local_items/中国・四国/岡山/ばら寿司.png', description: '魚介や野菜など多彩な具材を\n華やかに散らした郷土寿司'),
  LocalItem(region: '中国・四国', prefecture: '岡山県', name: 'ままかり', threshold: 20, assetPath: 'assets/local_items/中国・四国/岡山/ままかり.png', description: '小魚を酢漬けや焼き物などで\n味わう岡山伝統の魚料理'),
  LocalItem(region: '中国・四国', prefecture: '岡山県', name: 'ひるぜん焼そば', threshold: 25, assetPath: 'assets/local_items/中国・四国/岡山/ひるぜん焼そば.png', description: '太めの麺と具材を濃厚な\n味噌だれで炒める料理'),
  LocalItem(region: '中国・四国', prefecture: '岡山県', name: '備前焼', threshold: 30, assetPath: 'assets/local_items/中国・四国/岡山/備前焼.png', description: '釉薬を使わず土と炎が生み出す\n模様を楽しむ伝統陶器'),

  LocalItem(region: '中国・四国', prefecture: '広島県', name: '広島風お好み焼き', threshold: 5, assetPath: 'assets/local_items/中国・四国/広島/広島風お好み焼き.png', description: '生地・野菜・麺などを重ねて\n焼き上げる広島の名物'),
  LocalItem(region: '中国・四国', prefecture: '広島県', name: '牡蠣', threshold: 10, assetPath: 'assets/local_items/中国・四国/広島/牡蠣.png', description: '日本一の生産量を誇る\n広島湾などで育つ濃厚な海の幸'),
  LocalItem(region: '中国・四国', prefecture: '広島県', name: 'あなご飯', threshold: 15, assetPath: 'assets/local_items/中国・四国/広島/あなご飯.png', description: '香ばしく焼いたあなごを\nご飯の上に並べる郷土料理'),
  LocalItem(region: '中国・四国', prefecture: '広島県', name: 'もみじ饅頭', threshold: 20, assetPath: 'assets/local_items/中国・四国/広島/もみじ饅頭.png', description: 'もみじ形の生地に餡などを入れて焼き上げる銘菓'),
  LocalItem(region: '中国・四国', prefecture: '広島県', name: 'レモン', threshold: 25, assetPath: 'assets/local_items/中国・四国/広島/レモン.png', description: '日本一の生産量を誇る\n瀬戸内の温暖な気候で育つ果実'),
  LocalItem(region: '中国・四国', prefecture: '広島県', name: '熊野筆', threshold: 30, assetPath: 'assets/local_items/中国・四国/広島/熊野筆.png', description: '穂先を丁寧に整えて作る\n書道や化粧用の伝統的な筆'),

  LocalItem(region: '中国・四国', prefecture: '山口県', name: 'ふぐ料理', threshold: 5, assetPath: 'assets/local_items/中国・四国/山口/ふぐ料理.png', description: '薄造りや鍋などさまざまな方法で\n楽しむ山口の魚料理'),
  LocalItem(region: '中国・四国', prefecture: '山口県', name: '瓦そば', threshold: 10, assetPath: 'assets/local_items/中国・四国/山口/瓦そば.png', description: '熱した瓦の上に茶そばと肉などを盛り付ける郷土料理'),
  LocalItem(region: '中国・四国', prefecture: '山口県', name: '岩国寿司', threshold: 15, assetPath: 'assets/local_items/中国・四国/山口/岩国寿司.png', description: '大きな型へ酢飯と具材を\n重ねて押し固める郷土寿司'),
  LocalItem(region: '中国・四国', prefecture: '山口県', name: '夏みかん', threshold: 20, assetPath: 'assets/local_items/中国・四国/山口/夏みかん.png', description: '爽やかな酸味と香りが特徴の\n山口ゆかりの柑橘類'),
  LocalItem(region: '中国・四国', prefecture: '山口県', name: 'チキンチキンごぼう', threshold: 25, assetPath: 'assets/local_items/中国・四国/山口/チキンチキンごぼう.png', description: '鶏肉とごぼうを揚げ\n甘辛いたれに絡めた料理'),
  LocalItem(region: '中国・四国', prefecture: '山口県', name: '大内塗', threshold: 30, assetPath: 'assets/local_items/中国・四国/山口/大内塗.png', description: '朱色を基調とした優雅な模様が\n特徴の伝統的な漆器'),

  LocalItem(region: '中国・四国', prefecture: '徳島県', name: 'すだち', threshold: 5, assetPath: 'assets/local_items/中国・四国/徳島/すだち.png', description: '日本一の生産量を誇る\n爽やかな香りと酸味の柑橘'),
  LocalItem(region: '中国・四国', prefecture: '徳島県', name: '鳴門わかめ', threshold: 10, assetPath: 'assets/local_items/中国・四国/徳島/鳴門わかめ.png', description: '激しい潮流の海で育つ、\n肉厚で歯応えのよい海藻'),
  LocalItem(region: '中国・四国', prefecture: '徳島県', name: '徳島ラーメン', threshold: 15, assetPath: 'assets/local_items/中国・四国/徳島/徳島ラーメン.png', description: '甘辛い豚肉と濃い色のスープが\n特徴のご当地麺'),
  LocalItem(region: '中国・四国', prefecture: '徳島県', name: 'そば米汁', threshold: 20, assetPath: 'assets/local_items/中国・四国/徳島/そば米汁.png', description: 'そばの実と野菜などをだし汁で\n煮込んだ郷土料理'),
  LocalItem(region: '中国・四国', prefecture: '徳島県', name: '阿波和紙', threshold: 25, assetPath: 'assets/local_items/中国・四国/徳島/阿波和紙.png', description: '楮などの植物を原料に手作業で\n漉き上げる伝統和紙'),
  LocalItem(region: '中国・四国', prefecture: '徳島県', name: '大谷焼', threshold: 30, assetPath: 'assets/local_items/中国・四国/徳島/大谷焼.png', description: '大きな甕などでも知られる\n力強い風合いの伝統陶器'),

  LocalItem(region: '中国・四国', prefecture: '香川県', name: '讃岐うどん', threshold: 5, assetPath: 'assets/local_items/中国・四国/香川/讃岐うどん.png', description: '強いコシとなめらかな喉越しで\n知られる香川の代表食'),
  LocalItem(region: '中国・四国', prefecture: '香川県', name: '骨付鳥', threshold: 10, assetPath: 'assets/local_items/中国・四国/香川/骨付鳥.png', description: '骨付きの鶏もも肉を香辛料とともに豪快に焼き上げる料理'),
  LocalItem(region: '中国・四国', prefecture: '香川県', name: 'しょうゆ豆', threshold: 15, assetPath: 'assets/local_items/中国・四国/香川/しょうゆ豆.png', description: 'そら豆を炒り甘辛い醤油だれに\n漬け込んだ郷土料理'),
  LocalItem(region: '中国・四国', prefecture: '香川県', name: 'オリーブ', threshold: 20, assetPath: 'assets/local_items/中国・四国/香川/オリーブ.png', description: '国内を代表する産地で栽培される香川の象徴的な農産物'),
  LocalItem(region: '中国・四国', prefecture: '香川県', name: '和三盆', threshold: 25, assetPath: 'assets/local_items/中国・四国/香川/和三盆.png', description: 'サトウキビを原料に伝統製法で\n作る口溶けのよい砂糖'),
  LocalItem(region: '中国・四国', prefecture: '香川県', name: '丸亀うちわ', threshold: 30, assetPath: 'assets/local_items/中国・四国/香川/丸亀うちわ.png', description: '竹を使い一本ずつ仕上げられる\n香川伝統のうちわ'),

  LocalItem(region: '中国・四国', prefecture: '愛媛県', name: '鯛めし', threshold: 5, assetPath: 'assets/local_items/中国・四国/愛媛/鯛めし.png', description: '鯛と米を一緒に炊くものなど\n地域で異なる愛媛の郷土料理'),
  LocalItem(region: '中国・四国', prefecture: '愛媛県', name: 'じゃこ天', threshold: 10, assetPath: 'assets/local_items/中国・四国/愛媛/じゃこ天.png', description: '小魚を骨ごとすりつぶして揚げた\n香ばしい練り製品'),
  LocalItem(region: '中国・四国', prefecture: '愛媛県', name: 'いよかん', threshold: 15, assetPath: 'assets/local_items/中国・四国/愛媛/いよかん.png', description: '爽やかな香りと甘酸っぱい果汁が魅力の愛媛の柑橘'),
  LocalItem(region: '中国・四国', prefecture: '愛媛県', name: '松山揚げ', threshold: 20, assetPath: 'assets/local_items/中国・四国/愛媛/松山揚げ.png', description: '水分を抑え、ふんわり軽く仕上げた保存性の高い油揚げ'),
  LocalItem(region: '中国・四国', prefecture: '愛媛県', name: '砥部焼', threshold: 25, assetPath: 'assets/local_items/中国・四国/愛媛/砥部焼.png', description: '厚手で丈夫な白磁に藍色の模様を描く伝統的な焼き物'),
  LocalItem(region: '中国・四国', prefecture: '愛媛県', name: '伊予絣', threshold: 30, assetPath: 'assets/local_items/中国・四国/愛媛/伊予絣.png', description: '藍染めの糸で素朴な模様を\n織り上げる愛媛伝統の織物'),

  LocalItem(region: '中国・四国', prefecture: '高知県', name: 'かつおのたたき', threshold: 5, assetPath: 'assets/local_items/中国・四国/高知/かつおのたたき.png', description: '表面を強火で炙り薬味とともに\n味わう高知の郷土料理'),
  LocalItem(region: '中国・四国', prefecture: '高知県', name: 'ゆず', threshold: 10, assetPath: 'assets/local_items/中国・四国/高知/ゆず.png', description: '日本一の生産量を誇る\n豊かな香りと酸味を持つ柑橘'),
  LocalItem(region: '中国・四国', prefecture: '高知県', name: '芋けんぴ', threshold: 15, assetPath: 'assets/local_items/中国・四国/高知/芋けんぴ.png', description: '細切りのさつまいもを揚げ糖蜜を\n絡めた高知の菓子'),
  LocalItem(region: '中国・四国', prefecture: '高知県', name: '皿鉢料理', threshold: 20, assetPath: 'assets/local_items/中国・四国/高知/皿鉢料理.png', description: '大皿に刺身や寿司など多彩な料理を盛る宴席料理'),
  LocalItem(region: '中国・四国', prefecture: '高知県', name: '土佐和紙', threshold: 25, assetPath: 'assets/local_items/中国・四国/高知/土佐和紙.png', description: '薄さと丈夫さを兼ね備えた\n高知の歴史ある伝統和紙'),
  LocalItem(region: '中国・四国', prefecture: '高知県', name: '土佐打刃物', threshold: 30, assetPath: 'assets/local_items/中国・四国/高知/土佐打刃物.png', description: '鍛造技術を受け継ぎ鋭い切れ味に仕上げる伝統刃物'),

  LocalItem(region: '九州', prefecture: '福岡県', name: '辛子明太子', threshold: 5, assetPath: 'assets/local_items/九州/福岡/辛子明太子.png', description: 'たらこの卵を唐辛子入り調味液で漬け込んだ名物'),
  LocalItem(region: '九州', prefecture: '福岡県', name: '博多ラーメン', threshold: 10, assetPath: 'assets/local_items/九州/福岡/博多ラーメン.png', description: '細いストレート麺と濃厚な\n豚骨スープが特徴の麺料理'),
  LocalItem(region: '九州', prefecture: '福岡県', name: '水炊き', threshold: 15, assetPath: 'assets/local_items/九州/福岡/水炊き.png', description: '鶏肉のうま味を生かした\n白濁スープで具材を煮る鍋料理'),
  LocalItem(region: '九州', prefecture: '福岡県', name: 'もつ鍋', threshold: 20, assetPath: 'assets/local_items/九州/福岡/もつ鍋.png', description: '牛などのもつと野菜を醤油や\n味噌味の汁で煮込む鍋料理'),
  LocalItem(region: '九州', prefecture: '福岡県', name: 'ごぼう天うどん', threshold: 25, assetPath: 'assets/local_items/九州/福岡/ごぼう天うどん.png', description: 'だしの効いたうどんに香ばしい\nごぼう天をのせる料理'),
  LocalItem(region: '九州', prefecture: '福岡県', name: '博多織', threshold: 30, assetPath: 'assets/local_items/九州/福岡/博多織.png', description: '細かな経糸と美しい献上柄などで知られる伝統的な織物'),

  LocalItem(region: '九州', prefecture: '佐賀県', name: '佐賀のり', threshold: 5, assetPath: 'assets/local_items/九州/佐賀/佐賀のり.png', description: '有明海の豊かな栄養で育つ\n口溶けとうま味のよい海苔'),
  LocalItem(region: '九州', prefecture: '佐賀県', name: 'いか活造り', threshold: 10, assetPath: 'assets/local_items/九州/佐賀/いか活造り.png', description: '新鮮ないかを透き通った\n刺身にして味わう魚料理'),
  LocalItem(region: '九州', prefecture: '佐賀県', name: 'シシリアンライス', threshold: 15, assetPath: 'assets/local_items/九州/佐賀/シシリアンライス.png', description: 'ご飯に肉や野菜、ソースを\n盛り付けるご当地料理'),
  LocalItem(region: '九州', prefecture: '佐賀県', name: '温泉湯豆腐', threshold: 20, assetPath: 'assets/local_items/九州/佐賀/温泉湯豆腐.png', description: '温泉水で豆腐を煮て\nとろりと柔らかく味わう料理'),
  LocalItem(region: '九州', prefecture: '佐賀県', name: '有田焼', threshold: 25, assetPath: 'assets/local_items/九州/佐賀/有田焼.png', description: '白い磁肌に美しい絵付けを施す\n歴史ある伝統的な磁器'),
  LocalItem(region: '九州', prefecture: '佐賀県', name: '伊万里焼', threshold: 30, assetPath: 'assets/local_items/九州/佐賀/伊万里焼.png', description: '華やかな色絵などで知られる\n佐賀を代表する磁器'),

  LocalItem(region: '九州', prefecture: '長崎県', name: 'カステラ', threshold: 5, assetPath: 'assets/local_items/九州/長崎/カステラ.png', description: '卵と砂糖をたっぷり使い\nしっとり焼き上げる伝統菓子'),
  LocalItem(region: '九州', prefecture: '長崎県', name: '長崎ちゃんぽん', threshold: 10, assetPath: 'assets/local_items/九州/長崎/長崎ちゃんぽん.png', description: '麺に魚介や肉、野菜をたっぷり\n合わせた長崎の料理'),
  LocalItem(region: '九州', prefecture: '長崎県', name: '皿うどん', threshold: 15, assetPath: 'assets/local_items/九州/長崎/皿うどん.png', description: '細い揚げ麺などに具だくさんの\n餡をかけて味わう麺料理'),
  LocalItem(region: '九州', prefecture: '長崎県', name: 'トルコライス', threshold: 20, assetPath: 'assets/local_items/九州/長崎/トルコライス.png', description: 'ピラフやパスタ、カツなどを一皿に盛る洋食料理'),
  LocalItem(region: '九州', prefecture: '長崎県', name: '角煮まんじゅう', threshold: 25, assetPath: 'assets/local_items/九州/長崎/角煮まんじゅう.png', description: '柔らかな豚の角煮をふわふわの\n生地で挟んだ料理'),
  LocalItem(region: '九州', prefecture: '長崎県', name: '波佐見焼', threshold: 30, assetPath: 'assets/local_items/九州/長崎/波佐見焼.png', description: '日常使いしやすい器として\n親しまれる長崎の磁器'),

  LocalItem(region: '九州', prefecture: '熊本県', name: '馬刺し', threshold: 5, assetPath: 'assets/local_items/九州/熊本/馬刺し.png', description: '新鮮な馬肉を薄切りにし薬味や\n醤油で味わう熊本の郷土食'),
  LocalItem(region: '九州', prefecture: '熊本県', name: 'からし蓮根', threshold: 10, assetPath: 'assets/local_items/九州/熊本/からし蓮根.png', description: '蓮根に辛子味噌を詰め衣を付けて揚げた郷土料理'),
  LocalItem(region: '九州', prefecture: '熊本県', name: '太平燕', threshold: 15, assetPath: 'assets/local_items/九州/熊本/太平燕.png', description: '春雨と野菜、肉や魚介をスープで\n味わう熊本の麺料理'),
  LocalItem(region: '九州', prefecture: '熊本県', name: 'いきなり団子', threshold: 20, assetPath: 'assets/local_items/九州/熊本/いきなり団子.png', description: 'さつまいもと餡を小麦生地で包んで蒸した郷土菓子'),
  LocalItem(region: '九州', prefecture: '熊本県', name: 'ひともじのぐるぐる', threshold: 25, assetPath: 'assets/local_items/九州/熊本/ひともじのぐるぐる.png', description: '茹でた青ねぎを巻き酢味噌を\n添える郷土料理'),
  LocalItem(region: '九州', prefecture: '熊本県', name: '小代焼', threshold: 30, assetPath: 'assets/local_items/九州/熊本/小代焼.png', description: '素朴で力強い釉薬の流れが魅力の熊本伝統の陶器'),

  LocalItem(region: '九州', prefecture: '大分県', name: 'とり天', threshold: 5, assetPath: 'assets/local_items/九州/大分/とり天.png', description: '鶏肉に衣を付けてふんわり揚げ、酢醤油などで味わう料理'),
  LocalItem(region: '九州', prefecture: '大分県', name: 'だんご汁', threshold: 10, assetPath: 'assets/local_items/九州/大分/だんご汁.png', description: '小麦粉を延ばした平たい団子と\n野菜を煮込む郷土料理'),
  LocalItem(region: '九州', prefecture: '大分県', name: 'りゅうきゅう', threshold: 15, assetPath: 'assets/local_items/九州/大分/りゅうきゅう.png', description: '刺身を醤油やごまなどの\nたれに漬け込む漁師料理'),
  LocalItem(region: '九州', prefecture: '大分県', name: 'かぼす', threshold: 20, assetPath: 'assets/local_items/九州/大分/かぼす.png', description: '日本一の生産量を誇る\n爽やかな香りの大分特産柑橘'),
  LocalItem(region: '九州', prefecture: '大分県', name: 'やせうま', threshold: 25, assetPath: 'assets/local_items/九州/大分/やせうま.png', description: '平たい小麦粉の生地に\nきな粉と砂糖をまぶす郷土菓子'),
  LocalItem(region: '九州', prefecture: '大分県', name: '別府竹細工', threshold: 30, assetPath: 'assets/local_items/九州/大分/別府竹細工.png', description: '竹を細く加工し精巧に編み上げる大分伝統の工芸品'),

  LocalItem(region: '九州', prefecture: '宮崎県', name: 'チキン南蛮', threshold: 5, assetPath: 'assets/local_items/九州/宮崎/チキン南蛮.png', description: '揚げた鶏肉を甘酢に浸し\nソースなどを添える名物料理'),
  LocalItem(region: '九州', prefecture: '宮崎県', name: '冷や汁', threshold: 10, assetPath: 'assets/local_items/九州/宮崎/冷や汁.png', description: '焼いた魚や味噌を使った\n冷たい汁をご飯にかける郷土料理'),
  LocalItem(region: '九州', prefecture: '宮崎県', name: '地鶏の炭火焼', threshold: 15, assetPath: 'assets/local_items/九州/宮崎/地鶏の炭火焼.png', description: '鶏肉を強い炭火で香ばしく\n焼き上げる宮崎の料理'),
  LocalItem(region: '九州', prefecture: '宮崎県', name: 'チーズ饅頭', threshold: 20, assetPath: 'assets/local_items/九州/宮崎/チーズ饅頭.png', description: 'チーズ入りの餡を生地で包んで\n焼き上げる洋風菓子'),
  LocalItem(region: '九州', prefecture: '宮崎県', name: '日向夏', threshold: 25, assetPath: 'assets/local_items/九州/宮崎/日向夏.png', description: '白い内皮と果肉を一緒に味わえる爽やかな宮崎の柑橘'),
  LocalItem(region: '九州', prefecture: '宮崎県', name: '都城大弓', threshold: 30, assetPath: 'assets/local_items/九州/宮崎/都城大弓.png', description: '竹などを使い長い工程を経て\n作られる伝統的な和弓'),

  LocalItem(region: '九州', prefecture: '鹿児島県', name: 'お茶', threshold: 5, assetPath: 'assets/local_items/九州/鹿児島/お茶.png', description: '日本一の生産量を誇る温暖な\n土地で育つ鹿児島の特産品'),
  LocalItem(region: '九州', prefecture: '鹿児島県', name: 'さつまいも', threshold: 10, assetPath: 'assets/local_items/九州/鹿児島/さつまいも.png', description: '全国屈指の生産量を誇り\n料理や菓子にも使われる農産物'),
  LocalItem(region: '九州', prefecture: '鹿児島県', name: 'さつま揚げ', threshold: 15, assetPath: 'assets/local_items/九州/鹿児島/さつま揚げ.png', description: '魚のすり身を味付けし油で揚げた鹿児島伝統の食品'),
  LocalItem(region: '九州', prefecture: '鹿児島県', name: '鶏飯', threshold: 20, assetPath: 'assets/local_items/九州/鹿児島/鶏飯.png', description: 'ご飯に鶏肉や具材をのせ\n熱いだしをかけて食べる郷土料理'),
  LocalItem(region: '九州', prefecture: '鹿児島県', name: 'かるかん', threshold: 25, assetPath: 'assets/local_items/九州/鹿児島/かるかん.png', description: '山芋と米粉などを使い\nふんわり蒸し上げる伝統和菓子'),
  LocalItem(region: '九州', prefecture: '鹿児島県', name: '薩摩焼', threshold: 30, assetPath: 'assets/local_items/九州/鹿児島/薩摩焼.png', description: '白薩摩や黒薩摩など\n多彩な作風を持つ伝統的な陶器'),

  LocalItem(region: '九州', prefecture: '沖縄県', name: 'ゴーヤーチャンプルー', threshold: 5, assetPath: 'assets/local_items/九州/沖縄/ゴーヤーチャンプルー.png', description: 'ゴーヤーや豆腐などを\n炒め合わせる沖縄の家庭料理'),
  LocalItem(region: '九州', prefecture: '沖縄県', name: '沖縄そば', threshold: 10, assetPath: 'assets/local_items/九州/沖縄/沖縄そば.png', description: '小麦麺を豚やかつおのだしで\n味わう沖縄を代表する麺料理'),
  LocalItem(region: '九州', prefecture: '沖縄県', name: 'ラフテー', threshold: 15, assetPath: 'assets/local_items/九州/沖縄/ラフテー.png', description: '豚の三枚肉を泡盛や砂糖、\n醤油などで柔らかく煮た料理'),
  LocalItem(region: '九州', prefecture: '沖縄県', name: 'サーターアンダギー', threshold: 20, assetPath: 'assets/local_items/九州/沖縄/サーターアンダギー.png', description: '小麦粉と卵などの生地を\n丸く揚げた沖縄の菓子'),
  LocalItem(region: '九州', prefecture: '沖縄県', name: 'パイナップル', threshold: 25, assetPath: 'assets/local_items/九州/沖縄/パイナップル.png', description: '日本一の生産量を誇る\n南国らしい甘酸っぱい果物'),
  LocalItem(region: '九州', prefecture: '沖縄県', name: '琉球びんがた', threshold: 30, assetPath: 'assets/local_items/九州/沖縄/琉球びんがた.png', description: '鮮やかな色彩と南国らしい\n文様が美しい伝統染物'),
];

const localItemRegions = <String>['北海道', '東北', '関東', '中部', '近畿', '中国・四国', '九州'];
const hokkaidoPrefectures = <String>['北海道'];
const tohokuPrefectures = <String>['青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県'];
const kantoPrefectures = <String>['茨城県', '栃木県', '群馬県', '埼玉県', '千葉県', '東京都', '神奈川県'];
const chubuPrefectures = <String>['新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県', '岐阜県', '静岡県', '愛知県'];
const kinkiPrefectures = <String>['三重県', '滋賀県', '京都府', '大阪府', '兵庫県', '奈良県', '和歌山県'];
const chugokuShikokuPrefectures = <String>['鳥取県', '島根県', '岡山県', '広島県', '山口県', '徳島県', '香川県', '愛媛県', '高知県'];
const kyushuPrefectures = <String>['福岡県', '佐賀県', '長崎県', '熊本県', '大分県', '宮崎県', '鹿児島県', '沖縄県'];

const localItemPrefectures = <String>[
  ...hokkaidoPrefectures,
  ...tohokuPrefectures,
  ...kantoPrefectures,
  ...chubuPrefectures,
  ...kinkiPrefectures,
  ...chugokuShikokuPrefectures,
  ...kyushuPrefectures,
];

List<String> prefecturesForRegion(String region) {
  return switch (region) {
    '北海道' => hokkaidoPrefectures,
    '東北' => tohokuPrefectures,
    '関東' => kantoPrefectures,
    '中部' => chubuPrefectures,
    '近畿' => kinkiPrefectures,
    '中国・四国' => chugokuShikokuPrefectures,
    '九州' => kyushuPrefectures,
    _ => const <String>[],
  };
}
