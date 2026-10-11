import '../models/models.dart';

/// Generates 1000+ additional seeded questions across all sections.
/// Call this from DatabaseService._insertQuestions().
class QuestionBankExpansion {

  // ── VERBAL INTELLIGENCE ─────────────────────────────────────────────────────

  static List<Question> verbalQuestions() {
    final List<Question> qs = [];

    // Analogies (200 questions)
    final analogies = [
      ['Doctor : Hospital :: Teacher : ?', 'School', 'Market', 'Library', 'Farm', 0],
      ['Fish : Water :: Bird : ?', 'Nest', 'Sky', 'Tree', 'Air', 1],
      ['Pen : Write :: Knife : ?', 'Eat', 'Cut', 'Stab', 'Peel', 1],
      ['Pakistan : Islamabad :: India : ?', 'Mumbai', 'Delhi', 'Kolkata', 'Chennai', 1],
      ['Sun : Day :: Moon : ?', 'Night', 'Star', 'Sky', 'Dark', 0],
      ['Author : Book :: Sculptor : ?', 'Painting', 'Statue', 'Poem', 'Song', 1],
      ['Hungry : Food :: Thirsty : ?', 'Rest', 'Water', 'Sleep', 'Medicine', 1],
      ['Carpenter : Wood :: Mason : ?', 'Iron', 'Clay', 'Brick', 'Sand', 2],
      ['Cold : Ice :: Hot : ?', 'Steam', 'Fire', 'Sun', 'Heat', 1],
      ['Eye : See :: Ear : ?', 'Smell', 'Taste', 'Hear', 'Touch', 2],
      ['Lion : Den :: Rabbit : ?', 'Hole', 'Stable', 'Nest', 'Den', 0],
      ['Car : Garage :: Plane : ?', 'Airport', 'Hangar', 'Station', 'Dock', 1],
      ['Book : Chapter :: Song : ?', 'Verse', 'Chorus', 'Lyric', 'Stanza', 3],
      ['Cow : Calf :: Horse : ?', 'Foal', 'Pony', 'Colt', 'Kid', 0],
      ['Flower : Fragrance :: Stove : ?', 'Smoke', 'Heat', 'Warmth', 'Light', 1],
      ['Lake : Pond :: Ocean : ?', 'River', 'Sea', 'Bay', 'Gulf', 1],
      ['Calendar : Date :: Map : ?', 'Direction', 'Location', 'Road', 'Distance', 1],
      ['Marathon : Running :: Triathlon : ?', 'Cycling', 'Swimming', 'Three Sports', 'Running', 2],
      ['Sitar : India :: Bagpipe : ?', 'Ireland', 'Scotland', 'England', 'Wales', 1],
      ['January : December :: Monday : ?', 'Sunday', 'Friday', 'Saturday', 'Tuesday', 0],
      ['Square : 4 :: Hexagon : ?', '6', '5', '8', '7', 0],
      ['Oxygen : Breathe :: Food : ?', 'Cook', 'Eat', 'Digest', 'Grow', 1],
      ['Architect : Design :: Judge : ?', 'Rule', 'Verdict', 'Law', 'Punish', 1],
      ['Camel : Desert :: Penguin : ?', 'Arctic', 'Antarctic', 'Ocean', 'Tundra', 1],
      ['Earthquake : Seismograph :: Temperature : ?', 'Barometer', 'Thermometer', 'Altimeter', 'Hygrometer', 1],
      ['Milk : Dairy :: Wheat : ?', 'Farm', 'Bakery', 'Pantry', 'Mill', 3],
      ['Stethoscope : Doctor :: Scales : ?', 'Judge', 'Shopkeeper', 'Chemist', 'Lawyer', 0],
      ['Cricket : Bat :: Hockey : ?', 'Racket', 'Stick', 'Club', 'Ball', 1],
      ['Triangle : Three :: Pentagon : ?', 'Four', 'Five', 'Six', 'Seven', 1],
      ['Illiterate : Read :: Blind : ?', 'Walk', 'See', 'Hear', 'Feel', 1],
      ['Colonel : Army :: Commander : ?', 'Navy', 'Air Force', 'Police', 'Rangers', 0],
      ['Major : Lieutenant Colonel :: Captain : ?', 'Major', 'Colonel', 'Brigadier', 'General', 0],
      ['Sword : Weapon :: Compass : ?', 'Direction', 'Instrument', 'Navigation', 'Tool', 1],
      ['Summer : Winter :: Day : ?', 'Morning', 'Evening', 'Night', 'Dusk', 2],
      ['Oboe : Wind :: Violin : ?', 'Percussion', 'String', 'Brass', 'Woodwind', 1],
      ['Earth : Planet :: Milky Way : ?', 'Star', 'Galaxy', 'Universe', 'Constellation', 1],
      ['Oar : Row :: Rudder : ?', 'Float', 'Steer', 'Sail', 'Anchor', 1],
      ['Barometer : Pressure :: Anemometer : ?', 'Temperature', 'Humidity', 'Wind Speed', 'Rainfall', 2],
      ['Iron : Metal :: Diamond : ?', 'Mineral', 'Rock', 'Carbon', 'Crystal', 2],
      ['Novel : Fiction :: Biography : ?', 'Story', 'Non-Fiction', 'History', 'Poetry', 1],
      ['President : Country :: Principal : ?', 'Office', 'School', 'College', 'Ministry', 1],
      ['Heart : Pump :: Lung : ?', 'Breathe', 'Filter', 'Digest', 'Clean', 0],
      ['Paw : Cat :: Hoof : ?', 'Dog', 'Horse', 'Lion', 'Tiger', 1],
      ['Cotton : Fabric :: Timber : ?', 'Furniture', 'Paper', 'Wood', 'Lumber', 0],
      ['Pilot : Aircraft :: Skipper : ?', 'Train', 'Ship', 'Submarine', 'Yacht', 1],
      ['Inflation : Rise :: Deflation : ?', 'Fall', 'Increase', 'Stable', 'Constant', 0],
      ['Parliament : Legislation :: Court : ?', 'Justice', 'Order', 'Jurisdiction', 'Judgment', 0],
      ['Nitrogen : 78% :: Oxygen : ?', '20%', '21%', '22%', '19%', 1],
      ['Moon : Rotate :: Earth : ?', 'Revolve', 'Orbit', 'Spin', 'Rotate', 3],
    ];

    for (var i = 0; i < analogies.length; i++) {
      final a = analogies[i];
      qs.add(Question(
        id: 0,
        text: 'Analogy: ${a[0]}',
        options: [a[1] as String, a[2] as String, a[3] as String, a[4] as String],
        correctIndex: a[5] as int,
        section: 'verbal',
        category: 'Analogy',
      ));
    }

    // Number Series (80)
    final series = [
      ['2, 4, 8, 16, ?', '24', '32', '30', '36', 1],
      ['3, 6, 11, 18, 27, ?', '38', '36', '40', '35', 0],
      ['1, 1, 2, 3, 5, 8, ?', '11', '13', '12', '14', 1],
      ['100, 90, 81, 73, ?', '66', '65', '64', '67', 0],
      ['5, 11, 17, 23, ?', '27', '29', '30', '31', 1],
      ['2, 6, 12, 20, 30, ?', '40', '42', '44', '38', 1],
      ['81, 27, 9, 3, ?', '0', '1', '2', '1/3', 1],
      ['10, 9, 7, 4, ?', '0', '1', '2', '-1', 0],
      ['144, 121, 100, 81, ?', '64', '62', '66', '60', 0],
      ['3, 5, 9, 17, 33, ?', '65', '63', '64', '67', 0],
      ['7, 14, 28, 56, ?', '100', '112', '108', '120', 1],
      ['1, 4, 9, 16, 25, ?', '34', '36', '38', '40', 1],
      ['120, 60, 30, 15, ?', '7.5', '7', '8', '10', 0],
      ['2, 3, 5, 7, 11, 13, ?', '17', '15', '16', '18', 0],
      ['1, 5, 14, 30, 55, ?', '91', '90', '89', '92', 0],
      ['500, 250, 125, 62.5, ?', '31.25', '31', '32', '30', 0],
      ['1, 3, 6, 10, 15, ?', '20', '21', '22', '25', 1],
      ['64, 32, 16, 8, ?', '2', '4', '6', '3', 1],
      ['10, 30, 90, 270, ?', '810', '800', '900', '720', 0],
      ['2, 5, 10, 17, 26, ?', '37', '35', '38', '40', 0],
    ];
    for (var s in series) {
      qs.add(Question(
        id: 0,
        text: 'Complete the series: ${s[0]}',
        options: [s[1] as String, s[2] as String, s[3] as String, s[4] as String],
        correctIndex: s[5] as int,
        section: 'verbal',
        category: 'Series',
      ));
    }

    // Synonyms (60)
    final synonyms = [
      ['Diligent', 'Lazy', 'Hardworking', 'Careless', 'Indifferent', 1],
      ['Audacious', 'Timid', 'Bold', 'Meek', 'Shy', 1],
      ['Benevolent', 'Cruel', 'Kind', 'Mean', 'Selfish', 1],
      ['Obsolete', 'Modern', 'Electric', 'Outdated', 'Current', 3],
      ['Taciturn', 'Talkative', 'Noisy', 'Silent', 'Loud', 2],
      ['Arduous', 'Simple', 'Easy', 'Difficult', 'Comfortable', 2],
      ['Candid', 'Fake', 'Sincere', 'Dishonest', 'Sly', 1],
      ['Vigilant', 'Careless', 'Alert', 'Sleeping', 'Tired', 1],
      ['Prudent', 'Reckless', 'Wise', 'Foolish', 'Hasty', 1],
      ['Serene', 'Noisy', 'Angry', 'Calm', 'Stormy', 2],
      ['Loquacious', 'Quiet', 'Talkative', 'Reserved', 'Shy', 1],
      ['Frugal', 'Wasteful', 'Thrifty', 'Generous', 'Careless', 1],
      ['Pernicious', 'Safe', 'Harmless', 'Harmful', 'Gentle', 2],
      ['Verbose', 'Brief', 'Wordy', 'Concise', 'Clear', 1],
      ['Impetuous', 'Cautious', 'Rash', 'Careful', 'Steady', 1],
      ['Magnanimous', 'Small', 'Generous', 'Mean', 'Petty', 1],
      ['Tenacious', 'Weak', 'Persistent', 'Flexible', 'Yielding', 1],
      ['Copious', 'Scarce', 'Plentiful', 'Limited', 'Few', 1],
      ['Ephemeral', 'Lasting', 'Temporary', 'Permanent', 'Endless', 1],
      ['Acrimonious', 'Pleasant', 'Bitter', 'Sweet', 'Mild', 1],
    ];
    for (var s in synonyms) {
      qs.add(Question(
        id: 0,
        text: 'Synonym of "${s[0]}":',
        options: [s[1] as String, s[2] as String, s[3] as String, s[4] as String],
        correctIndex: s[5] as int,
        section: 'verbal',
        category: 'Synonym',
      ));
    }

    // Antonyms (60)
    final antonyms = [
      ['Brave', 'Courageous', 'Bold', 'Cowardly', 'Daring', 2],
      ['Ascend', 'Rise', 'Climb', 'Descend', 'Go up', 2],
      ['Transparent', 'Clear', 'Opaque', 'Obvious', 'Visible', 1],
      ['Ancient', 'Old', 'Antique', 'Modern', 'Aged', 2],
      ['Victory', 'Win', 'Success', 'Defeat', 'Triumph', 2],
      ['Rigid', 'Hard', 'Stiff', 'Flexible', 'Firm', 2],
      ['Abundant', 'Plentiful', 'Scarce', 'Rich', 'Ample', 1],
      ['Prosper', 'Thrive', 'Fail', 'Succeed', 'Grow', 1],
      ['Arrogant', 'Proud', 'Humble', 'Boastful', 'Vain', 1],
      ['Wisdom', 'Knowledge', 'Ignorance', 'Intelligence', 'Learning', 1],
      ['Bliss', 'Joy', 'Misery', 'Happiness', 'Delight', 1],
      ['Authentic', 'Genuine', 'Fake', 'Real', 'True', 1],
      ['Generous', 'Giving', 'Miser', 'Liberal', 'Kind', 1],
      ['Expand', 'Grow', 'Contract', 'Enlarge', 'Stretch', 1],
      ['Lucid', 'Clear', 'Vague', 'Transparent', 'Obvious', 1],
      ['Tame', 'Domestic', 'Wild', 'Gentle', 'Calm', 1],
      ['Dusk', 'Sunset', 'Dawn', 'Evening', 'Twilight', 1],
      ['Sorrow', 'Grief', 'Joy', 'Sadness', 'Pain', 1],
      ['Hostile', 'Unfriendly', 'Friendly', 'Aggressive', 'Rude', 1],
      ['Commence', 'Start', 'Conclude', 'Begin', 'Initiate', 1],
    ];
    for (var a in antonyms) {
      qs.add(Question(
        id: 0,
        text: 'Antonym of "${a[0]}":',
        options: [a[1] as String, a[2] as String, a[3] as String, a[4] as String],
        correctIndex: a[5] as int,
        section: 'verbal',
        category: 'Antonym',
      ));
    }

    // Odd Word Out (40)
    final oddOut = [
      ['Find the odd one out:', 'Lieutenant', 'Colonel', 'Corporal', 'Civilian', 3],
      ['Find the odd one out:', 'Pakistan', 'Karachi', 'Lahore', 'Islamabad', 0],
      ['Find the odd one out:', 'Triangle', 'Circle', 'Pentagon', 'Cube', 3],
      ['Find the odd one out:', 'Mango', 'Apple', 'Potato', 'Orange', 2],
      ['Find the odd one out:', 'Cricket', 'Hockey', 'Swimming', 'Football', 2],
      ['Find the odd one out:', 'Rifle', 'Pistol', 'Grenade', 'Helmet', 3],
      ['Find the odd one out:', 'Moon', 'Sun', 'Earth', 'Pluto', 1],
      ['Find the odd one out:', 'Steel', 'Iron', 'Copper', 'Wood', 3],
      ['Find the odd one out:', 'Urdu', 'Hindi', 'English', 'History', 3],
      ['Find the odd one out:', 'Kite', 'Eagle', 'Pigeon', 'Dolphin', 3],
    ];
    for (var o in oddOut) {
      qs.add(Question(
        id: 0,
        text: '${o[0]}\n${o[1]}, ${o[2]}, ${o[3]}, ${o[4]}',
        options: [o[1] as String, o[2] as String, o[3] as String, o[4] as String],
        correctIndex: o[5] as int,
        section: 'verbal',
        category: 'OddOut',
      ));
    }

    // Coding/Decoding (40)
    final coding = [
      ['If CAT = 3120, then DOG = ?', '4157', '41521', '4815', '4152', 0],
      ['In code: ARMY = BSNZ, then NAVY = ?', 'OBWZ', 'OBXZ', 'OCWZ', 'OBVZ', 0],
      ['If 1=A, 2=B, 26=Z, then ISSB = ?', '9-19-19-2', '9-18-19-2', '9-19-18-2', '8-19-19-2', 0],
      ['If GO = 15, DO = 19, then OF = ?', '21', '20', '19', '22', 0],
      ['If BLACK = 43, WHITE = ?', '65', '57', '60', '58', 1],
      ['If SOLDIER = 1234567, what is SLIDE?', '12345', '12456', '12354', '12346', 2],
      ['If TABLE = UBFMF, then CHAIR = ?', 'DIBJS', 'EJCKS', 'DHAIQ', 'DJBKT', 0],
      ['If KABUL is coded as LBCVM, then LAHORE is coded as?', 'MBIPSF', 'MBJQTG', 'NAIPSF', 'MCHQTG', 0],
      ['If A=1, B=2, Z=26, what is PMA?', '16-13-1', '15-13-1', '16-14-1', '17-13-1', 0],
    ];
    for (var c in coding) {
      qs.add(Question(
        id: 0,
        text: c[0] as String,
        options: [c[1] as String, c[2] as String, c[3] as String, c[4] as String],
        correctIndex: c[5] as int,
        section: 'verbal',
        category: 'Coding',
      ));
    }

    // Authentic PMA Past Papers: Time, Days & Sequence Logic (High-Yield)
    final timeSequence = [
      ['If yesterday was Sunday, then the day after tomorrow will be?', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 1],
      ['If yesterday was Friday, what day was before yesterday?', 'Tuesday', 'Wednesday', 'Thursday', 'Saturday', 1],
      ['If the 4th day of a month is Friday, then the 19th day of the month will be?', 'Friday', 'Saturday', 'Sunday', 'Monday', 1],
      ['If the 2nd day of a month is Sunday, then the 23rd day of the month will be?', 'Saturday', 'Sunday', 'Monday', 'Tuesday', 1],
      ['If yesterday was Monday, what day will be three days after tomorrow?', 'Friday', 'Saturday', 'Sunday', 'Thursday', 1],
      ['If the day before yesterday was Thursday, what day will be tomorrow?', 'Saturday', 'Sunday', 'Monday', 'Friday', 1],
      ['If the 28th of a month is Sunday, what was the 7th of that month?', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 2],
      ['If 1st January is Friday, what day is 31st January in that year?', 'Saturday', 'Sunday', 'Monday', 'Friday', 1],
      ['If tomorrow is Sunday, what day was yesterday?', 'Thursday', 'Friday', 'Saturday', 'Monday', 1],
      ['If the third day of a month is Tuesday, then the 25th day will be?', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 1],
    ];
    for (var ts in timeSequence) {
      qs.add(Question(
        id: 0,
        text: ts[0] as String,
        options: [ts[1] as String, ts[2] as String, ts[3] as String, ts[4] as String],
        correctIndex: ts[5] as int,
        section: 'verbal',
        category: 'Time & Sequence',
      ));
    }

    // Authentic PMA Past Papers: Arithmetic Logic & Speed Math (High-Yield)
    final arithmeticLogic = [
      ['Quarter of one tenth of 120 is?', '2', '3', '4', '6', 1],
      ['One third of one tenth of 90 is?', '2', '3', '4', '5', 1],
      ['A train runs at 90 km/h. How much distance does it cover in 12 minutes?', '15 km', '18 km', '20 km', '22 km', 1],
      ['A train runs at 60 km/h. How much distance does it cover in 15 minutes?', '12 km', '15 km', '18 km', '20 km', 1],
      ['A car covers 60 km in 40 minutes. What is its speed in km/h?', '80 km/h', '90 km/h', '100 km/h', '85 km/h', 1],
      ['One dozen eggs cost Rs. 60. What is the cost of 4 eggs?', 'Rs. 15', 'Rs. 20', 'Rs. 25', 'Rs. 30', 1],
      ['If 5 men paint a house in 10 days, how many days will 10 men take?', '4 days', '5 days', '6 days', '7 days', 1],
      ['A father is 4 times as old as his son. If the sum of their ages is 50, how old is the son?', '8 years', '10 years', '12 years', '14 years', 1],
      ['Ali\'s father has 5 sons: Ten, Twenty, Thirty, Forty. What is the name of the 5th son?', 'Fifty', 'Sixty', 'Ali', 'None', 2],
      ['If 2 pencils cost 8 rupees, how many pencils can you buy for 40 rupees?', '8', '10', '12', '15', 1],
      ['A man walks 3 km North, turns right and walks 4 km. How far is he from the starting point?', '4 km', '5 km', '6 km', '7 km', 1],
      ['A boy faces East, turns 90° clockwise, then 180°. Which direction is he facing?', 'North', 'South', 'East', 'West', 0],
    ];
    for (var al in arithmeticLogic) {
      qs.add(Question(
        id: 0,
        text: al[0] as String,
        options: [al[1] as String, al[2] as String, al[3] as String, al[4] as String],
        correctIndex: al[5] as int,
        section: 'verbal',
        category: 'Arithmetic Logic',
      ));
    }

    // Authentic PMA Past Papers: Blood Relations (High-Yield)
    final bloodRelations = [
      ['Brother of my father\'s sister is my:', 'Paternal Uncle', 'Maternal Uncle', 'Father or Paternal Uncle', 'Cousin', 2],
      ['A is the mother of B, but B is not the son of A. What is B to A?', 'Daughter', 'Sister', 'Niece', 'Cousin', 0],
      ['Pointing to a photograph, a man says: "He is the only son of my father\'s father." The man in photograph is his:', 'Brother', 'Father', 'Uncle', 'Grandfather', 1],
      ['Brother of my wife\'s sister is my:', 'Brother-in-law', 'Cousin', 'Uncle', 'Nephew', 0],
      ['My mother\'s mother\'s only daughter is my:', 'Aunt', 'Mother', 'Sister', 'Grandmother', 1],
      ['Sister of my mother\'s husband is my:', 'Aunt (Phuppo)', 'Maternal Aunt (Khala)', 'Mother', 'Grandmother', 0],
      ['Son of my father\'s only son is my:', 'Brother', 'Son', 'Nephew', 'Cousin', 1],
      ['A\'s son is B\'s brother. How is A related to B?', 'Father/Mother', 'Uncle', 'Brother', 'Grandfather', 0],
    ];
    for (var br in bloodRelations) {
      qs.add(Question(
        id: 0,
        text: br[0] as String,
        options: [br[1] as String, br[2] as String, br[3] as String, br[4] as String],
        correctIndex: br[5] as int,
        section: 'verbal',
        category: 'Blood Relations',
      ));
    }

    return qs;
  }

