class Dhikr {
  const Dhikr({
    required this.key,
    required this.short,
    required this.arabic,
    required this.transliteration,
    required this.english,
    required this.count,
  });

  final String key;
  final String short;
  final String arabic;
  final String transliteration;
  final String english;
  final int count;
}

const List<Dhikr> afterPrayerAdhkar = [
  Dhikr(
    key: 'astaghfir',
    short: 'Astaghfirullāh',
    arabic: 'أَسْتَغْفِرُ ٱللَّٰه',
    transliteration: 'Astaghfiru-llāh',
    english: 'I seek the forgiveness of Allah.',
    count: 3,
  ),
  Dhikr(
    key: 'salam',
    short: 'Allāhumma anta-s-salām',
    arabic:
        'ٱللَّٰهُمَّ أَنْتَ ٱلسَّلَامُ وَمِنْكَ ٱلسَّلَامُ، تَبَارَكْتَ يَا ذَا ٱلْجَلَالِ وَٱلْإِكْرَامِ',
    transliteration:
        'Allāhumma anta-s-salāmu wa minka-s-salām, tabārakta yā dhā-l-jalāli wa-l-ikrām.',
    english:
        'O Allah, You are Peace and from You comes peace. Blessed are You, Possessor of majesty and honor.',
    count: 1,
  ),
  Dhikr(
    key: 'tahlil',
    short: 'Lā ilāha illā-llāh',
    arabic:
        'لَا إِلٰهَ إِلَّا ٱللَّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ ٱلْمُلْكُ وَلَهُ ٱلْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
    transliteration:
        'Lā ilāha illā-llāhu waḥdahu lā sharīka lah, lahu-l-mulku wa lahu-l-ḥamd, wa huwa ʿalā kulli shayʾin qadīr.',
    english:
        'There is no god but Allah alone, without partner. To Him belong dominion and praise, and He has power over all things.',
    count: 1,
  ),
  Dhikr(
    key: 'tasbih',
    short: 'Subḥān Allāh',
    arabic: 'سُبْحَانَ ٱللَّٰه',
    transliteration: 'Subḥān Allāh',
    english: 'Glory be to Allah.',
    count: 33,
  ),
  Dhikr(
    key: 'tahmid',
    short: 'Al-ḥamdu lillāh',
    arabic: 'ٱلْحَمْدُ لِلَّٰه',
    transliteration: 'Al-ḥamdu lillāh',
    english: 'All praise is for Allah.',
    count: 33,
  ),
  Dhikr(
    key: 'takbir',
    short: 'Allāhu akbar',
    arabic: 'ٱللَّٰهُ أَكْبَر',
    transliteration: 'Allāhu akbar',
    english: 'Allah is greatest.',
    count: 34,
  ),
];
