import '../models/perfume_model.dart';

class PerfumeData {
  static const List<Map<String, dynamic>> localizedNames = [
    {
      'id': 'p5',
      'category': 'DOLCE & GABBANA',
      'names': {
        'en': 'D&G DOLCE ROSE', 'am': 'ዶልቼ ሮዝ', 'fr': 'D&G DOLCE ROSE',
        'es': 'D&G DOLCE ROSE', 'de': 'D&G DOLCE ROSE',
        'it': 'D&G DOLCE ROSA', 'ar': 'دولتشي روز'
      },
      'price': 88.00,
      'image': 'assets/images/dolce.png',
      'images': [
        'assets/images/dolce.png',
        'assets/images/dolce_alt.png',
        'assets/images/dolce_box.png',
      ],
    },
    {
      'id': 'p1',
      'category': 'CHANEL',
      'names': {
        'en': 'CHANEL N°5', 'am': 'ሻኔል ቁ.5', 'fr': 'CHANEL N°5',
        'es': 'CHANEL N°5', 'de': 'CHANEL N°5', 'it': 'CHANEL N°5', 'ar': 'شانيل رقم 5'
      },
      'price': 70.00,
      'image': 'assets/images/chanel5.png',
      'images': [
        'assets/images/chanel5.png',
        'assets/images/chanel5_alt.png',
        'assets/images/chanel5_box.png',
      ],
    },
    {
      'id': 'p3',
      'category': 'DIOR',
      'names': {
        'en': 'DIOR J\'ADORE', 'am': 'ዲዮር ዣዶር', 'fr': 'DIOR J\'ADORE',
        'es': 'DIOR J\'ADORE', 'de': 'DIOR J\'ADORE', 'it': 'DIOR J\'ADORE', 'ar': 'ديور جادور'
      },
      'price': 85.00,
      'image': 'assets/images/dior.png',
      'images': [
        'assets/images/dior.png',
        'assets/images/dior_alt.png',
        'assets/images/dior_box.png',
      ],
    },
    {
      'id': 'p4',
      'category': 'DIOR',
      'names': {
        'en': 'DIOR POISON', 'am': 'ዲዮር ፖይዝን', 'fr': 'DIOR POISON',
        'es': 'DIOR POISON', 'de': 'DIOR POISON', 'it': 'DIOR POISON', 'ar': 'ديور بويزن'
      },
      'price': 95.00,
      'image': 'assets/images/poison.png',
      'images': [
        'assets/images/poison.png',
        'assets/images/poison_alt.png',
        'assets/images/poison_box.png',
      ],
    },
    {
      'id': 'p2',
      'category': 'CHANEL',
      'names': {
        'en': 'CHANEL COCO MADEMOISELLE', 'am': 'ኮኮ ማድሞዝኤል', 'fr': 'CHANEL COCO MADEMOISELLE',
        'es': 'CHANEL COCO MADEMOISELLE', 'de': 'CHANEL COCO MADEMOISELLE',
        'it': 'CHANEL COCO MADEMOISELLE', 'ar': 'كوكو مادموازيل'
      },
      'price': 60.00,
      'image': 'assets/images/coco.png',
      'images': [
        'assets/images/coco1.png',
        'assets/images/coco_alt.png',
        'assets/images/coco_box.png',
      ],
    },
    {
      'id': 'p6',
      'category': 'JEAN PAUL GAULTIER',
      'names': {
        'en': 'LE BEAU PARADISE', 'am': 'ለ ቦ ፓራዳይስ', 'fr': 'LE BEAU PARADIS',
        'es': 'LE BEAU PARAÍSO', 'de': 'LE BEAU PARADIES',
        'it': 'LE BEAU PARADISO', 'ar': 'لو بو باراديس'
      },
      'price': 95.00,
      'image': 'assets/images/jean paul.png',
      'images': [
        'assets/images/jean paul.png',
        'assets/images/jean paul_alt.png',
        'assets/images/jean paul_box.png',
      ],
    },
    {
      'id': 'p7',
      'category': 'SHALIMAR',
      'names': {
        'en': 'SHALIMAR INITIAL', 'am': 'ሻሊማር ኢኒሻል', 'fr': 'SHALIMAR INITIAL',
        'es': 'SHALIMAR INITIAL', 'de': 'SHALIMAR INITIAL',
        'it': 'SHALIMAR INITIAL', 'ar': 'شاليمار إنيشيال'
      },
      'price': 65.00,
      'image': 'assets/images/shalimar.png',
      'images': [
        'assets/images/shalimar.png',
        'assets/images/shalimar_alt.png',
        'assets/images/shalimar_box.png',
      ],
    },
    {
      'id': 'p8',
      'category': 'MUGLER',
      'names': {
        'en': 'MUGLER ANGEL', 'am': 'ሙጅለር ኤንጄል', 'fr': 'MUGLER ANGEL',
        'es': 'MUGLER ANGEL', 'de': 'MUGLER ANGEL',
        'it': 'MUGLER ANGEL', 'ar': 'مولير أنجيل'
      },
      'price': 82.00,
      'image': 'assets/images/mugler.png',
      'images': [
        'assets/images/mugler.png',
        'assets/images/mugler_alt.png',
        'assets/images/mugler_box.png',
      ],
    },
    {
      'id': 'p9',
      'category': 'MARC JACOBS',
      'names': {
        'en': 'MARC JACOBS DAISY', 'am': 'ማርክ ጃኮብስ ዴዚ', 'fr': 'MARC JACOBS DAISY',
        'es': 'MARC JACOBS DAISY', 'de': 'MARC JACOBS DAISY',
        'it': 'MARC JACOBS DAISY', 'ar': 'مارك جاكوبس دايزي'
      },
      'price': 105.00,
      'image': 'assets/images/marc jacobs.png',
      'images': [
        'assets/images/marc jacobs.png',
        'assets/images/marc jacobs_alt.png',
        'assets/images/marc jacobs_box.png',
      ],
    },
    {
      'id': 'p10',
      'category': 'DIOR',
      'names': {
        'en': 'VINTAGE RIBBON', 'am': 'ቪንቴጅ ሪበን', 'fr': 'VINTAGE RIBBON',
        'es': 'VINTAGE RIBBON', 'de': 'VINTAGE RIBBON',
        'it': 'VINTAGE RIBBON', 'ar': 'فينتاج ريبون'
      },
      'price': 105.00,
      'image': 'assets/images/vintage.png',
      'images': [
        'assets/images/vintage.png',
        'assets/images/vintage_alt.png',
        'assets/images/vintage_box.png',
      ],
    },
  ];