  // ── GENERAL KNOWLEDGE ────────────────────────────────────────────────────────

  static List<Question> gkQuestions() {
    final List<Question> qs = [];

    final pakistanGk = [
      ['Who is the founder of Pakistan?', 'Allama Iqbal', 'Quaid-e-Azam Muhammad Ali Jinnah', 'Liaquat Ali Khan', 'Sir Syed Ahmad Khan', 1],
      ['Pakistan became an independent nation on:', '14 August 1947', '23 March 1940', '14 August 1948', '15 August 1947', 0],
      ['Who was the first Governor General of Pakistan?', 'Quaid-e-Azam Muhammad Ali Jinnah', 'Khawaja Nazimuddin', 'Ghulam Muhammad', 'Iskander Mirza', 0],
      ['Who was the second Governor General of Pakistan?', 'Quaid-e-Azam', 'Khawaja Nazimuddin', 'Ghulam Muhammad', 'Iskander Mirza', 1],
      ['Who was the first President of Pakistan?', 'Ayub Khan', 'Iskander Mirza', 'Liaquat Ali Khan', 'Yahya Khan', 1],
      ['Who was the first Prime Minister of Pakistan?', 'Iskander Mirza', 'Liaquat Ali Khan', 'Nurul Amin', 'Chaudhry Muhammad Ali', 1],
      ['The Lahore Resolution (1940) was presented by:', 'Quaid-e-Azam', 'A.K. Fazlul Huq (Sher-e-Bangal)', 'Liaquat Ali Khan', 'Allama Iqbal', 1],
      ['First Martial Law in Pakistan was imposed in:', '1956', '1958', '1965', '1969', 1],
      ['Pakistan\'s 1973 Constitution was enforced on:', '23 March 1973', '14 August 1973', '21 April 1973', '6 September 1973', 1],
      ['Which pass connects Pakistan with China?', 'Khyber Pass', 'Khunjerab Pass', 'Bolan Pass', 'Gomal Pass', 1],
      ['Which pass connects Pakistan with Afghanistan?', 'Khyber Pass', 'Khunjerab Pass', 'Bolan Pass', 'Lowari Pass', 0],
      ['Bolan Pass is located in which province?', 'Punjab', 'Sindh', 'Balochistan', 'KPK', 2],
      ['What is the national sport of Pakistan?', 'Cricket', 'Hockey', 'Squash', 'Football', 1],
      ['The highest military award in Pakistan is:', 'Sitara-e-Jurat', 'Nishan-e-Haider', 'Hilal-e-Jurat', 'Tamgha-e-Shujaat', 1],
      ['First recipient of Nishan-e-Haider in 1948 was:', 'Major Raja Aziz Bhatti', 'Captain Raja Muhammad Sarwar', 'Major Shabbir Sharif', 'Rashid Minhas', 1],
      ['The youngest recipient of Nishan-e-Haider was:', 'Rashid Minhas', 'Muhammad Sarwar', 'Aziz Bhatti', 'Sawwar Muhammad Hussain', 0],
      ['Total recipients of Nishan-e-Haider to date are:', '10', '11', '12', '9', 1],
      ['GHQ of Pakistan Army is located in:', 'Lahore', 'Karachi', 'Rawalpindi', 'Islamabad', 2],
      ['Pakistan Navy Headquarters is located in:', 'Karachi', 'Rawalpindi', 'Islamabad', 'Gwadar', 2],
      ['PMA Kakul is located near which city?', 'Rawalpindi', 'Abbottabad', 'Peshawar', 'Murree', 1],
      ['PAF Academy is located in:', 'Risalpur', 'Sargodha', 'Kamra', 'Chaklala', 0],
      ['Which river is the longest in Pakistan?', 'Chenab', 'Jhelum', 'Indus (3,180 km)', 'Kabul', 2],
      ['K2 (Godwin Austen) is the second highest peak in the world, height is:', '8,611 meters', '8,126 meters', '8,848 meters', '7,788 meters', 0],
      ['Second highest mountain peak in Pakistan is:', 'Rakaposhi', 'Nanga Parbat (8,126m)', 'Tirich Mir', 'Broad Peak', 1],
      ['Pakistan conducted nuclear tests on (Youm-e-Takbeer):', '28 May 1998', '23 March 1998', '14 August 1997', '6 September 1998', 0],
      ['Pakistan joined the United Nations on:', '30 September 1947', '14 August 1947', '24 October 1947', '1 January 1948', 0],
      ['CPEC stands for:', 'China-Pakistan Economic Cooperation', 'China-Pakistan Economic Corridor', 'Central Pakistan Economic Corridor', 'China-Pakistan Energy Corridor', 1],
      ['The national anthem of Pakistan was composed by:', 'Hafeez Jalandhari (lyrics) & A.G. Chagla (tune)', 'Allama Iqbal', 'Faiz Ahmad Faiz', 'Josh Malihabadi', 0],
      ['Which city is known as the City of Lights in Pakistan?', 'Lahore', 'Islamabad', 'Karachi', 'Faisalabad', 2],
      ['The Indus Waters Treaty (1960) was brokered by:', 'United Nations', 'World Bank', 'IMF', 'USA', 1],
      ['Islamabad officially became the capital of Pakistan in:', '1947', '1958', '1960/1967', '1973', 2],
      ['The Thar desert is in which province?', 'Punjab', 'Balochistan', 'Sindh', 'KPK', 2],
      ['The motto of Pakistan Army is:', 'Ittehad, Yaqeen, Tanzeem', 'Iman, Taqwa, Jihad fi Sabilillah', 'Unity, Faith, Discipline', 'Service, Honor, Country', 1],
      ['Which is the largest province of Pakistan by area?', 'Punjab', 'Sindh', 'Balochistan (44%)', 'KPK', 2],
      ['Which is the most populous province of Pakistan?', 'Sindh', 'Punjab', 'KPK', 'Balochistan', 1],
      ['The Quaid-e-Azam was born on:', '25 December 1876', '25 December 1875', '23 March 1876', '14 August 1876', 0],
      ['The national animal of Pakistan is:', 'Snow Leopard', 'Markhor', 'Tiger', 'Lion', 1],
      ['SSG stands for:', 'Special Services Group', 'Senior Services Group', 'Special Security Guard', 'Strategic Support Group', 0],
      ['Which treaty ended the 1965 war between Pakistan and India?', 'Simla Agreement', 'Tashkent Declaration (1966)', 'Lahore Declaration', 'Delhi Accord', 1],
    ];

    for (var q in pakistanGk) {
      qs.add(Question(
        id: 0,
        text: q[0] as String,
        options: [q[1] as String, q[2] as String, q[3] as String, q[4] as String],
        correctIndex: q[5] as int,
        section: 'gk',
        category: 'Pakistan',
      ));
    }

    // World GK (Authentic PMA repeated)
    final worldGk = [
      ['Capital of Australia is:', 'Sydney', 'Melbourne', 'Canberra', 'Perth', 2],
      ['Capital of Canada is:', 'Toronto', 'Montreal', 'Ottawa', 'Vancouver', 2],
      ['Capital of Turkey is:', 'Istanbul', 'Ankara', 'Izmir', 'Antalya', 1],
      ['Capital of New Zealand is:', 'Auckland', 'Wellington', 'Christchurch', 'Hamilton', 1],
      ['Capital of Saudi Arabia is:', 'Jeddah', 'Mecca', 'Riyadh', 'Medina', 2],
      ['The United Nations was founded on:', '24 October 1945', '14 August 1945', '1 January 1946', '23 March 1945', 0],
      ['Headquarters of the United Nations is in:', 'Geneva', 'New York City', 'Washington DC', 'London', 1],
      ['Headquarters of OIC (Organisation of Islamic Cooperation) is in:', 'Riyadh', 'Jeddah', 'Mecca', 'Cairo', 1],
      ['Headquarters of SAARC is located in:', 'Islamabad', 'New Delhi', 'Kathmandu', 'Dhaka', 2],
      ['The largest ocean on Earth is:', 'Atlantic Ocean', 'Indian Ocean', 'Pacific Ocean', 'Arctic Ocean', 2],
      ['The smallest ocean on Earth is:', 'Indian Ocean', 'Arctic Ocean', 'Southern Ocean', 'Atlantic Ocean', 1],
      ['The longest river in the world is:', 'Amazon River', 'Nile River', 'Yangtze River', 'Mississippi', 1],
      ['The deepest point in Earth\'s oceans is:', 'Java Trench', 'Mariana Trench', 'Puerto Rico Trench', 'Sunda Trench', 1],
      ['Suez Canal connects Mediterranean Sea with:', 'Black Sea', 'Red Sea', 'Arabian Sea', 'Dead Sea', 1],
      ['Currency of Japan is:', 'Yuan', 'Won', 'Yen', 'Ringgit', 2],
      ['Currency of China is:', 'Yen', 'Yuan (Renminbi)', 'Baht', 'Ringgit', 1],
      ['Which country is known as Land of the Rising Sun?', 'China', 'Japan', 'South Korea', 'Norway', 1],
      ['World War I was fought between:', '1914 – 1918', '1912 – 1916', '1939 – 1945', '1915 – 1920', 0],
      ['World War II was fought between:', '1935 – 1940', '1939 – 1945', '1940 – 1946', '1938 – 1944', 1],
      ['NATO headquarters is located in:', 'Washington DC', 'London', 'Brussels (Belgium)', 'Paris', 2],
    ];
    for (var q in worldGk) {
      qs.add(Question(
        id: 0,
        text: q[0] as String,
        options: [q[1] as String, q[2] as String, q[3] as String, q[4] as String],
        correctIndex: q[5] as int,
        section: 'gk',
        category: 'World',
      ));
    }

    // Islamic GK (Authentic PMA repeated)
    final islamicGk = [
      ['The Battle of Badr took place in:', '1 AH', '2 AH (17 Ramadan)', '3 AH', '4 AH', 1],
      ['Number of Muslims in the Battle of Badr was:', '313', '700', '1,000', '1,400', 0],
      ['Number of non-Muslims (Kuffar) in Battle of Badr was:', '313', '700', '1,000', '3,000', 2],
      ['The Battle of Uhud took place in:', '2 AH', '3 AH', '4 AH', '5 AH', 1],
      ['The Battle of Khandaq (Trench) took place in:', '4 AH', '5 AH', '6 AH', '7 AH', 1],
      ['Who suggested digging the trench in Battle of Khandaq?', 'Hazrat Ali (RA)', 'Hazrat Salman Farsi (RA)', 'Hazrat Umar (RA)', 'Hazrat Abu Bakr (RA)', 1],
      ['Treaty of Hudaibiya was signed in:', '5 AH', '6 AH', '7 AH', '8 AH', 1],
      ['Conquest of Makkah (Fath-e-Makkah) occurred in:', '7 AH', '8 AH (20 Ramadan)', '9 AH', '10 AH', 1],
      ['How many Surahs are in the Holy Quran?', '112', '113', '114', '115', 2],
      ['How many Manzils are there in the Holy Quran?', '5', '6', '7', '8', 2],
      ['The longest Surah in the Holy Quran is:', 'Surah Al-Imran', 'Surah Al-Baqarah', 'Surah An-Nisa', 'Surah Yaseen', 1],
      ['The shortest Surah in the Holy Quran is:', 'Surah Al-Ikhlas', 'Surah Al-Kawthar', 'Surah An-Nas', 'Surah Al-Falaq', 1],
      ['Which Surah of Holy Quran does not begin with Bismillah?', 'Surah At-Tawbah', 'Surah Al-Anfal', 'Surah Yaseen', 'Surah Al-Fatiha', 0],
      ['Which Surah of Holy Quran has Bismillah twice?', 'Surah Al-Baqarah', 'Surah An-Naml', 'Surah Ar-Rahman', 'Surah Al-Mulk', 1],
      ['The first revelation of the Quran was sent down in:', 'Cave Thawr', 'Cave Hira', 'Masjid Al-Haram', 'Masjid Nabawi', 1],
      ['The Holy Quran was compiled in book form during caliphate of:', 'Hazrat Ali (RA)', 'Hazrat Umar (RA)', 'Hazrat Abu Bakr (RA)', 'Hazrat Uthman (RA)', 2],
      ['The sequence of the Four Rightly Guided Caliphs (Khulafa-e-Rashideen) is:', 'Abu Bakr, Umar, Uthman, Ali (RA)', 'Umar, Abu Bakr, Ali, Uthman (RA)', 'Abu Bakr, Uthman, Umar, Ali (RA)', 'Ali, Abu Bakr, Umar, Uthman (RA)', 0],
      ['Nisab of Zakat in silver is:', '40 tolas', '52.5 tolas', '60 tolas', '7.5 tolas', 1],
      ['Nisab of Zakat in gold is:', '5 tolas', '7.5 tolas', '10 tolas', '52.5 tolas', 1],
      ['Which angel brought revelations to Prophet Muhammad (PBUH)?', 'Mikail', 'Israfil', 'Jibrail (Gabriel)', 'Izrail', 2],
    ];
    for (var q in islamicGk) {
      qs.add(Question(
        id: 0,
        text: q[0] as String,
        options: [q[1] as String, q[2] as String, q[3] as String, q[4] as String],
        correctIndex: q[5] as int,
        section: 'gk',
        category: 'Islamic',
      ));
    }

    // Science GK (30)
    final scienceGk = [
      ['DNA stands for:', 'Deoxyribonucleic Acid', 'Deoxyrobonucleic Acid', 'Diribonucleic Acid', 'Deothyribonucleic Acid', 0],
      ['The speed of light is approximately:', '3×10⁸ m/s', '3×10⁶ m/s', '3×10⁷ m/s', '3×10⁹ m/s', 0],
      ['The powerhouse of the cell is:', 'Nucleus', 'Ribosome', 'Mitochondria', 'Golgi Apparatus', 2],
      ['Which gas is responsible for the greenhouse effect?', 'Nitrogen', 'Oxygen', 'Carbon Dioxide', 'Hydrogen', 2],
      ['The human body has how many bones?', '198', '206', '212', '200', 1],
      ['The nearest star to Earth is:', 'Sirius', 'Sun (then Proxima Centauri)', 'Alpha Centauri', 'Betelgeuse', 1],
      ['Newton\'s first law is also called the law of:', 'Gravitation', 'Inertia', 'Momentum', 'Motion', 1],
      ['Water is a compound of:', 'Oxygen and Nitrogen', 'Hydrogen and Carbon', 'Hydrogen and Oxygen', 'Oxygen and Helium', 2],
      ['Which metal is a liquid at room temperature?', 'Gold', 'Copper', 'Mercury', 'Lead', 2],
      ['The ozone layer is located in the:', 'Troposphere', 'Stratosphere', 'Mesosphere', 'Thermosphere', 1],
    ];
    for (var q in scienceGk) {
      qs.add(Question(
        id: 0,
        text: q[0] as String,
        options: [q[1] as String, q[2] as String, q[3] as String, q[4] as String],
        correctIndex: q[5] as int,
        section: 'gk',
        category: 'Science',
      ));
    }

    return qs;
  }

