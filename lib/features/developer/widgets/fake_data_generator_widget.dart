import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class FakeDataGeneratorWidget extends ConsumerStatefulWidget {
  const FakeDataGeneratorWidget({super.key});

  @override
  ConsumerState<FakeDataGeneratorWidget> createState() =>
      _FakeDataGeneratorWidgetState();
}

class _FakeDataGeneratorWidgetState
    extends ConsumerState<FakeDataGeneratorWidget> {
  int _count = 5;
  String _result = '';

  final Random _random = Random();

  // ═══════════════════════════════════════════════════════════════
// SAMPLE DATA POOLS — Hackers Fake Identity Generator
// Covers: EN, FR, ES, DE, PT, IT, AR, CN, JP, AF, NG, CI
// ═══════════════════════════════════════════════════════════════

// ── FIRST NAMES ──────────────────────────────────────────────
  final List<String> _firstNames = [
    // English / American
    'James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer',
    'Michael', 'Linda', 'William', 'Elizabeth', 'David', 'Barbara',
    'Richard', 'Susan', 'Joseph', 'Jessica', 'Thomas', 'Sarah',
    'Charles', 'Karen', 'Christopher', 'Nancy', 'Daniel', 'Lisa',
    'Matthew', 'Betty', 'Anthony', 'Margaret', 'Donald', 'Sandra',
    'Mark', 'Ashley', 'Paul', 'Dorothy', 'Steven', 'Kimberly',
    'Andrew', 'Emily', 'Kenneth', 'Donna', 'Joshua', 'Michelle',
    'Kevin', 'Carol', 'Brian', 'Amanda', 'George', 'Melissa',
    'Edward', 'Deborah', 'Ronald', 'Stephanie', 'Timothy', 'Rebecca',

    // French
    'Jean', 'Marie', 'Pierre', 'Sophie', 'Louis', 'Camille',
    'François', 'Isabelle', 'Henri', 'Nathalie', 'Philippe', 'Céline',
    'Nicolas', 'Aurélie', 'Julien', 'Mathilde', 'Antoine', 'Claire',
    'Sébastien', 'Amélie', 'Alexandre', 'Laure', 'Maxime', 'Margot',
    'Théo', 'Chloé', 'Lucas', 'Emma', 'Hugo', 'Léa',
    'Étienne', 'Pauline', 'Benoît', 'Virginie', 'Luc', 'Élise',

    // Spanish / Latin American
    'Carlos', 'Ana', 'Miguel', 'Sofía', 'Juan', 'Isabella',
    'Luis', 'Valentina', 'Alejandro', 'Camila', 'Diego', 'Daniela',
    'Andrés', 'Mariana', 'Fernando', 'Fernanda', 'Ricardo', 'Gabriela',
    'Sebastián', 'Paula', 'Rodrigo', 'Natalia', 'Pablo', 'Valeria',
    'Jorge', 'Lucía', 'Javier', 'Elena', 'Manuel', 'Beatriz',
    'Emilio', 'Rosa', 'Rafael', 'Carmen', 'Eduardo', 'Pilar',

    // German / Austrian / Swiss
    'Hans', 'Monika', 'Klaus', 'Ursula', 'Dieter', 'Brigitte',
    'Günter', 'Helga', 'Wolfgang', 'Ingrid', 'Friedrich', 'Renate',
    'Stefan', 'Sabine', 'Thomas', 'Petra', 'Andreas', 'Susanne',
    'Markus', 'Claudia', 'Lukas', 'Anna', 'Tobias', 'Lena',
    'Felix', 'Hannah', 'Leon', 'Mia', 'Jonas', 'Laura',

    // Portuguese / Brazilian
    'João', 'Ana', 'Pedro', 'Mariana', 'Paulo', 'Juliana',
    'Felipe', 'Beatriz', 'Gabriel', 'Fernanda', 'Rafael', 'Larissa',
    'Rodrigo', 'Amanda', 'Bruno', 'Camila', 'Gustavo', 'Natália',
    'Leonardo', 'Patrícia', 'Mateus', 'Gabriela', 'Thiago', 'Carolina',

    // Italian
    'Marco', 'Giulia', 'Luca', 'Martina', 'Alessandro', 'Sara',
    'Francesco', 'Laura', 'Andrea', 'Sofia', 'Matteo', 'Chiara',
    'Davide', 'Alice', 'Lorenzo', 'Elena', 'Simone', 'Federica',
    'Roberto', 'Valentina', 'Stefano', 'Elisa', 'Riccardo', 'Silvia',

    // Arabic / Middle Eastern
    'Mohammed', 'Fatima', 'Ahmed', 'Aisha', 'Ali', 'Maryam',
    'Omar', 'Nour', 'Ibrahim', 'Layla', 'Hassan', 'Yasmin',
    'Youssef', 'Hana', 'Khalid', 'Rania', 'Tariq', 'Salma',
    'Bilal', 'Dina', 'Kareem', 'Iman', 'Ziad', 'Nadia',
    'Samir', 'Lina', 'Malik', 'Amira', 'Faisal', 'Noura',

    // Chinese / East Asian
    'Wei', 'Xia', 'Ming', 'Ying', 'Jian', 'Mei',
    'Hao', 'Li', 'Feng', 'Yan', 'Tao', 'Xue',
    'Jun', 'Hua', 'Chao', 'Ping', 'Lei', 'Yun',
    'Rui', 'Qian', 'Zheng', 'Lan', 'Bo', 'Fang',

    // Japanese
    'Hiroshi', 'Yuki', 'Kenji', 'Sakura', 'Takashi', 'Aiko',
    'Ryota', 'Haruka', 'Shota', 'Nana', 'Daiki', 'Yui',
    'Kazuki', 'Miyu', 'Sho', 'Riko', 'Naoki', 'Hana',
    'Yuto', 'Rin', 'Kento', 'Moe', 'Ren', 'Saki',

    // African — West Africa (Nigeria, Côte d'Ivoire, Sénégal, Ghana)
    'Kwame', 'Abena', 'Kofi', 'Ama', 'Kweku', 'Akosua',
    'Emeka', 'Ngozi', 'Chukwu', 'Adaeze', 'Tunde', 'Funmilayo',
    'Segun', 'Bisi', 'Femi', 'Yetunde', 'Oluwaseun', 'Chioma',
    'Moussa', 'Kadiatou', 'Ibrahima', 'Fatoumata', 'Mamadou', 'Aminata',
    'Kouassi', 'Adjoua', 'Koffi', 'Ahou', 'Yao', 'Aya',
    'Seydou', 'Mariam', 'Cheikh', 'Rokhaya', 'Ousmane', 'Binta',

    // African — East & Southern Africa (Kenya, Ethiopia, South Africa, Zimbabwe)
    'Jabari', 'Amara', 'Chidi', 'Zuri', 'Tau', 'Imani',
    'Tendai', 'Rudo', 'Tatenda', 'Chipo', 'Takudzwa', 'Tsitsi',
    'Abebe', 'Tigist', 'Dawit', 'Selam', 'Yonas', 'Hiwot',
    'Sipho', 'Lindiwe', 'Thabo', 'Nomsa', 'Bongani', 'Zanele',
    'Kamau', 'Wanjiru', 'Mwangi', 'Njeri', 'Kipchoge', 'Akinyi',

    // South Asian (India, Pakistan, Bangladesh)
    'Arjun', 'Priya', 'Rahul', 'Ananya', 'Vikram', 'Divya',
    'Aditya', 'Kavya', 'Rohan', 'Shreya', 'Kiran', 'Pooja',
    'Suresh', 'Rekha', 'Ravi', 'Meera', 'Amit', 'Sunita',
    'Imran', 'Sana', 'Zain', 'Ayesha', 'Hamid', 'Rabia',
    'Farhan', 'Nadia', 'Asif', 'Hira', 'Tariq', 'Zara',

    // Southeast Asian (Vietnam, Thailand, Indonesia, Philippines)
    'Minh', 'Linh', 'Duc', 'Huong', 'Khang', 'Trang',
    'Somchai', 'Malee', 'Krit', 'Nong', 'Panya', 'Araya',
    'Budi', 'Sari', 'Rizky', 'Dewi', 'Andi', 'Fitri',
    'Jose', 'Maria', 'Angelo', 'Angelica', 'Renz', 'Pia',

    // Russian / Eastern European
    'Dmitri', 'Natasha', 'Alexei', 'Olga', 'Ivan', 'Tatiana',
    'Sergei', 'Elena', 'Vladimir', 'Irina', 'Andrei', 'Anastasia',
    'Nikolai', 'Svetlana', 'Mikhail', 'Yulia', 'Pavel', 'Oksana',
    'Artem', 'Daria', 'Evgeny', 'Yelena', 'Ilya', 'Polina',

    // Turkish / Central Asian
    'Mehmet', 'Ayşe', 'Mustafa', 'Fatma', 'Ahmet', 'Zeynep',
    'Ali', 'Elif', 'Hüseyin', 'Emine', 'Murat', 'Hatice',
    'Ömer', 'Büşra', 'Yusuf', 'Merve', 'İbrahim', 'Selin',
  ];

// ── LAST NAMES ────────────────────────────────────────────────
  final List<String> _lastNames = [
    // English / American
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia',
    'Miller', 'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez',
    'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore',
    'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White',
    'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson',
    'Walker', 'Young', 'Allen', 'King', 'Wright', 'Scott',
    'Torres', 'Nguyen', 'Hill', 'Flores', 'Green', 'Adams',
    'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell',
    'Carter', 'Roberts', 'Phillips', 'Evans', 'Turner', 'Parker',

    // French
    'Martin', 'Bernard', 'Thomas', 'Petit', 'Robert', 'Richard',
    'Durand', 'Dubois', 'Moreau', 'Laurent', 'Simon', 'Michel',
    'Lefebvre', 'Leroy', 'Roux', 'David', 'Bertrand', 'Morel',
    'Fournier', 'Girard', 'Bonnet', 'Dupont', 'Lambert', 'Fontaine',
    'Rousseau', 'Vincent', 'Muller', 'Lefevre', 'Faure', 'Andre',

    // Spanish / Latin American
    'García', 'Martínez', 'López', 'González', 'Rodríguez', 'Fernández',
    'Sánchez', 'Pérez', 'Gómez', 'Martín', 'Jiménez', 'Ruiz',
    'Hernández', 'Díaz', 'Moreno', 'Álvarez', 'Romero', 'Alonso',
    'Gutiérrez', 'Navarro', 'Torres', 'Domínguez', 'Vásquez', 'Ramos',
    'Gil', 'Ramírez', 'Cruz', 'Flores', 'Molina', 'Ortega',

    // German
    'Müller', 'Schmidt', 'Schneider', 'Fischer', 'Weber', 'Meyer',
    'Wagner', 'Becker', 'Schulz', 'Hoffmann', 'Schäfer', 'Koch',
    'Bauer', 'Richter', 'Klein', 'Wolf', 'Schröder', 'Neumann',
    'Schwarz', 'Zimmermann', 'Braun', 'Krüger', 'Hofmann', 'Hartmann',
    'Lange', 'Schmitt', 'Werner', 'Krause', 'Meier', 'Lehmann',

    // Portuguese / Brazilian
    'Silva', 'Santos', 'Oliveira', 'Souza', 'Rodrigues', 'Ferreira',
    'Alves', 'Pereira', 'Lima', 'Gomes', 'Ribeiro', 'Carvalho',
    'Almeida', 'Lopes', 'Sousa', 'Fernandes', 'Vasconcellos', 'Pinto',
    'Teixeira', 'Magalhães', 'Barbosa', 'Moreira', 'Cunha', 'Cavalcanti',

    // Italian
    'Rossi', 'Russo', 'Ferrari', 'Esposito', 'Bianchi', 'Romano',
    'Colombo', 'Ricci', 'Marino', 'Greco', 'Bruno', 'Gallo',
    'Conti', 'De Luca', 'Mancini', 'Costa', 'Giordano', 'Rizzo',
    'Lombardi', 'Moretti', 'Barbieri', 'Fontana', 'Santoro', 'Marini',

    // Arabic
    'Al-Amin', 'Hassan', 'Hussein', 'Ibrahim', 'Khalil', 'Mansour',
    'Nasser', 'Omar', 'Qureshi', 'Rahman', 'Siddiqui', 'Youssef',
    'Zaman', 'Aziz', 'Badr', 'Darwish', 'Fadel', 'Ghali',
    'Al-Rashid', 'Al-Farsi', 'Hamdan', 'Idris', 'Jabir', 'Karimi',

    // Chinese
    'Wang', 'Li', 'Zhang', 'Liu', 'Chen', 'Yang',
    'Huang', 'Zhao', 'Wu', 'Zhou', 'Sun', 'Ma',
    'Zhu', 'Hu', 'Guo', 'He', 'Lin', 'Gao',
    'Luo', 'Zheng', 'Liang', 'Xie', 'Tang', 'Xu',
    'Han', 'Feng', 'Deng', 'Cao', 'Peng', 'Song',

    // Japanese
    'Sato', 'Suzuki', 'Takahashi', 'Tanaka', 'Watanabe', 'Ito',
    'Yamamoto', 'Nakamura', 'Kobayashi', 'Kato', 'Yoshida', 'Yamada',
    'Sasaki', 'Yamaguchi', 'Matsumoto', 'Inoue', 'Kimura', 'Hayashi',
    'Shimizu', 'Yamazaki', 'Mori', 'Abe', 'Ikeda', 'Hashimoto',

    // African — West Africa
    'Diallo', 'Konaté', 'Traoré', 'Coulibaly', 'Keïta', 'Diarra',
    'Touré', 'Camara', 'Bah', 'Sylla', 'Sow', 'Barry',
    'Okafor', 'Adeyemi', 'Okonkwo', 'Nwosu', 'Eze', 'Obi',
    'Mensah', 'Asante', 'Boateng', 'Owusu', 'Acheampong', 'Amoah',
    'Kouassi', 'Konan', 'Koffi', 'Yao', 'Brou', 'Diabaté',
    'Kouyaté', 'Dramé', 'Baldé', 'Cissé', 'Ndiaye', 'Fall',
    'Mbaye', 'Diop', 'Sène', 'Gueye', 'Sarr', 'Thiaw',

    // African — East & Southern Africa
    'Odhiambo', 'Otieno', 'Waweru', 'Kariuki', 'Muthoni', 'Kamau',
    'Bekele', 'Tadesse', 'Haile', 'Girma', 'Tesfaye', 'Alemu',
    'Dlamini', 'Nkosi', 'Mokoena', 'Molefe', 'Khumalo', 'Ndlovu',
    'Mutasa', 'Chigumba', 'Moyo', 'Ncube', 'Sibanda', 'Dube',

    // South Asian
    'Patel', 'Sharma', 'Singh', 'Kumar', 'Gupta', 'Joshi',
    'Verma', 'Mishra', 'Yadav', 'Tiwari', 'Chaudhary', 'Rao',
    'Iyer', 'Nair', 'Pillai', 'Menon', 'Reddy', 'Naidu',
    'Khan', 'Malik', 'Sheikh', 'Chaudhry', 'Mirza', 'Qureshi',
    'Hussain', 'Akhtar', 'Ansari', 'Siddiqui', 'Rizvi', 'Butt',

    // Southeast Asian
    'Nguyen', 'Tran', 'Le', 'Pham', 'Hoang', 'Phan',
    'Tanaka', 'Wongkalasin', 'Phothirat', 'Srisuk', 'Jaidee', 'Boonma',
    'Santoso', 'Wijaya', 'Setiawan', 'Putri', 'Susanto', 'Hidayat',
    'Santos', 'Reyes', 'Cruz', 'Bautista', 'Ocampo', 'Dela Cruz',

    // Russian / Eastern European
    'Ivanov', 'Smirnov', 'Kuznetsov', 'Popov', 'Vasiliev', 'Petrov',
    'Sokolov', 'Mikhailov', 'Novikov', 'Fedorov', 'Morozov', 'Volkov',
    'Alekseev', 'Lebedev', 'Semyonov', 'Egorov', 'Pavlov', 'Kozlov',
    'Stepanov', 'Nikolaev', 'Orlov', 'Makarov', 'Nikitin', 'Zakharov',

    // Turkish
    'Yılmaz', 'Kaya', 'Demir', 'Çelik', 'Şahin', 'Yıldız',
    'Yıldırım', 'Öztürk', 'Aydın', 'Özdemir', 'Arslan', 'Doğan',
    'Kılıç', 'Aslan', 'Çetin', 'Koç', 'Kurt', 'Özcan',
  ];

// ── EMAIL DOMAINS ─────────────────────────────────────────────
  final List<String> _domains = [
    // Global webmail
    'gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com',
    'icloud.com', 'protonmail.com', 'mail.com', 'zoho.com',
    'aol.com', 'yandex.com', 'tutanota.com', 'fastmail.com',

    // Privacy-focused
    'proton.me', 'pm.me', 'tutamail.com', 'guerrillamail.com',
    'dispostable.com', 'mailbox.org', 'cock.li', 'riseup.net',

    // Regional — Europe
    'orange.fr', 'free.fr', 'sfr.fr', 'wanadoo.fr',
    't-online.de', 'web.de', 'gmx.de', 'gmx.net',
    'libero.it', 'virgilio.it', 'tin.it',
    'terra.es', 'telefonica.es',

    // Regional — Asia
    'qq.com', '163.com', '126.com', 'sina.com', 'sohu.com',
    'naver.com', 'daum.net', 'kakao.com',
    'yahoo.co.jp', 'docomo.ne.jp',

    // Regional — Africa & Middle East
    'yahoo.fr', 'africamail.com', 'gmail.com',
    'hotmail.fr',

    // Corporate / generic
    'company.com', 'corp.net', 'business.org',
    'enterprise.io', 'solutions.co', 'tech.dev',
    'consulting.net', 'agency.com', 'studio.io',
  ];

// ── COMPANIES ─────────────────────────────────────────────────
  final List<String> _companies = [
    // Tech generic
    'TechCorp', 'InnovateCo', 'DataSys', 'CloudNet', 'SoftWorks',
    'DevStudio', 'CodeLab', 'WebTech', 'AppMakers', 'DigitalHub',
    'CyberSpace', 'InfoTech', 'SmartSolutions', 'GlobalTech',
    'FutureSystems', 'NextGen', 'PrimeData', 'CoreLogic',

    // Startup / modern naming
    'Axion Labs', 'Pulsar AI', 'Neon Stack', 'Void Systems',
    'Qubit.io', 'Helios Dev', 'Zenith Cloud', 'Apex Secure',
    'Fractal Data', 'Orbit Analytics', 'Synapse Tech', 'Flux Networks',
    'Vertex Solutions', 'Cipher Works', 'Prism Software',
    'Echo Systems', 'Atlas Computing', 'Nova Dynamics',

    // Consulting / services
    'Accentech', 'BrightConsult', 'Strategic IT', 'Vision Partners',
    'Prime Consulting', 'Alpha Services', 'Delta Group',
    'Sigma Consulting', 'Omega Solutions', 'Pinnacle Group',
    'Horizon Advisory', 'Summit Partners', 'Bridge Technologies',

    // Finance / Banking
    'Capital Tech', 'FinSecure', 'WealthSys', 'TrustBank Digital',
    'PayNova', 'CryptoVault', 'LedgerPro', 'Finaxis',

    // Health / Pharma
    'MedTech Solutions', 'HealthBridge', 'CuraTech', 'BioSys',
    'PharmaCare IT', 'MedInform', 'CliniqData',

    // Telecom
    'NetWave', 'ConnectPro', 'SignalTech', 'SpeedLine ISP',
    'TeleMatrix', 'LinkSys Global',

    // Logistics
    'LogiCore', 'SwiftShip Tech', 'CargoSmart', 'TrackNet',

    // Education
    'EduTech Global', 'LearnSphere', 'AcademyPro', 'SkillForge',

    // Media / Creative
    'PixelForge', 'StudioWave', 'CreativeMind', 'MediaPulse',
    'ContentLab', 'BrandCore', 'DesignAxis',

    // Security / Cybersec
    'SecureShield', 'IronWall Security', 'ThreatGuard',
    'CipherNet', 'SafeHarbor IT', 'ZeroTrust Labs',
    'Aegis Cyber', 'Fortify Systems', 'Sentinel Group',

    // African companies
    'AfriTech Solutions', 'Sahel Digital', 'Abidjan Tech Hub',
    'Lagos Innovations', 'Nairobi Cloud', 'Cape Data Systems',
    'Dakar Ventures', 'Accra DevStudio', 'Tunis IT Group',
  ];

// ── CITIES (WORLDWIDE) ─────────────────────────────────────────
  final List<String> _cities = [
    // USA
    'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix',
    'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose',
    'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 'Charlotte',
    'Seattle', 'Denver', 'Boston', 'Portland', 'Miami',
    'Atlanta', 'Las Vegas', 'Nashville', 'Minneapolis', 'Tampa',

    // Europe
    'London', 'Paris', 'Berlin', 'Madrid', 'Rome',
    'Amsterdam', 'Brussels', 'Vienna', 'Zurich', 'Stockholm',
    'Oslo', 'Copenhagen', 'Lisbon', 'Dublin', 'Warsaw',
    'Prague', 'Budapest', 'Athens', 'Lyon', 'Marseille',
    'Hamburg', 'Munich', 'Frankfurt', 'Milan', 'Barcelona',

    // Asia
    'Tokyo', 'Beijing', 'Shanghai', 'Mumbai', 'Delhi',
    'Seoul', 'Singapore', 'Bangkok', 'Jakarta', 'Kuala Lumpur',
    'Hong Kong', 'Taipei', 'Osaka', 'Karachi', 'Dhaka',
    'Colombo', 'Kathmandu', 'Phnom Penh', 'Hanoi', 'Ho Chi Minh City',

    // Middle East
    'Dubai', 'Abu Dhabi', 'Riyadh', 'Cairo', 'Istanbul',
    'Tehran', 'Baghdad', 'Beirut', 'Amman', 'Kuwait City',
    'Doha', 'Muscat', 'Tel Aviv', 'Ankara',

    // Africa
    'Lagos', 'Nairobi', 'Johannesburg', 'Cairo', 'Casablanca',
    'Abidjan', 'Dakar', 'Accra', 'Addis Ababa', 'Dar es Salaam',
    'Kigali', 'Kampala', 'Tunis', 'Algiers', 'Rabat',
    'Douala', 'Yaoundé', 'Bamako', 'Ouagadougou', 'Conakry',
    'Abuja', 'Lomé', 'Cotonou', 'Libreville', 'Brazzaville',

    // Americas (outside USA)
    'São Paulo', 'Buenos Aires', 'Bogotá', 'Lima', 'Santiago',
    'Mexico City', 'Caracas', 'Quito', 'Montevideo', 'Asunción',
    'Rio de Janeiro', 'Medellín', 'Guadalajara', 'Havana', 'Santo Domingo',
    'Toronto', 'Montreal', 'Vancouver', 'Calgary', 'Ottawa',

    // Oceania
    'Sydney', 'Melbourne', 'Brisbane', 'Auckland', 'Perth',
    'Wellington', 'Adelaide', 'Canberra', 'Christchurch',
  ];

// ── STREET NAMES (INTERNATIONAL) ──────────────────────────────
  final List<String> _streets = [
    // English generic
    'Main St', 'Oak Ave', 'Maple Dr', 'First St', 'Second Ave',
    'Park Blvd', 'Washington St', 'Lake Rd', 'Hill Ct', 'River Dr',
    'Church Rd', 'High St', 'Railroad Ave', 'School St', 'Union St',
    'Market St', 'Spring St', 'Center St', 'Forest Ln', 'Valley Rd',
    'Sunset Blvd', 'Elm St', 'Cedar Ave', 'Pine St', 'Willow Way',
    'Orchard Rd', 'Birch Ln', 'Meadow Dr', 'Hillside Ave', 'Harbor Blvd',

    // French
    'Rue de la Paix', 'Avenue des Champs-Élysées', 'Rue Victor Hugo',
    'Boulevard Haussmann', 'Rue du Commerce', 'Allée des Roses',
    'Rue Nationale', 'Avenue Jean Jaurès', 'Impasse des Lilas',
    'Rue de la République', 'Boulevard du Général de Gaulle',
    'Rue de la Liberté', 'Chemin des Écoliers', 'Passage du Nord',

    // Spanish
    'Calle Mayor', 'Avenida de la Constitución', 'Calle Real',
    'Paseo de la Castellana', 'Calle de Alcalá', 'Gran Vía',
    'Avenida de España', 'Calle del Sol', 'Plaza Mayor',
    'Carretera Nacional', 'Rambla de Catalunya',

    // German
    'Hauptstraße', 'Bahnhofstraße', 'Kirchgasse', 'Bergstraße',
    'Schillerstraße', 'Goethestraße', 'Friedrichstraße',
    'Wilhelmstraße', 'Gartenweg', 'Lindenallee',

    // Portuguese
    'Rua da Liberdade', 'Avenida Paulista', 'Rua das Flores',
    'Rua do Ouro', 'Largo do Rossio', 'Avenida Brasil',
    'Rua Augusta', 'Praça da República',

    // Italian
    'Via Roma', 'Corso Italia', 'Via Nazionale', 'Viale Mazzini',
    'Via Garibaldi', 'Piazza Navona', 'Via del Corso',
    'Lungotevere dei Mellini', 'Via Veneto',

    // Arabic / Middle Eastern
    'Sharia Al-Nil', 'Sharia Tahrir', 'Al-Rashid Street',
    'King Fahd Road', 'Sultan Qaboos Street', 'Corniche Road',
    'Al Wasl Road', 'Sheikh Zayed Road', 'Hamdan Street',

    // African
    'Boulevard de la République', 'Avenue Félix Houphouët-Boigny',
    'Rue du Commerce', 'Avenue de l\'Indépendance',
    'Boulevard du 20 Janvier', 'Avenue Charles de Gaulle',
    'Rue des Jardins', 'Boulevard Lumumba', 'Avenue Kenyatta',
    'Uhuru Highway', 'Nelson Mandela Drive', 'Julius Nyerere Way',
    'Kwame Nkrumah Ave', 'Patrice Lumumba Rd', 'Thomas Sankara Blvd',

    // Asian
    'Zhongshan Road', 'Nanjing Road', 'Chang An Avenue',
    'Ginza Street', 'Shibuya Crossing Rd', 'Myeongdong Street',
    'Orchard Road', 'Sukhumvit Road', 'Jalan Sudirman',
    'MG Road', 'Brigade Road', 'Connaught Place',
  ];

// ── COUNTRY CODES (for phone prefix) ─────────────────────────
  final List<Map<String, String>> _countryCodes = [
    {'country': 'United States', 'code': '+1'},
    {'country': 'United Kingdom', 'code': '+44'},
    {'country': 'France', 'code': '+33'},
    {'country': 'Germany', 'code': '+49'},
    {'country': 'Spain', 'code': '+34'},
    {'country': 'Italy', 'code': '+39'},
    {'country': 'Portugal', 'code': '+351'},
    {'country': 'Brazil', 'code': '+55'},
    {'country': 'Canada', 'code': '+1'},
    {'country': 'Australia', 'code': '+61'},
    {'country': 'Japan', 'code': '+81'},
    {'country': 'China', 'code': '+86'},
    {'country': 'India', 'code': '+91'},
    {'country': 'South Korea', 'code': '+82'},
    {'country': 'Russia', 'code': '+7'},
    {'country': 'Turkey', 'code': '+90'},
    {'country': 'Saudi Arabia', 'code': '+966'},
    {'country': 'UAE', 'code': '+971'},
    {'country': 'Egypt', 'code': '+20'},
    {'country': 'Nigeria', 'code': '+234'},
    {'country': 'Côte d\'Ivoire', 'code': '+225'},
    {'country': 'Senegal', 'code': '+221'},
    {'country': 'Ghana', 'code': '+233'},
    {'country': 'Kenya', 'code': '+254'},
    {'country': 'South Africa', 'code': '+27'},
    {'country': 'Ethiopia', 'code': '+251'},
    {'country': 'Morocco', 'code': '+212'},
    {'country': 'Algeria', 'code': '+213'},
    {'country': 'Tunisia', 'code': '+216'},
    {'country': 'Cameroon', 'code': '+237'},
    {'country': 'Pakistan', 'code': '+92'},
    {'country': 'Bangladesh', 'code': '+880'},
    {'country': 'Indonesia', 'code': '+62'},
    {'country': 'Vietnam', 'code': '+84'},
    {'country': 'Thailand', 'code': '+66'},
    {'country': 'Philippines', 'code': '+63'},
    {'country': 'Mexico', 'code': '+52'},
    {'country': 'Argentina', 'code': '+54'},
    {'country': 'Colombia', 'code': '+57'},
    {'country': 'Netherlands', 'code': '+31'},
    {'country': 'Belgium', 'code': '+32'},
    {'country': 'Switzerland', 'code': '+41'},
    {'country': 'Sweden', 'code': '+46'},
    {'country': 'Poland', 'code': '+48'},
  ];

// ── JOB TITLES ────────────────────────────────────────────────
  final List<String> _jobTitles = [
    // Tech
    'Software Engineer', 'Senior Developer', 'Full Stack Developer',
    'Backend Engineer', 'Frontend Developer', 'Mobile Developer',
    'DevOps Engineer', 'Cloud Architect', 'Data Scientist',
    'Machine Learning Engineer', 'AI Researcher', 'Platform Engineer',
    'Site Reliability Engineer', 'Database Administrator', 'QA Engineer',
    'Security Engineer', 'Penetration Tester', 'CTF Analyst',
    'Malware Analyst', 'SOC Analyst', 'Network Engineer',

    // Management
    'CTO', 'CEO', 'CIO', 'CISO', 'VP Engineering',
    'Engineering Manager', 'Product Manager', 'Project Manager',
    'Scrum Master', 'Technical Lead', 'Team Lead',

    // Design & Product
    'UX Designer', 'UI Designer', 'Product Designer',
    'Graphic Designer', 'Creative Director',

    // Finance
    'Financial Analyst', 'Accountant', 'CFO', 'Auditor',
    'Investment Manager', 'Risk Analyst',

    // Other
    'Marketing Manager', 'Sales Director', 'HR Manager',
    'Legal Counsel', 'Operations Manager', 'Consultant',
    'Business Analyst', 'Research Scientist', 'Professor',
    'Journalist', 'Photographer', 'Architect', 'Doctor',
  ];

// ── USERNAMES PATTERNS (for generation) ───────────────────────
  final List<String> _usernamePrefixes = [
    'dark',
    'cyber',
    'ghost',
    'shadow',
    'zero',
    'null',
    'void',
    'byte',
    'hex',
    'root',
    'anon',
    'neo',
    'matrix',
    'blade',
    'crypto',
    'stealth',
    'phantom',
    'rogue',
    'wild',
    'ultra',
    'alpha',
    'omega',
    'delta',
    'sigma',
    'prime',
    'core',
    'hyper',
  ];

  final List<String> _usernameSuffixes = [
    'hacker',
    'coder',
    'dev',
    'sec',
    'net',
    'sys',
    'pro',
    'elite',
    'master',
    'lord',
    'king',
    'boss',
    'king',
    'ace',
    '404',
    '0x1',
    '_null',
    '_void',
    'xd',
    'gg',
    'pwn',
  ];

  String _generateEmail(String firstName, String lastName) {
    final patterns = [
      '${firstName.toLowerCase()}.${lastName.toLowerCase()}',
      '${firstName[0].toLowerCase()}${lastName.toLowerCase()}',
      '${firstName.toLowerCase()}${_random.nextInt(99)}',
      '${lastName.toLowerCase()}${_random.nextInt(999)}',
    ];
    final pattern = patterns[_random.nextInt(patterns.length)];
    final domain = _domains[_random.nextInt(_domains.length)];
    return '$pattern@$domain';
  }

  String _generatePhone() {
    return '(${_randomNumber(100, 999)}) ${_randomNumber(100, 999)}-${_randomNumber(1000, 9999)}';
  }

  String _generateAddress() {
    final number = _randomNumber(1, 9999);
    final street = _streets[_random.nextInt(_streets.length)];
    final city = _cities[_random.nextInt(_cities.length)];
    final state = _randomState();
    final zip = _randomNumber(10000, 99999);
    return '$number $street, $city, $state $zip';
  }

  String _randomState() {
    final states = ['CA', 'TX', 'FL', 'NY', 'PA', 'IL', 'OH', 'GA', 'NC', 'MI'];
    return states[_random.nextInt(states.length)];
  }

  int _randomNumber(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  String _generateUsername(String firstName, String lastName) {
    final patterns = [
      '${firstName.toLowerCase()}${lastName.toLowerCase()}',
      '${firstName[0].toLowerCase()}${lastName.toLowerCase()}_$_randomNumber(1, 99)',
      '${firstName.toLowerCase()}_$_randomNumber(1, 999)',
      '${lastName.toLowerCase()}${_randomNumber(1, 99)}',
    ];
    return patterns[_random.nextInt(patterns.length)];
  }

  String _generatePassword() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*';
    return List.generate(12, (_) => chars[_random.nextInt(chars.length)])
        .join();
  }

  void _generateData() {
    try {
      final buffer = StringBuffer();
      buffer.writeln('FAKE DATA GENERATOR');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Generated Records: $_count\n\n');

      for (var i = 0; i < _count; i++) {
        final firstName = _firstNames[_random.nextInt(_firstNames.length)];
        final lastName = _lastNames[_random.nextInt(_lastNames.length)];
        final email = _generateEmail(firstName, lastName);
        final phone = _generatePhone();
        final address = _generateAddress();
        final username = _generateUsername(firstName, lastName);
        final password = _generatePassword();
        final company = _companies[_random.nextInt(_companies.length)];
        final age = _randomNumber(18, 75);
        final birthday = DateTime(
          _randomNumber(1950, 2005),
          _randomNumber(1, 12),
          _randomNumber(1, 28),
        );

        buffer.writeln('RECORD #${i + 1}');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('Name: $firstName $lastName\n');
        buffer.writeln('Age: $age\n');
        buffer.writeln('Birthday: ${birthday.toString().split(' ')[0]}\n');
        buffer.writeln('Email: $email\n');
        buffer.writeln('Username: $username\n');
        buffer.writeln('Password: $password\n');
        buffer.writeln('Phone: $phone\n');
        buffer.writeln('Address: $address\n');
        buffer.writeln('Company: $company\n');
        buffer.writeln('\n');
      }

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'FAKE DATA GENERATOR',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'CONFIGURATION'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() => _count = int.tryParse(value) ?? 5);
                    },
                    controller: TextEditingController(text: '$_count'),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number of Records',
                      labelStyle: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: '1-50',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x2000FF88),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accent),
                  ),
                  child: const Text(
                    'Generates:\n• Names\n• Emails\n• Phones\n• Addresses\n• Usernames\n• Passwords',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _generateData,
                icon: const Icon(Icons.person_add),
                label: Text('GENERATE $_count RECORDS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'GENERATED DATA',
                monospace: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