  static List<PerfumeModel> getLocalizedCollection(String langCode) {
    final Map<String, Map<String, String>> perPerfumeDescriptions = {
      'p1': {
        'en': 'The timeless icon. A floral aldehyde masterpiece that defined modern perfumery.',
        'am': 'ዘመን ተሻጋሪ ምልክት። ዘመናዊ ሽቶ ጥበብን የፈጠረ የአበባ ሽቶ።',
        'fr': 'L\'icône intemporelle. Un chef-d\'œuvre floral aldéhydé qui a défini la parfumerie moderne.',
        'es': 'El icono atemporal. Una obra maestra floral aldehídica que definió la perfumería moderna.',
        'de': 'Die zeitlose Ikone. Ein florales Aldehydmeisterwerk, das die moderne Parfümerie definierte.',
        'it': 'L\'icona senza tempo. Un capolavoro floreale aldeídico che ha défini la profumeria moderna.',
        'ar': 'الأيقونة الخالدة. تحفة زهرية ألدهيدية أعادت تعريف عالم العطور الحديث.',
      },
      'p2': {
        'en': 'Bold, free and sensual. A modern oriental fragrance for the daring woman.',
        'am': 'ደፋር፣ ነፃ እና ስሜታዊ። ለደፋሯ ሴት የተሰራ ዘመናዊ ምስራቃዊ ሽቶ።',
        'fr': 'Audacieux, libre et sensuel. Un parfum oriental moderne pour la femme audacieuse.',
        'es': 'Atrevido, libre y sensual. Una fragancia oriental moderna para la mujer audaz.',
        'de': 'Mutig, frei und sinnlich. Ein moderner orientalischer Duft für die mutige Frau.',
        'it': 'Audace, libero e sensuale. Una fragranza orientale moderna per la donna audace.',
        'ar': 'جريء، حر وحسي. عطر شرقي عصري للمرأة الجريئة.',
      },
      'p3': {
        'en': 'Luminous and feminine. A golden elixir celebrating the beauty of women.',
        'am': 'ብርሃናማ እና ሴታዊ። የሴቶችን ውበት የሚያከብር ወርቃማ ሽቶ።',
        'fr': 'Lumineux et féminin. Un élixir doré célébrant la beauté des femmes.',
        'es': 'Luminoso y femenino. Un elixir dorado que celebra la belleza de las mujeres.',
        'de': 'Leuchtend und feminin. Ein goldenes Elixier, das die Schönheit der Frauen feiert.',
        'it': 'Luminoso e femminile. Un elisir dorato che celebra la beleza delle donne.',
        'ar': 'مضيء وأنثوي. إكسير ذهبي يحتفل بجمال المرأة.',
      },
      'p4': {
        'en': 'Mysterious and intoxicating. A legendary oriental floral with hypnotic depth.',
        'am': 'ምስጢራዊ እና አስደናቂ። ጥልቅ ሃይፕኖቲክ ምስራቃዊ አበባ ሽቶ።',
        'fr': 'Mystérieux et enivrant. Un floral oriental légendaire avec une profondeur hypnotique.',
        'es': 'Misterioso e intoxicante. Un floral oriental legendario con profundidad hipnótica.',
        'de': 'Geheimnisvoll und berauschend. Ein legendärer orientalischer Blumenduft mit hypnotischer Tiefe.',
        'it': 'Misterioso e inebriante. Un leggendario floreale orientale con profondità ipnotica.',
        'ar': 'غامض وسكري. زهري شرقي أسطوري ذو عمق منوم.',
      },
      'p5': {
        'en': 'Fresh and flirty. A delicate rose bouquet for the playful, romantic soul. 50ML EDT.',
        'am': 'ትኩስ እና አስደሳች። ለፍቅረኛው ነፍስ ቀጭን የጽጌረዳ ሽቶ። 50ML EDT።',
        'fr': 'Frais et flirty. Un délicat bouquet de roses pour l\'âme romantique. 50ML EDT.',
        'es': 'Fresco y coqueto. Un delicado ramo de rosas para el alma romántica. 50ML EDT.',
        'de': 'Frisch und verspielt. Ein zartes Rosenbukett für die romantische Seele. 50ML EDT.',
        'it': 'Fresco e flirty. Un delicato bouquet di rose per l\'anima romantica. 50ML EDT.',
        'ar': 'منعش ومرح. باقة ورد رقيقة للروح الرومانسية المرحة. 50 مل.',
      },
      'p6': {
        'en': 'An exotic paradise in a bottle. Vibrant tropical florals with a warm sensual base. 125ML EDP.',
        'am': 'በጠርሙስ ውስጥ ያለ ኤክሶቲክ ፓራዳይስ። ሞቃታማ አበቦች። 125ML EDP።',
        'fr': 'Un paradis exotique en flacon. Floraux tropicaux vibrants. 125ML EDP.',
        'es': 'Un paraíso exótico en un frasco. Florales tropicales vibrantes. 125ML EDP.',
        'de': 'Ein exotiches Paradies. Lebhafte tropische Blumen mit sinnlicher Basis. 125ML EDP.',
        'it': 'Un paradiso esotico. Florali tropicali vivaci con base sensuale. 125ML EDP.',
        'ar': 'جنة استوائية في زجاجة. أزهار استوائية نابضة. 125 مل.',
      },
      'p7': {
        'en': 'A legendary oriental. Vanilla, iris and rose enveloped in warm amber and incense.',
        'am': 'አፈ ታሪካዊ ምስራቃዊ ሽቶ። ቫኒላ፣ አይሪስ እና ጽጌረዳ በሞቅ አምበርና ዕጣን።',
        'fr': 'Un oriental légendaire. Vanille, iris et rose dans un chaud ambre et encens.',
        'es': 'Un oriental legendario. Vainilla, iris y rosa en cálido ámbar e incienso.',
        'de': 'Ein legendärer Orientale. Vanille, Iris und Rose in Bernstein und Weihrauch.',
        'it': 'Un orientale leggendario. Vaniglia, iris e rosa in ambra e incenso.',
        'ar': 'شرقي أسطوري. فانيليا وسوسن وورد في عنبر دافئ وبخور.',
      },
      'p8': {
        'en': 'Iconic and otherworldly. Bergamot, red berries and warm patchouli. 100ML EDP.',
        'am': 'ታዋቂ እና ሌላ ዓለማዊ። በርጋሞት፣ ቀይ ቤሪዎች እና ፓቾሊ። 100ML EDP።',
        'fr': 'Iconique. Bergamote, baies rouges et patchouli chaud. 100ML EDP.',
        'es': 'Icónico. Bergamota, bayas rojas y pachulí cálido. 100ML EDP.',
        'de': 'Ikonisch. Bergamotte, rote Beeren und warmes Patchouli. 100ML EDP.',
        'it': 'Iconico. Bergamotto, bacche rosse e patchouli caldo. 100ML EDP.',
        'ar': 'أيقوني. برغموت وتوت أحمر وباتشولي دافئ. 100 مل.',
      },
      'p9': {
        'en': 'Playful and fresh. A charming daisy-inspired floral for everyday elegance.',
        'am': 'ጨዋታዊ እና ትኩስ። ለዕለት ዕለቱ ውበት ተስማሚ የዴዚ አበባ ሽቶ።',
        'fr': 'Enjoué et frais. Un floral inspiré de la marguerite pour l\'élégance quotidienne.',
        'es': 'Juguetón y fresco. Un floral inspirado en la margarita para la elegancia cotidiana.',
        'de': 'Verspielt und frisch. Ein Gänseblümchen-inspirierter Blumenduft für tägliche Eleganz.',
        'it': 'Giocoso e fresco. Un floreale ispirato alla margherita per l\'eleganza quotidiana.',
        'ar': 'مرح ومنعش. زهري مستوحى من زهرة الربيع للأناقة اليومية.',
      },
      'p10': {
        'en': 'An outstanding luxury fragrance masterpiece designed for your premium lifestyle.',
        'am': 'ለላቀ የአኗኗር ዘይቤዎ ተብሎ የተዘጋጀ ልዩ የቅንጦት ሽቶ።',
        'fr': 'Un chef-d\'œuvre de parfum exceptionnel conçu pour votre style de vie premium.',
        'es': 'Una obra maestra de fragancia de lujo excepcional para su estilo de vida premium.',
        'de': 'Ein außergewöhnliches Luxusparfum-Meisterwerk für Ihren gehobenen Lebensstil.',
        'it': 'Un eccezionale capolavoro di fragranza per il tuo stile di vita premium.',
        'ar': 'شاهكار عطر فاخر استثنائي مصمم لأسلوب حياتك المتميز.',
      },
    };

    return localizedNames.map((item) {
      final String id = item['id'];
      final Map<String, String> nameMap = item['names'] as Map<String, String>;
      final String displayName = nameMap[langCode] ?? nameMap['en']!;
      final Map<String, String> descMap =
          perPerfumeDescriptions[id] ?? perPerfumeDescriptions['p10']!;
      final String activeDescription = descMap[langCode] ?? descMap['en']!;

      return PerfumeModel(
        id: id,
        name: displayName,
        brandLine: item['category'],
        price: item['price'],
        descriptionEn: descMap['en'] ?? activeDescription,
        descriptionFr: descMap['fr'] ?? activeDescription,
        imageUrl: item['image'],
        imageUrls: List<String>.from(item['images']),
        isFeatured: true,
      );
    }).toList();
  }
}