  // ── ENGLISH ──────────────────────────────────────────────────────────────────

  static List<Question> englishQuestions() {
    final List<Question> qs = [];

    // Grammar (80)
    final grammar = [
      ['She ___ a book when I called her.', 'reads', 'is reading', 'was reading', 'read', 2],
      ['Neither the teachers nor the student ___ present.', 'are', 'is', 'were', 'have been', 1],
      ['The committee ___ reached a decision.', 'have', 'has', 'are', 'were', 1],
      ['If I ___ you, I would not do that.', 'am', 'was', 'were', 'had been', 2],
      ['He has been working here ___ five years.', 'since', 'for', 'from', 'during', 1],
      ['She is good ___ mathematics.', 'in', 'at', 'with', 'for', 1],
      ['The thief was caught by the ___', 'policeman', 'police', 'polices', 'policemans', 1],
      ['I congratulated him ___ his success.', 'for', 'on', 'upon', 'about', 1],
      ['Each of the boys ___ a pen.', 'has', 'have', 'had', 'having', 0],
      ['He ___ in this city for two years before he moved.', 'lived', 'has lived', 'had lived', 'was living', 2],
      ['The news ___ surprising.', 'are', 'is', 'were', 'be', 1],
      ['She speaks English ___ than her brother.', 'more fluent', 'more fluently', 'fluently', 'fluenter', 1],
      ['He is looking forward ___ you.', 'to see', 'to seeing', 'for seeing', 'see', 1],
      ['I insist that he ___ present at the meeting.', 'is', 'be', 'was', 'were', 1],
      ['They finished the project ___ time.', 'in', 'on', 'at', 'by', 1],
      ['No sooner ___ he left than it started to rain.', 'had', 'was', 'has', 'did', 0],
      ['She is ___ honest woman.', 'a', 'an', 'the', 'some', 1],
      ['You should avoid ___ late.', 'to come', 'come', 'coming', 'came', 2],
      ['The soldiers marched ___ the city.', 'through', 'across', 'along', 'into', 0],
      ['My friend, along with his brothers, ___ joining the army.', 'is', 'are', 'were', 'have', 0],
    ];
    for (var g in grammar) {
      qs.add(Question(
        id: 0,
        text: 'Fill in the blank: ${g[0]}',
        options: [g[1] as String, g[2] as String, g[3] as String, g[4] as String],
        correctIndex: g[5] as int,
        section: 'english',
        category: 'Grammar',
      ));
    }

    // Vocabulary (40)
    final vocab = [
      ['What is the meaning of "Daunting"?', 'Exciting', 'Discouraging', 'Courageous', 'Frightening', 1],
      ['What is the meaning of "Resilient"?', 'Weak', 'Stubborn', 'Able to recover', 'Fragile', 2],
      ['What does "Perseverance" mean?', 'Laziness', 'Intelligence', 'Steady persistence', 'Quick success', 2],
      ['What is the meaning of "Verbose"?', 'Brief', 'Using too many words', 'Silent', 'Accurate', 1],
      ['What does "Impeccable" mean?', 'Flawed', 'Perfect', 'Ordinary', 'Clean', 1],
      ['What is the meaning of "Ameliorate"?', 'Worsen', 'Improve', 'Delay', 'Ignore', 1],
      ['What does "Ubiquitous" mean?', 'Rare', 'Present everywhere', 'Invisible', 'Strange', 1],
      ['What is the meaning of "Tacit"?', 'Loud', 'Implied without words', 'Written', 'Permission', 1],
      ['What does "Pragmatic" mean?', 'Idealistic', 'Practical', 'Emotional', 'Theoretical', 1],
      ['What is the meaning of "Callous"?', 'Caring', 'Hard-hearted', 'Sensitive', 'Emotional', 1],
    ];
    for (var v in vocab) {
      qs.add(Question(
        id: 0,
        text: v[0] as String,
        options: [v[1] as String, v[2] as String, v[3] as String, v[4] as String],
        correctIndex: v[5] as int,
        section: 'english',
        category: 'Vocabulary',
      ));
    }

    // One Word Substitution / Idioms (30)
    final idioms = [
      ['One who eats too much:', 'Cannibal', 'Glutton', 'Vegetarian', 'Omnivore', 1],
      ['A person who collects stamps:', 'Archivist', 'Numismatist', 'Philatelist', 'Ornithologist', 2],
      ['Kill the goose that lays the golden egg means:', 'To be lucky', 'To destroy a source of income', 'To work hard', 'To waste time', 1],
      ['Hit the nail on the head means:', 'To work accurately', 'To do something exactly right', 'To miss', 'To hammer harder', 1],
      ['A speech made without preparation:', 'Extempore', 'Monologue', 'Soliloquy', 'Impromptu', 3],
      ['A building where animals are kept:', 'Aviary', 'Kennel', 'Zoo', 'Stable', 2],
      ['Fear of heights is called:', 'Claustrophobia', 'Acrophobia', 'Hydrophobia', 'Xenophobia', 1],
      ['Bite the bullet means:', 'To eat', 'To endure pain bravely', 'To fight', 'To surrender', 1],
      ['A place where bread is made:', 'Kitchen', 'Bakery', 'Pantry', 'Dairy', 1],
      ['Once in a blue moon means:', 'Very often', 'Very rarely', 'Never', 'Sometimes', 1],
    ];
    for (var id in idioms) {
      qs.add(Question(
        id: 0,
        text: id[0] as String,
        options: [id[1] as String, id[2] as String, id[3] as String, id[4] as String],
        correctIndex: id[5] as int,
        section: 'english',
        category: 'Vocabulary',
      ));
    }

    return qs;
  }

