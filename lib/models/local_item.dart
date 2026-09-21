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

  LocalItem(region: '北海道', prefecture: '北海道', name: 'じゃがいも', threshold: 5, assetPath: 'assets/local_items/北海道地方/北海道/じゃがいも.png', description: '日本一の生産量を誇る北海道を代表する農産物'),
  LocalItem(region: '北海道', prefecture: '北海道', name: 'とうもろこし', threshold: 10, assetPath: 'assets/local_items/北海道地方/北海道/とうもろこし.png', description: '広大な大地で育つ甘み豊かな北海道の代表野菜'),
  LocalItem(region: '北海道', prefecture: '北海道', name: '昆布', threshold: 15, assetPath: 'assets/local_items/北海道地方/北海道/昆布.png', description: '豊かな北の海で育つ、うま味たっぷりの海産物'),
  LocalItem(region: '北海道', prefecture: '北海道', name: 'いくら', threshold: 20, assetPath: 'assets/local_items/北海道地方/北海道/いくら.png', description: '鮭の卵を醤油などで味付けした北海道の海の幸'),
  LocalItem(region: '北海道', prefecture: '北海道', name: '乳製品', threshold: 25, assetPath: 'assets/local_items/北海道地方/北海道/乳製品.png', description: '酪農王国北海道の良質な生乳から作られる名産品'),
  LocalItem(region: '北海道', prefecture: '北海道', name: '二風谷アットゥシ', threshold: 30, assetPath: 'assets/local_items/北海道地方/北海道/二風谷アットゥシ.png', description: '樹皮の繊維を使って織り上げる伝統的な織物'),

  LocalItem(region: '東北', prefecture: '青森県', name: 'りんご', threshold: 5, assetPath: 'assets/local_items/東北地方/青森県/りんご.png', description: '日本一の生産量を誇る、青森を代表する果物'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'にんにく', threshold: 10, assetPath: 'assets/local_items/東北地方/青森県/にんにく.png', description: '日本一の生産量を誇る、大粒で香り豊かな特産品'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'せんべい汁', threshold: 15, assetPath: 'assets/local_items/東北地方/青森県/せんべい汁.png', description: '南部せんべいを割り入れて煮込む温かな郷土料理'),
  LocalItem(region: '東北', prefecture: '青森県', name: 'いちご煮', threshold: 20, assetPath: 'assets/local_items/東北地方/青森県/いちご煮.png', description: 'うにとあわびを澄まし汁仕立てにした海の郷土料理'),
  LocalItem(region: '東北', prefecture: '青森県', name: '生姜味噌おでん', threshold: 25, assetPath: 'assets/local_items/東北地方/青森県/生姜味噌おでん.png', description: 'おでんに生姜入り味噌だれをかける青森の味'),
  LocalItem(region: '東北', prefecture: '青森県', name: '津軽塗', threshold: 30, assetPath: 'assets/local_items/東北地方/青森県/津軽塗.png', description: '幾重にも漆を塗り重ねて美しい模様を作る伝統工芸'),

  LocalItem(region: '東北', prefecture: '岩手県', name: 'わんこそば', threshold: 5, assetPath: 'assets/local_items/東北地方/岩手県/わんこそば.png', description: '小さな椀へ次々とそばを盛る岩手名物の郷土料理'),
  LocalItem(region: '東北', prefecture: '岩手県', name: '盛岡冷麺', threshold: 10, assetPath: 'assets/local_items/東北地方/岩手県/盛岡冷麺.png', description: '弾力ある麺と冷たいスープが特徴の盛岡名物'),
  LocalItem(region: '東北', prefecture: '岩手県', name: 'ひっつみ汁', threshold: 15, assetPath: 'assets/local_items/東北地方/岩手県/ひっつみ汁.png', description: '小麦粉の生地を手でちぎり汁で煮込む郷土料理'),
  LocalItem(region: '東北', prefecture: '岩手県', name: '南部せんべい', threshold: 20, assetPath: 'assets/local_items/東北地方/岩手県/南部せんべい.png', description: '小麦粉の生地を丸く香ばしく焼き上げた素朴な菓子'),
  LocalItem(region: '東北', prefecture: '岩手県', name: 'うに', threshold: 25, assetPath: 'assets/local_items/東北地方/岩手県/うに.png', description: '三陸の豊かな海で育つ、濃厚な甘みを持つ海産物'),
  LocalItem(region: '東北', prefecture: '岩手県', name: '南部鉄器', threshold: 30, assetPath: 'assets/local_items/東北地方/岩手県/南部鉄器.png', description: '重厚な鉄瓶や急須で知られる岩手伝統の鋳物'),

  LocalItem(region: '東北', prefecture: '宮城県', name: '牛たん', threshold: 5, assetPath: 'assets/local_items/東北地方/宮城県/牛たん.png', description: '厚めに切った牛たんを香ばしく焼き上げる仙台名物'),
  LocalItem(region: '東北', prefecture: '宮城県', name: '笹かまぼこ', threshold: 10, assetPath: 'assets/local_items/東北地方/宮城県/笹かまぼこ.png', description: '笹の葉形に成形して焼き上げる宮城の魚肉練り製品'),
  LocalItem(region: '東北', prefecture: '宮城県', name: 'はらこ飯', threshold: 15, assetPath: 'assets/local_items/東北地方/宮城県/はらこ飯.png', description: '鮭の煮汁で炊いたご飯に鮭といくらをのせる郷土料理'),
  LocalItem(region: '東北', prefecture: '宮城県', name: 'ずんだ餅', threshold: 20, assetPath: 'assets/local_items/東北地方/宮城県/ずんだ餅.png', description: '枝豆をすりつぶした鮮やかな餡を餅に絡めた郷土菓子'),
  LocalItem(region: '東北', prefecture: '宮城県', name: 'せり鍋', threshold: 25, assetPath: 'assets/local_items/東北地方/宮城県/せり鍋.png', description: '根まで味わうせりをたっぷり使った宮城の冬の鍋料理'),
  LocalItem(region: '東北', prefecture: '宮城県', name: '宮城伝統こけし', threshold: 30, assetPath: 'assets/local_items/東北地方/宮城県/宮城伝統こけし.png', description: '素朴な表情とろくろ模様が美しい木製の伝統人形'),

  LocalItem(region: '東北', prefecture: '秋田県', name: 'きりたんぽ', threshold: 5, assetPath: 'assets/local_items/東北地方/秋田県/きりたんぽ.png', description: 'つぶしたご飯を棒に巻いて焼き、鍋などで味わう郷土食'),
  LocalItem(region: '東北', prefecture: '秋田県', name: '稲庭うどん', threshold: 10, assetPath: 'assets/local_items/東北地方/秋田県/稲庭うどん.png', description: '細くなめらかな麺と強いコシが特徴の手延べうどん'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'いぶりがっこ', threshold: 15, assetPath: 'assets/local_items/東北地方/秋田県/いぶりがっこ.png', description: '大根を燻してから漬け込む香ばしい秋田の漬物'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'ハタハタ', threshold: 20, assetPath: 'assets/local_items/東北地方/秋田県/ハタハタ.png', description: '秋田の冬を代表する魚で、鍋や寿司などで親しまれる'),
  LocalItem(region: '東北', prefecture: '秋田県', name: 'じゅんさい', threshold: 25, assetPath: 'assets/local_items/東北地方/秋田県/じゅんさい.png', description: 'つるりとした食感が特徴の水生植物の若芽'),
  LocalItem(region: '東北', prefecture: '秋田県', name: '大館曲げわっぱ', threshold: 30, assetPath: 'assets/local_items/東北地方/秋田県/大館曲げわっぱ.png', description: '薄い天然杉を曲げて作る美しい木製の伝統工芸品'),

  LocalItem(region: '東北', prefecture: '山形県', name: 'さくらんぼ', threshold: 5, assetPath: 'assets/local_items/東北地方/山形/さくらんぼ.png', description: '日本一の生産量を誇る、山形を代表する初夏の果物'),
  LocalItem(region: '東北', prefecture: '山形県', name: 'ラ・フランス', threshold: 10, assetPath: 'assets/local_items/東北地方/山形/ラ・フランス.png', description: '芳醇な香りとなめらかな食感を持つ西洋なし'),
  LocalItem(region: '東北', prefecture: '山形県', name: '芋煮', threshold: 15, assetPath: 'assets/local_items/東北地方/山形/芋煮.png', description: '里芋や肉などを大鍋で煮込む山形を代表する郷土料理'),
  LocalItem(region: '東北', prefecture: '山形県', name: '玉こんにゃく', threshold: 20, assetPath: 'assets/local_items/東北地方/山形/玉こんにゃく.png', description: '丸いこんにゃくを醤油味で煮込んだ山形名物'),
  LocalItem(region: '東北', prefecture: '山形県', name: '冷たい肉そば', threshold: 25, assetPath: 'assets/local_items/東北地方/山形/冷たい肉そば.png', description: '冷たいつゆと歯応えある鶏肉を楽しむ山形のそば'),
  LocalItem(region: '東北', prefecture: '山形県', name: '天童将棋駒', threshold: 30, assetPath: 'assets/local_items/東北地方/山形/天童将棋駒.png', description: '一文字ずつ美しく仕上げられる天童伝統の将棋駒'),

  LocalItem(region: '東北', prefecture: '福島県', name: '喜多方ラーメン', threshold: 5, assetPath: 'assets/local_items/東北地方/福島/喜多方ラーメン.png', description: '平打ちの縮れ麺と醤油系スープが特徴のご当地麺'),
  LocalItem(region: '東北', prefecture: '福島県', name: 'ソースカツ丼', threshold: 10, assetPath: 'assets/local_items/東北地方/福島/ソースカツ丼.png', description: 'ご飯にキャベツとソースを絡めたカツをのせる料理'),
  LocalItem(region: '東北', prefecture: '福島県', name: '円盤餃子', threshold: 15, assetPath: 'assets/local_items/東北地方/福島/円盤餃子.png', description: '餃子をフライパンへ円形に並べて香ばしく焼いた名物'),
  LocalItem(region: '東北', prefecture: '福島県', name: 'あんぽ柿', threshold: 20, assetPath: 'assets/local_items/東北地方/福島/あんぽ柿.png', description: '柿を乾燥させ、柔らかく濃厚な甘みに仕上げた特産品'),
  LocalItem(region: '東北', prefecture: '福島県', name: '赤べこ', threshold: 25, assetPath: 'assets/local_items/東北地方/福島/赤べこ.png', description: '赤い牛をかたどった首が揺れる会津伝統の郷土玩具'),
  LocalItem(region: '東北', prefecture: '福島県', name: '会津塗', threshold: 30, assetPath: 'assets/local_items/東北地方/福島/会津塗.png', description: '美しい漆の光沢と多彩な加飾が特徴の伝統的な漆器'),

  LocalItem(region: '関東', prefecture: '茨城県', name: 'メロン', threshold: 5, assetPath: 'assets/local_items/関東地方/茨城/メロン.png', description: '日本一の生産量を誇る、芳醇な甘みの茨城特産フルーツ'),
  LocalItem(region: '関東', prefecture: '茨城県', name: 'れんこん', threshold: 10, assetPath: 'assets/local_items/関東地方/茨城/れんこん.png', description: '日本一の生産量を誇る、霞ヶ浦周辺を代表する農産物'),
  LocalItem(region: '関東', prefecture: '茨城県', name: '納豆', threshold: 15, assetPath: 'assets/local_items/関東地方/茨城/納豆.png', description: '蒸した大豆を発酵させた、茨城を代表する伝統的な食品'),
  LocalItem(region: '関東', prefecture: '茨城県', name: '干し芋', threshold: 20, assetPath: 'assets/local_items/関東地方/茨城/干し芋.png', description: 'さつまいもを蒸して乾燥させ、自然な甘みを凝縮した食品'),
  LocalItem(region: '関東', prefecture: '茨城県', name: 'あんこう鍋', threshold: 25, assetPath: 'assets/local_items/関東地方/茨城/あんこう鍋.png', description: 'あんこうの身や肝、野菜を煮込む冬の名物鍋料理'),
  LocalItem(region: '関東', prefecture: '茨城県', name: '笠間焼', threshold: 30, assetPath: 'assets/local_items/関東地方/茨城/笠間焼.png', description: '自由で多彩な作風が魅力の茨城を代表する陶器'),

  LocalItem(region: '関東', prefecture: '栃木県', name: 'いちご', threshold: 5, assetPath: 'assets/local_items/関東地方/栃木/いちご.png', description: '全国屈指の生産を誇る、栃木を代表する甘酸っぱい果物'),
  LocalItem(region: '関東', prefecture: '栃木県', name: 'かんぴょう', threshold: 10, assetPath: 'assets/local_items/関東地方/栃木/かんぴょう.png', description: '日本一の生産量を誇る、夕顔の実から作る乾物'),
  LocalItem(region: '関東', prefecture: '栃木県', name: '湯波', threshold: 15, assetPath: 'assets/local_items/関東地方/栃木/湯波.png', description: '豆乳を加熱して表面にできる膜を丁寧に引き上げた食品'),
  LocalItem(region: '関東', prefecture: '栃木県', name: 'しもつかれ', threshold: 20, assetPath: 'assets/local_items/関東地方/栃木/しもつかれ.png', description: '鮭の頭や大豆、野菜などを煮込む栃木の郷土料理'),
  LocalItem(region: '関東', prefecture: '栃木県', name: '佐野ラーメン', threshold: 25, assetPath: 'assets/local_items/関東地方/栃木/佐野ラーメン.png', description: '青竹打ちの縮れ麺とあっさりスープが特徴の麺料理'),
  LocalItem(region: '関東', prefecture: '栃木県', name: '益子焼', threshold: 30, assetPath: 'assets/local_items/関東地方/栃木/益子焼.png', description: '素朴で温かみのある風合いが魅力の伝統的な陶器'),

  LocalItem(region: '関東', prefecture: '群馬県', name: 'こんにゃく', threshold: 5, assetPath: 'assets/local_items/関東地方/群馬/こんにゃく.png', description: '日本一の生産量を誇る、群馬を代表する農産加工品'),
  LocalItem(region: '関東', prefecture: '群馬県', name: '焼きまんじゅう', threshold: 10, assetPath: 'assets/local_items/関東地方/群馬/焼きまんじゅう.png', description: 'まんじゅうを串に刺し甘い味噌だれで焼く郷土食'),
  LocalItem(region: '関東', prefecture: '群馬県', name: 'おっきりこみ', threshold: 15, assetPath: 'assets/local_items/関東地方/群馬/おっきりこみ.png', description: '幅広の生麺と野菜を一緒に煮込む群馬の郷土料理'),
  LocalItem(region: '関東', prefecture: '群馬県', name: '水沢うどん', threshold: 20, assetPath: 'assets/local_items/関東地方/群馬/水沢うどん.png', description: '透明感のある麺と強いコシを楽しめる名物うどん'),
  LocalItem(region: '関東', prefecture: '群馬県', name: '下仁田ねぎ', threshold: 25, assetPath: 'assets/local_items/関東地方/群馬/下仁田ねぎ.png', description: '太く柔らかく、加熱すると強い甘みが出る冬の特産品'),
  LocalItem(region: '関東', prefecture: '群馬県', name: '桐生織', threshold: 30, assetPath: 'assets/local_items/関東地方/群馬/桐生織.png', description: '長い歴史と高度な技術を受け継ぐ群馬の伝統的な織物'),

  LocalItem(region: '関東', prefecture: '埼玉県', name: '草加せんべい', threshold: 5, assetPath: 'assets/local_items/関東地方/埼玉/草加せんべい.png', description: '堅めに焼いた生地へ醤油を塗る香ばしい米菓'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: '武蔵野うどん', threshold: 10, assetPath: 'assets/local_items/関東地方/埼玉/武蔵野うどん.png', description: '強いコシの太麺を肉や野菜入りのつけ汁で味わう'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: 'ゼリーフライ', threshold: 15, assetPath: 'assets/local_items/関東地方/埼玉/ゼリーフライ.png', description: 'おからとじゃがいもを混ぜて揚げる行田の郷土食'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: 'みそポテト', threshold: 20, assetPath: 'assets/local_items/関東地方/埼玉/みそポテト.png', description: '揚げたじゃがいもに甘辛い味噌だれをかける郷土食'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: '川越いも菓子', threshold: 25, assetPath: 'assets/local_items/関東地方/埼玉/川越いも菓子.png', description: 'さつまいもの自然な甘みを生かした川越の名物菓子'),
  LocalItem(region: '関東', prefecture: '埼玉県', name: '岩槻人形', threshold: 30, assetPath: 'assets/local_items/関東地方/埼玉/岩槻人形.png', description: '精巧な顔立ちや衣装が美しい伝統的な節句人形'),

  LocalItem(region: '関東', prefecture: '千葉県', name: '日本なし', threshold: 5, assetPath: 'assets/local_items/関東地方/千葉/日本なし.png', description: '日本一の生産量を誇る、みずみずしく甘い千葉の果物'),
  LocalItem(region: '関東', prefecture: '千葉県', name: '落花生', threshold: 10, assetPath: 'assets/local_items/関東地方/千葉/落花生.png', description: '日本一の生産量を誇る、香ばしい風味が魅力の農産物'),
  LocalItem(region: '関東', prefecture: '千葉県', name: 'なめろう', threshold: 15, assetPath: 'assets/local_items/関東地方/千葉/なめろう.png', description: '新鮮な魚を味噌や薬味と一緒に細かく叩いた郷土料理'),
  LocalItem(region: '関東', prefecture: '千葉県', name: 'さんが焼き', threshold: 20, assetPath: 'assets/local_items/関東地方/千葉/さんが焼き.png', description: 'なめろうを焼いて香ばしく仕上げた房総の漁師料理'),
  LocalItem(region: '関東', prefecture: '千葉県', name: '太巻き祭り寿司', threshold: 25, assetPath: 'assets/local_items/関東地方/千葉/太巻き祭り寿司.png', description: '切り口に花などの模様を描く華やかな太巻き寿司'),
  LocalItem(region: '関東', prefecture: '千葉県', name: '房州うちわ', threshold: 30, assetPath: 'assets/local_items/関東地方/千葉/房州うちわ.png', description: '丸い竹の骨と美しい装飾が特徴の伝統的なうちわ'),

  LocalItem(region: '関東', prefecture: '東京都', name: 'もんじゃ焼き', threshold: 5, assetPath: 'assets/local_items/関東地方/東京/もんじゃ焼き.png', description: '具材入りのゆるい生地を鉄板で焼いて楽しむ下町料理'),
  LocalItem(region: '関東', prefecture: '東京都', name: '深川めし', threshold: 10, assetPath: 'assets/local_items/関東地方/東京/深川めし.png', description: 'あさりなどの貝を使った江戸から親しまれる郷土料理'),
  LocalItem(region: '関東', prefecture: '東京都', name: 'どじょう鍋', threshold: 15, assetPath: 'assets/local_items/関東地方/東京/どじょう鍋.png', description: 'どじょうを割下などで煮て味わう江戸の伝統料理'),
  LocalItem(region: '関東', prefecture: '東京都', name: '人形焼', threshold: 20, assetPath: 'assets/local_items/関東地方/東京/人形焼.png', description: '人や動物などをかたどり餡を入れて焼き上げる菓子'),
  LocalItem(region: '関東', prefecture: '東京都', name: 'べっこう寿司', threshold: 25, assetPath: 'assets/local_items/関東地方/東京/べっこう寿司.png', description: '島とうがらし醤油に魚を漬けた伊豆諸島の郷土寿司'),
  LocalItem(region: '関東', prefecture: '東京都', name: '江戸切子', threshold: 30, assetPath: 'assets/local_items/関東地方/東京/江戸切子.png', description: 'ガラスの表面を繊細に削り美しい文様を描く伝統工芸'),

  LocalItem(region: '関東', prefecture: '神奈川県', name: 'シュウマイ', threshold: 5, assetPath: 'assets/local_items/関東地方/神奈川/シュウマイ.png', description: '肉や玉ねぎなどの餡を皮で包んで蒸す横浜名物'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: 'サンマーメン', threshold: 10, assetPath: 'assets/local_items/関東地方/神奈川/サンマーメン.png', description: '野菜入りの熱い餡をのせた神奈川発祥の麺料理'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: 'しらす丼', threshold: 15, assetPath: 'assets/local_items/関東地方/神奈川/しらす丼.png', description: '新鮮なしらすをご飯にたっぷりのせて味わう海の料理'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: 'かまぼこ', threshold: 20, assetPath: 'assets/local_items/関東地方/神奈川/かまぼこ.png', description: '魚のすり身を蒸したり焼いたりして仕上げる小田原名物'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: '牛鍋', threshold: 25, assetPath: 'assets/local_items/関東地方/神奈川/牛鍋.png', description: '牛肉と野菜を甘辛い割下で煮込む横浜ゆかりの料理'),
  LocalItem(region: '関東', prefecture: '神奈川県', name: '鎌倉彫', threshold: 30, assetPath: 'assets/local_items/関東地方/神奈川/鎌倉彫.png', description: '木地に文様を彫り漆を塗って仕上げる伝統的な漆工芸'),

  LocalItem(region: '中部', prefecture: '新潟県', name: '米', threshold: 5, assetPath: 'assets/local_items/中部地方/新潟/米.png', description: '全国有数の生産量を誇る、雪国の水と大地が育む新潟の味'),
  LocalItem(region: '中部', prefecture: '新潟県', name: 'へぎそば', threshold: 10, assetPath: 'assets/local_items/中部地方/新潟/へぎそば.png', description: '海藻をつなぎに使い、へぎへ美しく盛り付けるそば'),
  LocalItem(region: '中部', prefecture: '新潟県', name: '笹団子', threshold: 15, assetPath: 'assets/local_items/中部地方/新潟/笹団子.png', description: 'よもぎ入りの餅で餡を包み、笹の葉で巻いて蒸した菓子'),
  LocalItem(region: '中部', prefecture: '新潟県', name: 'のっぺ', threshold: 20, assetPath: 'assets/local_items/中部地方/新潟/のっぺ.png', description: '里芋や野菜などをとろりと煮込む新潟伝統の郷土料理'),
  LocalItem(region: '中部', prefecture: '新潟県', name: '栃尾油揚げ', threshold: 25, assetPath: 'assets/local_items/中部地方/新潟/栃尾油揚げ.png', description: '一般的な油揚げより厚く大きい食べ応えのある名物'),
  LocalItem(region: '中部', prefecture: '新潟県', name: '小千谷縮', threshold: 30, assetPath: 'assets/local_items/中部地方/新潟/小千谷縮.png', description: '細かなシボと涼しい肌触りが特徴の伝統的な麻織物'),

  LocalItem(region: '中部', prefecture: '富山県', name: 'ます寿司', threshold: 5, assetPath: 'assets/local_items/中部地方/富山/ます寿司.png', description: '酢飯に鱒をのせて笹で包み押して作る富山の郷土寿司'),
  LocalItem(region: '中部', prefecture: '富山県', name: '白えび', threshold: 10, assetPath: 'assets/local_items/中部地方/富山/白えび.png', description: '透明感ある白い姿と上品な甘みから珍重される海の幸'),
  LocalItem(region: '中部', prefecture: '富山県', name: 'ホタルイカ', threshold: 15, assetPath: 'assets/local_items/中部地方/富山/ホタルイカ.png', description: '春の富山湾を代表する、小さく青白く光る海産物'),
  LocalItem(region: '中部', prefecture: '富山県', name: '富山ブラックラーメン', threshold: 20, assetPath: 'assets/local_items/中部地方/富山/富山ブラックラーメン.png', description: '濃い色の醤油スープが特徴のご当地ラーメン'),
  LocalItem(region: '中部', prefecture: '富山県', name: '昆布締め', threshold: 25, assetPath: 'assets/local_items/中部地方/富山/昆布締め.png', description: '刺身を昆布で挟み、うま味を移して味わう郷土料理'),
  LocalItem(region: '中部', prefecture: '富山県', name: '井波彫刻', threshold: 30, assetPath: 'assets/local_items/中部地方/富山/井波彫刻.png', description: '木材に立体的で緻密な模様を刻み込む伝統的な木彫'),

  LocalItem(region: '中部', prefecture: '石川県', name: '治部煮', threshold: 5, assetPath: 'assets/local_items/中部地方/石川/治部煮.png', description: '鴨肉などに粉をまぶし野菜と煮合わせる加賀の郷土料理'),
  LocalItem(region: '中部', prefecture: '石川県', name: 'かぶら寿司', threshold: 10, assetPath: 'assets/local_items/中部地方/石川/かぶら寿司.png', description: 'かぶに魚を挟み米麹で発酵させる冬の伝統的な食品'),
  LocalItem(region: '中部', prefecture: '石川県', name: 'のどぐろ', threshold: 15, assetPath: 'assets/local_items/中部地方/石川/のどぐろ.png', description: '脂のりと上品な甘みで知られる日本海の高級魚'),
  LocalItem(region: '中部', prefecture: '石川県', name: 'ハントンライス', threshold: 20, assetPath: 'assets/local_items/中部地方/石川/ハントンライス.png', description: 'ケチャップライスに卵や揚げ物をのせる洋食料理'),
  LocalItem(region: '中部', prefecture: '石川県', name: '加賀棒茶', threshold: 25, assetPath: 'assets/local_items/中部地方/石川/加賀棒茶.png', description: '茶の茎を香ばしく焙煎した、すっきり風味のお茶'),
  LocalItem(region: '中部', prefecture: '石川県', name: '輪島塗', threshold: 30, assetPath: 'assets/local_items/中部地方/石川/輪島塗.png', description: '丈夫な下地と美しい漆の艶を持つ石川伝統の漆器'),

  LocalItem(region: '中部', prefecture: '福井県', name: '越前がに', threshold: 5, assetPath: 'assets/local_items/中部地方/福井/越前がに.png', description: '冬の日本海で水揚げされる、身の甘みが豊かなズワイガニ'),
  LocalItem(region: '中部', prefecture: '福井県', name: '越前おろしそば', threshold: 10, assetPath: 'assets/local_items/中部地方/福井/越前おろしそば.png', description: 'そばに辛味大根おろしを合わせる福井の郷土食'),
  LocalItem(region: '中部', prefecture: '福井県', name: 'へしこ', threshold: 15, assetPath: 'assets/local_items/中部地方/福井/へしこ.png', description: '魚を塩漬け後に米ぬかへ漬け込み熟成させた保存食'),
  LocalItem(region: '中部', prefecture: '福井県', name: '羽二重餅', threshold: 20, assetPath: 'assets/local_items/中部地方/福井/羽二重餅.png', description: 'きめ細かく柔らかな食感が特徴の福井を代表する和菓子'),
  LocalItem(region: '中部', prefecture: '福井県', name: '越前和紙', threshold: 25, assetPath: 'assets/local_items/中部地方/福井/越前和紙.png', description: '丈夫で美しい質感を持ち長い歴史を誇る伝統的な和紙'),
  LocalItem(region: '中部', prefecture: '福井県', name: '若狭塗', threshold: 30, assetPath: 'assets/local_items/中部地方/福井/若狭塗.png', description: '貝殻などを用いた華やかな模様が特徴の伝統漆器'),

  LocalItem(region: '中部', prefecture: '山梨県', name: 'ぶどう', threshold: 5, assetPath: 'assets/local_items/中部地方/山梨/ぶどう.png', description: '日本一の生産量を誇る、山梨を代表する果物'),
  LocalItem(region: '中部', prefecture: '山梨県', name: 'もも', threshold: 10, assetPath: 'assets/local_items/中部地方/山梨/もも.png', description: '日本一の生産量を誇る、香りと甘み豊かな山梨の果物'),
  LocalItem(region: '中部', prefecture: '山梨県', name: 'ほうとう', threshold: 15, assetPath: 'assets/local_items/中部地方/山梨/ほうとう.png', description: '幅広の麺と野菜を味噌仕立ての汁で煮込む郷土料理'),
  LocalItem(region: '中部', prefecture: '山梨県', name: '鳥もつ煮', threshold: 20, assetPath: 'assets/local_items/中部地方/山梨/鳥もつ煮.png', description: '鶏のもつを甘辛いたれで照りよく煮付けた料理'),
  LocalItem(region: '中部', prefecture: '山梨県', name: '吉田のうどん', threshold: 25, assetPath: 'assets/local_items/中部地方/山梨/吉田のうどん.png', description: '非常に強いコシの太麺と味噌系つゆが特徴のうどん'),
  LocalItem(region: '中部', prefecture: '山梨県', name: '甲州水晶貴石細工', threshold: 30, assetPath: 'assets/local_items/中部地方/山梨/甲州水晶貴石細工.png', description: '水晶などの天然石を磨き加工する伝統的な工芸'),

  LocalItem(region: '中部', prefecture: '長野県', name: 'おやき', threshold: 5, assetPath: 'assets/local_items/中部地方/長野/おやき.png', description: '小麦などの生地で野菜や餡を包み焼いた山里の郷土食'),
  LocalItem(region: '中部', prefecture: '長野県', name: '信州そば', threshold: 10, assetPath: 'assets/local_items/中部地方/長野/信州そば.png', description: '冷涼な土地で育ったそばを使う長野を代表する麺料理'),
  LocalItem(region: '中部', prefecture: '長野県', name: '野沢菜漬け', threshold: 15, assetPath: 'assets/local_items/中部地方/長野/野沢菜漬け.png', description: '野沢菜を塩などで漬け込んだ信州定番の漬物'),
  LocalItem(region: '中部', prefecture: '長野県', name: '山賊焼き', threshold: 20, assetPath: 'assets/local_items/中部地方/長野/山賊焼き.png', description: '味付けした大きな鶏肉を衣で豪快に揚げた郷土料理'),
  LocalItem(region: '中部', prefecture: '長野県', name: '寒天', threshold: 25, assetPath: 'assets/local_items/中部地方/長野/寒天.png', description: '海藻から作られ、和菓子や料理に広く使われる伝統食品'),
  LocalItem(region: '中部', prefecture: '長野県', name: '木曽漆器', threshold: 30, assetPath: 'assets/local_items/中部地方/長野/木曽漆器.png', description: '木地に漆を重ねて丈夫に仕上げる木曽地方の伝統工芸'),

  LocalItem(region: '中部', prefecture: '岐阜県', name: '朴葉味噌', threshold: 5, assetPath: 'assets/local_items/中部地方/岐阜/朴葉味噌.png', description: '朴葉の上で味噌や具材を焼きながら味わう飛騨の料理'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '鶏ちゃん', threshold: 10, assetPath: 'assets/local_items/中部地方/岐阜/鶏ちゃん.png', description: '鶏肉と野菜を味噌や醤油だれで炒める岐阜の郷土料理'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '鮎料理', threshold: 15, assetPath: 'assets/local_items/中部地方/岐阜/鮎料理.png', description: '清流で育つ鮎を塩焼きや甘露煮などで味わう郷土の味'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '栗きんとん', threshold: 20, assetPath: 'assets/local_items/中部地方/岐阜/栗きんとん.png', description: '炊いた栗をつぶし茶巾形に整えた素朴な和菓子'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '肉寿司', threshold: 25, assetPath: 'assets/local_items/中部地方/岐阜/肉寿司.png', description: '薄切りの牛肉を酢飯にのせた、旨み豊かな肉の握り寿司。'),
  LocalItem(region: '中部', prefecture: '岐阜県', name: '関の刃物', threshold: 30, assetPath: 'assets/local_items/中部地方/岐阜/関の刃物.png', description: '刀鍛冶の技を受け継ぐ、鋭い切れ味の刃物'),

  LocalItem(region: '中部', prefecture: '静岡県', name: 'わさび', threshold: 5, assetPath: 'assets/local_items/中部地方/静岡/わさび.png', description: '清らかな水で育てられ、爽やかな辛味と香りを持つ特産品'),
  LocalItem(region: '中部', prefecture: '静岡県', name: '桜えび', threshold: 10, assetPath: 'assets/local_items/中部地方/静岡/桜えび.png', description: '国内では主に駿河湾で漁獲される鮮やかな小型のえび'),
  LocalItem(region: '中部', prefecture: '静岡県', name: 'うなぎ', threshold: 15, assetPath: 'assets/local_items/中部地方/静岡/うなぎ.png', description: '香ばしく焼いてたれを絡める、浜名湖周辺で有名な料理'),
  LocalItem(region: '中部', prefecture: '静岡県', name: '静岡おでん', threshold: 20, assetPath: 'assets/local_items/中部地方/静岡/静岡おでん.png', description: '黒いだし汁と魚粉などをかけて味わう静岡の郷土食'),
  LocalItem(region: '中部', prefecture: '静岡県', name: '安倍川もち', threshold: 25, assetPath: 'assets/local_items/中部地方/静岡/安倍川もち.png', description: '柔らかな餅にきな粉や餡を絡める伝統的な和菓子'),
  LocalItem(region: '中部', prefecture: '静岡県', name: '駿河竹千筋細工', threshold: 30, assetPath: 'assets/local_items/中部地方/静岡/駿河竹千筋細工.png', description: '細い竹ひごを組み、美しい曲線を作る伝統工芸'),

  LocalItem(region: '中部', prefecture: '愛知県', name: 'ひつまぶし', threshold: 5, assetPath: 'assets/local_items/中部地方/愛知/ひつまぶし.png', description: '細かく切ったうなぎをご飯と薬味やだしで楽しむ料理'),
  LocalItem(region: '中部', prefecture: '愛知県', name: '味噌煮込みうどん', threshold: 10, assetPath: 'assets/local_items/中部地方/愛知/味噌煮込みうどん.png', description: '濃厚な豆味噌のつゆで硬めの麺を煮込む料理'),
  LocalItem(region: '中部', prefecture: '愛知県', name: '手羽先', threshold: 15, assetPath: 'assets/local_items/中部地方/愛知/手羽先.png', description: '鶏の手羽を香ばしく揚げ、甘辛いたれなどで味付けした料理'),
  LocalItem(region: '中部', prefecture: '愛知県', name: 'きしめん', threshold: 20, assetPath: 'assets/local_items/中部地方/愛知/きしめん.png', description: '幅広で平たい麺をだしの効いたつゆで味わう名古屋の麺'),
  LocalItem(region: '中部', prefecture: '愛知県', name: 'ういろう', threshold: 25, assetPath: 'assets/local_items/中部地方/愛知/ういろう.png', description: '米粉などを蒸して作る、もちもち食感の伝統的な菓子'),
  LocalItem(region: '中部', prefecture: '愛知県', name: '瀬戸焼', threshold: 30, assetPath: 'assets/local_items/中部地方/愛知/瀬戸焼.png', description: '長い陶磁器文化を持ち、日用品にも広く使われる焼き物'),
];

const localItemRegions = <String>['北海道', '東北', '関東', '中部'];
const hokkaidoPrefectures = <String>['北海道'];
const tohokuPrefectures = <String>['青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県'];
const kantoPrefectures = <String>['茨城県', '栃木県', '群馬県', '埼玉県', '千葉県', '東京都', '神奈川県'];
const chubuPrefectures = <String>['新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県', '岐阜県', '静岡県', '愛知県'];

const localItemPrefectures = <String>[
  ...hokkaidoPrefectures,
  ...tohokuPrefectures,
  ...kantoPrefectures,
  ...chubuPrefectures,
];

List<String> prefecturesForRegion(String region) {
  return switch (region) {
    '北海道' => hokkaidoPrefectures,
    '東北' => tohokuPrefectures,
    '関東' => kantoPrefectures,
    '中部' => chubuPrefectures,
    _ => const <String>[],
  };
}