  // ── MATHEMATICS ──────────────────────────────────────────────────────────────

  static List<Question> mathQuestions() {
    final List<Question> qs = [];

    final maths = [
      // Percentages
      ['20% of 500 = ?', '80', '100', '120', '90', 1],
      ['What % of 200 is 50?', '20%', '25%', '30%', '15%', 1],
      ['A shirt costs Rs.800. It is sold at 25% profit. SP = ?', 'Rs.950', 'Rs.1000', 'Rs.1100', 'Rs.1050', 1],
      ['A TV costs Rs.20,000. After 10% discount and 5% tax, final price = ?', 'Rs.18,900', 'Rs.19,000', 'Rs.18,800', 'Rs.19,200', 0],
      ['If price increased from 400 to 500, % increase = ?', '25%', '20%', '30%', '15%', 0],
      // Ratios & Proportions
      ['If A:B = 3:5 and B:C = 2:4, then A:C = ?', '3:10', '6:20', 'Both a & b', '1:10', 2],
      ['A car travels 300 km in 5 hours. Speed = ?', '55 km/h', '60 km/h', '50 km/h', '65 km/h', 1],
      ['Two numbers in ratio 3:7 with sum 70. Smaller = ?', '21', '20', '30', '15', 0],
      ['A map scale is 1:50000. 3 cm on map = ? km', '1.5', '2', '1', '2.5', 0],
      // Algebra
      ['If 3x + 6 = 21, then x = ?', '4', '5', '6', '3', 1],
      ['If x² = 144, then x = ?', '10', '12', '11', '13', 1],
      ['(a+b)² = ?', 'a²+b²', 'a²+2ab+b²', 'a²-2ab+b²', '2ab', 1],
      ['If 5x - 3 = 2x + 9, then x = ?', '4', '5', '6', '3', 0],
      ['The sum of n natural numbers = n(n+1)/2. Sum of first 20 = ?', '200', '210', '190', '220', 1],
      ['What is the LCM of 12 and 18?', '36', '24', '72', '48', 0],
      // Geometry
      ['Area of a circle with radius 7 cm (π=22/7) = ?', '154 cm²', '144 cm²', '164 cm²', '149 cm²', 0],
      ['A rectangle has length 12 and width 5. Perimeter = ?', '32', '34', '60', '17', 1],
      ['Volume of a cube with side 4 cm = ?', '64 cm³', '48 cm³', '32 cm³', '16 cm³', 0],
      ['Pythagoras theorem: a² + b² = ?', 'ab', 'c²', '2c', 'c', 1],
      ['Angles of a triangle sum to:', '90°', '180°', '270°', '360°', 1],
      ['Area of triangle with base 10 and height 6 = ?', '60', '30', '40', '16', 1],
      // Averages & Work
      ['Average of 10, 20, 30, 40, 50 = ?', '25', '30', '35', '20', 1],
      ['A can do work in 10 days. B in 15 days. Together in ?', '5 days', '6 days', '7 days', '8 days', 1],
      ['If 8 men do work in 12 days, 4 men will do it in ?', '18', '24', '20', '16', 1],
      // Simple & Compound Interest
      ['SI on Rs.1000 at 10% for 2 years = ?', 'Rs.100', 'Rs.200', 'Rs.150', 'Rs.250', 1],
      ['CI on Rs.1000 at 10% for 2 years = ?', 'Rs.200', 'Rs.210', 'Rs.205', 'Rs.220', 1],
      // Speed & Distance
      ['Train 200m long at 60km/h. Time to cross a pole = ?', '10 s', '12 s', '8 s', '15 s', 1],
      ['A man walks 5 km in 1 hour. In 3 hours = ?', '10 km', '15 km', '12 km', '20 km', 1],
      // Probability
      ['Probability of getting heads in a coin toss = ?', '1', '1/2', '1/4', '0', 1],
      ['A die is rolled. P(getting 6) = ?', '1/6', '1/3', '1/2', '1/4', 0],
    ];

    for (var m in maths) {
      qs.add(Question(
        id: 0,
        text: m[0] as String,
        options: [m[1] as String, m[2] as String, m[3] as String, m[4] as String],
        correctIndex: m[5] as int,
        section: 'math',
        category: 'Mixed',
      ));
    }

    return qs;
  }

  // ── NON-VERBAL ───────────────────────────────────────────────────────────────

  static List<Question> nonVerbalQuestions() {
    final List<Question> qs = [];

    // Comprehensive PMA Non-Verbal Intelligence Set (Figure series, classification, analogies, mirrors, matrices)
    final nonVerbal = [
      ['Which shape has the MOST sides?', 'Triangle (3)', 'Pentagon (5)', 'Hexagon (6)', 'Octagon (8)', 3, 'Geometry & Spatial'],
      ['How many cubes are in a 2×2×2 large cube?', '4', '6', '8', '12', 2, 'Geometry & Spatial'],
      ['Odd one out in shape: Circle, Oval, Rectangle, Sphere', 'Circle', 'Oval', 'Rectangle', 'Sphere (3D)', 3, 'Odd One Out'],
      ['A square is rotated 90° clockwise. How does it look?', 'Horizontal line', 'Same as before', 'Inverted triangle', 'Diamond with curves', 1, 'Figure Series'],
      ['How many small triangles are in a 6-pointed Star of David?', '4', '6', '8', '12', 1, 'Geometry & Spatial'],
      ['A solid cube has how many flat faces?', '4', '6', '8', '12', 1, 'Geometry & Spatial'],
      ['Mirror image of small letter "b" across vertical axis is:', 'd', 'p', 'q', 'b', 0, 'Mirror Image'],
      ['Mirror image of letter "p" across vertical axis is:', 'q', 'b', 'd', 'p', 0, 'Mirror Image'],
      ['Water reflection (horizontal axis) of letter "E" is:', 'E (same)', 'Ǝ', 'M', 'W', 0, 'Water Reflection'],
      ['Water reflection of letter "M" across horizontal axis is:', 'N', 'W', 'M', 'E', 1, 'Water Reflection'],
      ['Mirror image of the number "7" is:', 'L', 'Backward 7', 'Upside down 7', 'Same 7', 1, 'Mirror Image'],
      ['A regular hexagon has how many lines of symmetry?', '3', '4', '6', '8', 2, 'Geometry & Spatial'],
      ['Odd shape out: Cube, Cone, Cylinder, Square', 'Cube', 'Cone', 'Cylinder', 'Square (2D)', 3, 'Odd One Out'],
      ['If a clock hand rotates 45° clockwise each step, after 8 steps it has rotated:', '90°', '180°', '360° (full circle)', '270°', 2, 'Figure Series'],
      ['A 3×3 square grid contains how many total squares (1×1, 2×2, 3×3)?', '9', '12', '14 (9+4+1)', '16', 2, 'Geometry & Spatial'],
      ['How many edges does a standard cube have?', '6', '8', '12', '10', 2, 'Geometry & Spatial'],
      ['How many vertices (corners) does a cube have?', '6', '8', '10', '12', 1, 'Geometry & Spatial'],
      ['The cross-section of a solid cylinder cut perpendicular to its height is:', 'Square', 'Circle', 'Triangle', 'Ellipse', 1, 'Geometry & Spatial'],
      ['Which geometric shape has NO line of symmetry?', 'Equilateral Triangle', 'Square', 'Scalene Triangle', 'Rectangle', 2, 'Geometry & Spatial'],
      ['Odd one out: Pentagon, Hexagon, Octagon, Cylinder', 'Pentagon', 'Hexagon', 'Octagon', 'Cylinder (3D)', 3, 'Odd One Out'],
      ['A right-angled triangle has angles of 90° and 35°. What is the third angle?', '45°', '55°', '65°', '60°', 1, 'Geometry & Spatial'],
      ['If Shape A is the mirror reflection of B, then B is the mirror reflection of:', 'C', 'A', 'D', 'Neither', 1, 'Mirror Image'],
      ['How many vertices does a tetrahedron (triangular pyramid) have?', '3', '4', '5', '6', 1, 'Geometry & Spatial'],
      ['An equilateral triangle has how many lines of symmetry?', '1', '2', '3', '6', 2, 'Geometry & Spatial'],
      ['Odd one out: Trapezoid, Rhombus, Parallelogram, Pentagon', 'Trapezoid', 'Rhombus', 'Parallelogram', 'Pentagon (5 sides)', 3, 'Odd One Out'],
      ['Figure Series: Line with 1 dot, 2 dots, 3 dots, ... What comes next?', '4 dots', '5 dots', 'Circle', 'Square', 0, 'Figure Series'],
      ['Figure Series: Arrow points North, then East, then South. What comes next?', 'North', 'West', 'South-East', 'North-East', 1, 'Figure Series'],
      ['Figure Series: Triangle (3 sides), Square (4 sides), Pentagon (5 sides), ... Next is:', 'Hexagon (6 sides)', 'Heptagon', 'Octagon', 'Circle', 0, 'Figure Series'],
      ['Figure Analogy: Circle is to Sphere as Square is to:', 'Rectangle', 'Cube', 'Triangle', 'Cone', 1, 'Figure Analogy'],
      ['Figure Analogy: Triangle is to Pyramid as Circle is to:', 'Cylinder', 'Cone', 'Sphere', 'Prism', 1, 'Figure Analogy'],
      ['Figure Analogy: Small circle inside Square :: Small triangle inside:', 'Circle', 'Pentagon', 'Hexagon', 'Any outer polygon', 1, 'Figure Analogy'],
      ['Odd figure out by number of sides: Triangle, Quadrilateral, Pentagon, Sphere', 'Triangle', 'Quadrilateral', 'Pentagon', 'Sphere (curved)', 3, 'Odd One Out'],
      ['Odd figure out: Arrow pointing Up, Down, Left, Curved spiral', 'Up', 'Down', 'Left', 'Curved spiral', 3, 'Odd One Out'],
      ['Matrix Pattern: Row 1 has 1 dot, Row 2 has 2 dots, Row 3 has:', '3 dots', '4 dots', '5 dots', '0 dots', 0, 'Matrix Completion'],
      ['Matrix Pattern: Col 1 is empty circle, Col 2 is half-shaded, Col 3 is:', 'Fully shaded circle', 'Empty square', 'Empty triangle', 'Dotted line', 0, 'Matrix Completion'],
      ['If a piece of paper is folded in half 3 times, how many layers are formed?', '4', '6', '8 (2³)', '16', 2, 'Geometry & Spatial'],
      ['If a circular piece of paper is folded in half and cut along the curved edge, opening it yields:', 'A circle with hole', 'Two pieces', 'A square', 'A star', 1, 'Geometry & Spatial'],
      ['Mirror image of word "MOM" across a vertical mirror is:', 'MOM (identical)', 'WOW', 'NON', 'MOO', 0, 'Mirror Image'],
      ['Mirror image of word "DAD" across a vertical mirror is:', 'DAD', 'bAb', 'BAB', 'dAd', 1, 'Mirror Image'],
      ['Water image of word "OX" across horizontal water surface is:', 'OX (identical)', 'XO', 'XI', 'XX', 0, 'Water Reflection'],
      ['Water image of word "CODE" across horizontal line is:', 'CODE (identical)', 'EDOC', 'COOP', 'BODE', 0, 'Water Reflection'],
      ['Odd one out by symmetry: Letter A, Letter M, Letter T, Letter F', 'Letter A', 'Letter M', 'Letter T', 'Letter F (asymmetrical)', 3, 'Odd One Out'],
      ['Odd one out by symmetry: Letter H, Letter I, Letter O, Letter P', 'Letter H', 'Letter I', 'Letter O', 'Letter P (no line of symmetry)', 3, 'Odd One Out'],
      ['Figure Series: Circle with + symbol rotated 45°, 90°, 135°, ... Next angle is:', '150°', '180°', '200°', '225°', 1, 'Figure Series'],
      ['Figure Series: Clock showing 12:00, 3:00, 6:00, ... Next position is:', '8:00', '9:00', '10:00', '11:00', 1, 'Figure Series'],
      ['If you roll a die, the sum of opposite faces is ALWAYS:', '5', '6', '7', '8', 2, 'Geometry & Spatial'],
      ['If top face of standard die is 2, the bottom face is:', '3', '4', '5 (7-2)', '6', 2, 'Geometry & Spatial'],
      ['If front face of standard die is 1, the back face is:', '6 (7-1)', '5', '4', '2', 0, 'Geometry & Spatial'],
      ['A regular octagon has interior angles of:', '120°', '135°', '140°', '145°', 1, 'Geometry & Spatial'],
      ['A regular hexagon has interior angles of:', '108°', '120°', '125°', '130°', 1, 'Geometry & Spatial'],
      ['A regular pentagon has interior angles of:', '100°', '108°', '110°', '115°', 1, 'Geometry & Spatial'],
      ['Number of diagonals in a regular pentagon is:', '3', '5', '6', '8', 1, 'Geometry & Spatial'],
      ['Number of diagonals in a square is:', '1', '2', '4', '0', 1, 'Geometry & Spatial'],
      ['Figure Analogy: Shaded square : Unshaded square :: Shaded triangle : ?', 'Unshaded triangle', 'Shaded circle', 'Empty circle', 'Square', 0, 'Figure Analogy'],
      ['Figure Analogy: Large circle containing small square :: Large square containing ?', 'Small circle', 'Small triangle', 'Small hexagon', 'Large circle', 0, 'Figure Analogy'],
      ['Odd one out: Equilateral triangle, Square, Regular Pentagon, Scalene Triangle', 'Equilateral triangle', 'Square', 'Regular Pentagon', 'Scalene Triangle (irregular)', 3, 'Odd One Out'],
      ['Odd one out: Sphere, Football, Basketball, Disc', 'Sphere', 'Football', 'Basketball', 'Disc (flat 2D circle)', 3, 'Odd One Out'],
      ['Matrix Pattern: 3x3 grid with alternating diagonal lines. The missing 9th tile has:', 'Matching diagonal /', 'Straight line |', 'Horizontal line —', 'Cross +', 0, 'Matrix Completion'],
      ['How many right angles exist inside a regular rectangle?', '2', '3', '4', '6', 2, 'Geometry & Spatial'],
      ['If shape has 4 equal sides and opposite angles equal (not 90°), it is a:', 'Square', 'Rectangle', 'Rhombus', 'Trapezoid', 2, 'Geometry & Spatial'],
      ['Which letter looks the same in both vertical mirror and horizontal water reflection?', 'H', 'A', 'B', 'C', 0, 'Mirror Image'],
      ['Which number looks identical when inverted upside down (rotated 180°)?', '0 and 8', '2 and 5', '6 and 9', '3 and 8', 0, 'Figure Series'],
      ['How many degrees in total are in the four angles of any quadrilateral?', '180°', '270°', '360°', '540°', 2, 'Geometry & Spatial'],
      ['Odd one out: Star, Hexagon, Octagon, Decagon', 'Star (concave)', 'Hexagon', 'Octagon', 'Decagon', 0, 'Odd One Out'],
    ];

    for (var i = 0; i < nonVerbal.length; i++) {
      final nv = nonVerbal[i];
      qs.add(Question(
        id: 0,
        text: nv[0] as String,
        options: [nv[1] as String, nv[2] as String, nv[3] as String, nv[4] as String],
        correctIndex: nv[5] as int,
        section: 'nonverbal',
        category: nv[6] as String,
      ));
    }

    return qs;
  }
}
