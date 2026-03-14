# Hackers -- Offline Features Documentation

**Projet :** Hackers\
**Auteur :** Archange Elie Yatte\
**Startup :** IndraLabs\
**Version :** 1.0

## Objectif

Créer une application **offline‑first** (Mobile & Desktop) destinée aux
**informaticiens et professionnels de la cybersécurité**.\
L'application regroupe une **boîte à outils complète** permettant
d'effectuer de nombreuses opérations techniques sans connexion internet.

---

# 1. Cryptographie

## Hachage

- Génération de hash MD5
- Génération de hash SHA1
- Génération de hash SHA224
- Génération de hash SHA256
- Génération de hash SHA384
- Génération de hash SHA512
- HMAC-SHA256
- HMAC-SHA512
- Bcrypt Hash
- Argon2 Hash
- Comparateur de hash
- Générateur de Salt
- **BLAKE2b Hash**
- **BLAKE2s Hash**
- **BLAKE3 Hash**
- **Whirlpool Hash**
- **RIPEMD-160 Hash**
- **Keccak-256 Hash**
- **CRC16 / CRC32 / CRC64**
- **Adler-32 Checksum**
- **Poly1305 MAC**
- **SipHash**

## Chiffrement / Déchiffrement

- AES‑128 Encryption / Decryption
- AES‑256 Encryption / Decryption
- Mode CBC
- Mode GCM
- ChaCha20‑Poly1305 Encryption
- RSA Encryption
- RSA Decryption
- Génération de clés RSA
- Génération de clés aléatoires (256 bits / 512 bits)
- Dérivation de clé PBKDF2
- Dérivation de clé HKDF
- **AES Mode ECB**
- **AES Mode CTR**
- **AES Mode CFB**
- **AES Mode OFB**
- **AES Mode XTS (chiffrement disque)**
- **Triple DES (3DES) Encryption / Decryption**
- **Blowfish Encryption / Decryption**
- **Twofish Encryption / Decryption**
- **XSalsa20 Encryption**
- **NaCl / libsodium Box Encryption**
- **NaCl / libsodium SecretBox**
- **ElGamal Encryption**
- **Dérivation de clé scrypt**
- **Dérivation de clé Balloon Hashing**
- **One-Time Pad (OTP) Generator**
- **Vigenère Cipher**
- **Caesar Cipher**
- **Substitution Cipher**
- **Playfair Cipher**
- **Rail Fence Cipher**
- **Beaufort Cipher**
- **Chiffrement affine**

## Signatures et Certificats

- Génération de clés RSA
- Génération de clés ECDSA
- Signature de message
- Vérification de signature
- Analyse certificat X.509
- Support PEM
- Support DER
- Calcul fingerprint certificat
- **Génération de clés Ed25519**
- **Génération de clés Ed448**
- **Génération de clés X25519 (ECDH)**
- **Génération de clés X448**
- **Signature EdDSA**
- **Signature DSA**
- **Support PKCS#8**
- **Support PKCS#12 / PFX**
- **Analyse CRL (Certificate Revocation List)**
- **Analyse CSR (Certificate Signing Request)**
- **Génération CSR auto-signé**
- **Calcul SPKI fingerprint**
- **Vérification chaîne de certificats**
- **Analyse OID**

---

# 2. Password Toolkit

## Générateur de mots de passe

- Génération de mot de passe sécurisé
- Longueur personnalisable (4 à 256)
- Majuscules
- Minuscules
- Chiffres
- Symboles
- Unicode
- Exclusion caractères ambigus
- **Génération par charset personnalisé**
- **Mode « no repeat » (sans répétition de caractères)**
- **Génération de batch (N mots de passe en une fois)**

## Fonctions avancées

- Générateur de mot de passe prononçable
- Génération Passphrase Diceware
- Génération PIN sécurisé
- **Générateur de passphrase EFF wordlist**
- **Générateur de passphrase personnalisée (wordlist custom)**
- **Générateur de mnémotechnique (acronyme mémorisable)**
- **Générateur de pattern (ex: CvcCvcN!)**

## Analyse de mot de passe

- Analyse d'entropie
- Score de sécurité
- Estimation du temps de brute force
- Détection de patterns faibles
- Détection dates
- Détection séquences
- Détection mots communs
- **Calcul entropie Shannon**
- **Détection de leet speak**
- **Analyse zxcvbn (estimation réaliste de la force)**
- **Comparaison avec wordlist Have I Been Pwned (offline)**
- **Visualisation de la force par jauge**
- **Estimation coût énergétique du crackage**

## Gestion locale

- Historique mots de passe
- Stockage chiffré local
- **Export chiffré (JSON / CSV)**
- **Import depuis un fichier chiffré**
- **Effacement sécurisé de l'historique**

---

# 3. Encode / Decode Toolkit

Formats supportés :

- Base64 Encode / Decode
- Base64 URL Safe
- Base32
- URL Encoding
- HTML Entities
- Hex Encoding
- ASCII
- Binary
- Octal
- ROT13
- ROT47
- Morse Code
- Unicode Escape
- Punycode (IDN)
- **Base58 Encode / Decode**
- **Base85 (Ascii85) Encode / Decode**
- **Base91 Encode / Decode**
- **Base16 Encode / Decode**
- **Z85 Encode / Decode**
- **Uuencode / Uudecode**
- **Quoted-Printable Encode / Decode**
- **MIME Encode / Decode**
- **UTF-8 / UTF-16 / UTF-32 Conversion**
- **BCD (Binary Coded Decimal)**
- **Gray Code**
- **Baudot Code**
- **Atbash Cipher**
- **XOR Encode / Decode**
- **Bitwise NOT / AND / OR / XOR sur chaîne**
- **Encodage Braille (Unicode)**
- **NATO Alphabet Converter**
- **Tap Code**
- **Pigpen Cipher**
- **Book Cipher (Polybius Square)**
- **Bacon Cipher**

---

# 4. File Security Tools

- Calcul hash fichier MD5
- Calcul hash fichier SHA1
- Calcul hash fichier SHA256
- Calcul hash fichier SHA512
- Comparateur de fichiers par hash
- Vérification checksum CRC32
- Analyse signature fichier (magic bytes)
- Détection type MIME réel
- Vérification fichier .sha256
- Vérification fichier .md5
- Génération rapport intégrité
- Export rapport
- **Calcul hash BLAKE3 fichier**
- **Calcul hash RIPEMD-160 fichier**
- **Vérification checksum CRC64**
- **Détection de fichiers polyglots**
- **Détection de fichiers steganographiés (basique)**
- **Analyse entropie byte par byte**
- **Détection de fichiers ZIP bomb**
- **Vérification signatures numériques de fichiers (GPG)**
- **Comparaison fichiers binaires (diff binaire)**
- **Analyse en-tête PE (Windows EXE)**
- **Analyse en-tête ELF (Linux)**
- **Analyse en-tête Mach-O (macOS)**
- **Extraction embedded files (fichiers imbriqués)**
- **Détection obfuscation script**

---

# 5. Network Tools

## Diagnostic réseau

- Ping
- Statistiques Ping
- Latence moyenne
- Packet loss
- **Traceping (ping + trace combinés)**
- **MTU Discovery**
- **Jitter analysis**

## Traceroute

- Analyse des sauts réseau
- **Traceroute TCP**
- **Traceroute UDP**
- **Traceroute ICMP**
- **AS Number lookup par hop**

## DNS Tools

- DNS Lookup A
- DNS Lookup AAAA
- DNS Lookup MX
- DNS Lookup TXT
- DNS Lookup CNAME
- DNS Lookup NS
- DNS Lookup SOA
- **DNS Lookup CAA**
- **DNS Lookup DKIM**
- **DNS Lookup DMARC**
- **DNS Lookup SPF**
- **DNS Lookup TLSA**
- **DNS Lookup SRV**
- **DNSSEC Validator**
- **DNS over HTTPS (DoH) Query**
- **DNS Zone Transfer Test (AXFR)**
- **Comparateur de résultats DNS (multi-serveurs)**

## Reverse DNS

- Lookup PTR
- **Bulk Reverse DNS Lookup**

## Scanner réseau

- Port Scanner
- Scan ports communs
- Scan plage personnalisée
- Détection service port
- **Banner Grabbing**
- **OS Fingerprinting (TTL analysis)**
- **Détection de services UDP**
- **SYN Scan simulé (offline analysis)**
- **Scan de vulnérabilités basiques (CVE lookup offline)**

## Calculateur réseau

- Calcul CIDR
- Adresse réseau
- Adresse broadcast
- Plage IP
- Masque réseau
- Wildcard mask
- Nombre d'hôtes
- **Calcul IPv6 CIDR**
- **Découpage VLSM automatique**
- **Tableau de sous-réseaux (multi-CIDR)**
- **Convertisseur masque CIDR ↔ notation pointée**
- **Générateur plan d'adressage**
- **Calcul supernet (résumé de routes)**

## Conversion IP

- IPv4 vers IPv6
- IPv6 vers IPv4
- **IPv4 vers Decimal**
- **IPv4 vers Hexadecimal**
- **IPv4 vers Octal**
- **IPv4 vers Binary**
- **Représentation IPv6 canonique / compressée**

## Firewall Tools

- Générateur règles iptables
- Générateur règles Windows Firewall
- **Générateur règles nftables**
- **Générateur règles pf (BSD/macOS)**
- **Générateur règles UFW**
- **Analyseur de règles iptables existantes**
- **Détecteur de règles conflictuelles**

## HTTP Tools

- Analyse headers HTTP
- **Générateur headers de sécurité (CSP, HSTS, X-Frame...)**
- **Analyseur CSP (Content Security Policy)**
- **Score de sécurité headers HTTP**
- **Simulateur requête HTTP (offline)**
- **Encodeur / Décodeur URL avancé**

## Wake-on-LAN

- Envoi Magic Packet
- **Planificateur Wake-on-LAN**
- **Historique Magic Packets**

## SSL/TLS Tools _(Nouveau)_

- **Analyseur de certificat SSL/TLS**
- **Vérification des protocoles supportés (TLS 1.0/1.1/1.2/1.3)**
- **Vérification cipher suites**
- **Détecteur de certificats auto-signés**
- **Calcul date expiration certificat**
- **Exportateur de certificats depuis une connexion**

---

# 6. WiFi Tools

- Scanner réseaux WiFi
- Analyse signal RSSI
- Analyse puissance dBm
- Détection canal WiFi
- Détection sécurité WiFi
- Calcul canal optimal
- Générateur QR Code WiFi
- Historique réseaux WiFi
- **Calcul rapport signal/bruit (SNR)**
- **Détection interférences de canaux**
- **Analyse bande 2.4 GHz vs 5 GHz vs 6 GHz**
- **Carte des réseaux WiFi (heatmap locale)**
- **Exportateur de profils WiFi**
- **Analyseur de trames Beacon (basique)**
- **Détection de réseaux cachés (SSID masqué)**
- **Détection WPS activé**
- **Générateur de configuration WPA3**
- **Calculateur de portée WiFi (modèle friis)**

---

# 7. Developer Tools

## JSON Tools

- JSON Formatter
- JSON Validator
- JSON Beautifier
- JSON Minifier
- **JSON Schema Generator**
- **JSON Schema Validator**
- **JSON Path Query (JSONPath)**
- **JSON Sorter (tri des clés)**
- **JSON Diff**
- **JSON Merger**
- **JSON Flattener / Unflattener**

## Conversion de données

- JSON vers YAML
- JSON vers XML
- JSON vers CSV
- YAML vers JSON
- XML vers JSON
- **JSON vers TOML**
- **TOML vers JSON**
- **JSON vers INI**
- **CSV vers JSON**
- **CSV vers XML**
- **XML vers YAML**
- **Markdown vers HTML**
- **HTML vers Markdown**
- **YAML vers TOML**
- **Properties vers JSON**

## JWT Tools

- JWT Decoder
- JWT Inspector
- Analyse Header
- Analyse Payload
- Analyse Signature
- **JWT Generator (HS256 / HS512 / RS256)**
- **JWT Validator**
- **Détection JWT expiré**
- **Analyse claims JWT**
- **Support JWK (JSON Web Key)**
- **Support JWE (JSON Web Encryption)**

## Regex Tools

- Regex Tester
- Highlight des correspondances
- **Regex Builder (constructeur guidé)**
- **Regex Explainer (explication en langage naturel)**
- **Regex Flags Manager**
- **Bibliothèque de regex courantes (email, IP, URL...)**
- **Extraction groupes nommés**
- **Test multi-lignes**

## Diff Tool

- Comparaison texte
- Mode unified
- Mode side‑by‑side
- **Diff JSON (sémantique)**
- **Diff binaire**
- **Patch Generator**
- **Patch Applier**

## CRON Tools

- CRON Builder
- CRON Explainer
- **CRON Simulator (prochaines N exécutions)**
- **Support CRON étendu (secondes)**
- **Convertisseur crontab → systemd timer**

## Color Tools

- Color Picker
- Conversion HEX
- Conversion RGB
- Conversion HSL
- Conversion HSV
- Conversion CMYK
- **Génération de palette de couleurs**
- **Contrast Checker WCAG**
- **Color Blind Simulator**
- **Gradient Generator**
- **Named Colors Reference**

## Time Tools

- Timestamp Converter
- Unix vers Date
- Date vers Unix
- **World Clock (offline)**
- **Calculateur de durée entre deux dates**
- **Convertisseur de fuseaux horaires**
- **Calculateur de décalage UTC**
- **Format de date ISO 8601 / RFC 2822**
- **Calendrier Unix Epoch**

## Markdown Tools

- Markdown Previewer
- **Markdown Editor temps réel**
- **Export Markdown vers HTML**
- **Support GFM (GitHub Flavored Markdown)**
- **Table Generator Markdown**

## SQL Tools

- SQL Formatter
- SQL Syntax Highlight
- **SQL Beautifier**
- **SQL Minifier**
- **SQL Query Analyzer (estimation de complexité)**
- **Générateur de requêtes SELECT / INSERT / UPDATE**
- **ERD simple (Entity Relation basique)**

## HTTP Tools

- Référence HTTP Status Codes
- **Référence HTTP Methods**
- **Référence HTTP Headers**
- **Simulateur de codes de statut**

## Autres outils développeur _(Nouveau)_

- **Générateur Lorem Ipsum**
- **Générateur de données fictives (nom, email, adresse...)**
- **Calculateur de complexité algorithmique (Big O)**
- **Convertisseur de types de données (int, float, hex...)**
- **Encodeur / Décodeur HTML**
- **Beautifier HTML**
- **Minifier CSS**
- **Beautifier CSS**
- **Beautifier JavaScript**
- **Minifier JavaScript**
- **Linter YAML**
- **Linter TOML**
- **Analyseur de headers Email (MIME)**
- **Générateur .gitignore**
- **Générateur de Makefile basique**

---

# 8. Encoding Utilities

- Générateur UUID v1
- Générateur UUID v3
- Générateur UUID v4
- Générateur UUID v5
- Générateur UUID v7
- **Générateur ULID**
- **Générateur NanoID**
- **Générateur KSUID**
- **Générateur CUID2**
- **Générateur Snowflake ID**
- **Décodeur UUID (extraction timestamp, version...)**

## Génération de tokens

- Token API
- Token Base62
- Token Base64URL
- Token Hex
- **Token alphanumérique personnalisé**
- **Token JWT signé**
- **Token Bearer simulé**

## Génération de clés

- Clé API personnalisée
- Secret OAuth
- Secret HMAC
- **Génération paire de clés SSH (RSA / Ed25519 / ECDSA)**
- **Génération clé GPG (offline)**
- **Clé de chiffrement symétrique**

## Random sécurisé

- Générateur CSPRNG
- **Dé cryptographique (nombre dans une plage)**
- **Générateur de bytes aléatoires sécurisés**
- **Shuffle sécurisé d'une liste**
- **Sélection aléatoire sécurisée**

## OTP Tools

- Génération seed OTP
- Génération seed TOTP
- **Génération code TOTP en temps réel**
- **Générateur HOTP**
- **Support TOTP multi-comptes (offline)**
- **QR Code TOTP (otpauth://)**
- **Vérificateur de code OTP**

## Conversion de clés

- PEM vers DER
- PEM vers JWK
- DER vers JWK
- **JWK vers PEM**
- **DER vers PEM**
- **SSH Public Key vers PEM**
- **PEM vers SSH Public Key**
- **Inspection clé (taille, type, algorithme)**

---

# 9. Forensics Tools

- Lecture métadonnées fichier
- Taille fichier
- Dates création/modification
- Permissions fichier

## EXIF Tools

- Extraction EXIF images
- Coordonnées GPS
- Appareil photo
- Date prise photo
- **Extraction EXIF vidéo**
- **Extraction EXIF audio (ID3)**
- **Visualisation GPS sur carte offline (GeoJSON)**
- **Comparateur EXIF (deux fichiers)**

## Privacy

- Suppression métadonnées EXIF
- **Suppression métadonnées PDF**
- **Suppression métadonnées DOCX**
- **Anonymisation de données personnelles dans un fichier**
- **Détecteur PII (Personally Identifiable Information)**

## Binary Tools

- Extraction strings fichier binaire
- **Recherche pattern binaire (hex / ascii)**
- **Désassembleur basique x86/x64 (offline)**
- **Analyseur ELF basique**
- **Analyseur PE basique**

## Hex Tools

- Hex Dump Viewer
- **Hex Editor (édition basique)**
- **Recherche / Remplacement en hex**
- **Convertisseur bytes ↔ structures (endianness)**
- **Visualisation structure binaire**

## Stéganographie

- Détection LSB basique
- **Extraction message LSB (images)**
- **Injection message LSB (images)**
- **Stéganalyse basique (chi-square)**
- **Détection dans fichiers audio**

## Entropy Analysis

- Analyse entropie fichier
- Visualisation graphique
- **Visualisation entropie par blocs**
- **Détection de zones chiffrées/compressées**
- **Comparaison entropie de sections**

## Timeline & Log Analysis _(Nouveau)_

- **Analyseur de logs système (syslog, Windows Event)**
- **Constructeur de timeline d'événements**
- **Détecteur d'anomalies dans les logs**
- **Parseur Apache / Nginx access log**
- **Parseur SSH auth.log**

---

# 10. System Tools

## Informations système

- OS
- CPU
- RAM
- Stockage
- **Informations GPU**
- **Version du kernel**
- **Uptime système**
- **Heure système et fuseau horaire**
- **Informations BIOS / UEFI**

## Informations réseau

- Interfaces réseau
- IP locale
- IPv6
- Adresse MAC
- **Table de routage**
- **Table ARP**
- **Connexions réseau actives (netstat)**
- **DNS configurés sur l'appareil**
- **Proxy détecté**

## Informations appareil

- Modèle appareil
- Résolution écran
- Densité pixel
- **Capacité batterie**
- **Température CPU (si disponible)**
- **Informations stockage (partitions montées)**

## Monitoring

- Utilisation CPU
- Utilisation RAM
- **Graphe en temps réel CPU**
- **Graphe en temps réel RAM**
- **Utilisation disque (I/O)**
- **Processus actifs (top offline)**
- **Alertes seuil configurable**

## Variables système

- Lecture variables d'environnement
- **Recherche dans les variables d'environnement**
- **Export variables en JSON / .env**

## Sécurité système _(Nouveau)_

- **Vérification des permissions de fichiers sensibles**
- **Détection de SUID / SGID suspects**
- **Liste des ports ouverts**
- **Analyse des services actifs**
- **Détection de rootkits connus (signatures offline)**
- **Vérification intégrité des binaires système (hash)**
- **Audit de configuration SSH**
- **Audit de configuration sudo**

## Rapport système

- Génération rapport
- Export rapport
- **Export en PDF**
- **Export en JSON**
- **Rapport de sécurité système**

---

# 11. OSINT Tools

## Username Tools

- Liste plateformes recherche username
- **Générateur de variantes de username**
- **Analyse de pattern de username**

## Google Dorks

- Générateur Google Dorks
- **Bibliothèque de dorks classés par catégorie**
- **Dorks spécifiques CMS (WordPress, Joomla...)**
- **Dorks pour fichiers sensibles**
- **Dorks pour caméras / IoT**

## Extractors

- Extracteur emails
- Extracteur IP
- Extracteur domaines
- **Extracteur URLs**
- **Extracteur numéros de téléphone**
- **Extracteur clés API / tokens (regex)**
- **Extracteur coordonnées GPS**
- **Extracteur hashes**
- **Extracteur noms de fichiers**

## Phone Tools

- Analyse numéro téléphone
- Formatage numéro
- Parsing international
- **Identification opérateur (offline)**
- **Identification pays et région**
- **Génération de numéros valides pour tests**

## Wordlist Tools

- Générateur wordlist personnalisé
- **Générateur wordlist par mutation (leet, majuscules...)**
- **Combinateur de wordlists**
- **Déduplication de wordlist**
- **Tri et filtrage par longueur**
- **Convertisseur de formats (txt, json, csv)**
- **Statistiques sur wordlist**

## Domain Tools _(Nouveau)_

- **Analyseur de sous-domaines (subdomain permutation)**
- **Générateur de typosquatting (domaines similaires)**
- **Détecteur de domaines homographiques**
- **Analyseur de headers email (SPF, DKIM, DMARC)**
- **Extracteur de domaines depuis une liste d'URLs**

## Metadata OSINT _(Nouveau)_

- **Extraction métadonnées de documents Office**
- **Extraction auteurs cachés dans fichiers**
- **Timeline reconstruction depuis métadonnées**

---

# 12. Steganography Studio _(Nouveau)_

- **Encodage texte dans image (LSB)**
- **Décodage texte depuis image (LSB)**
- **Encodage avec mot de passe (LSB + AES)**
- **Encodage dans canaux R/G/B/A séparément**
- **Encodage dans fichiers audio (LSB)**
- **Décodage depuis fichiers audio**
- **Encodage dans fichiers PDF (metadata)**
- **Détection basique de messages cachés**
- **Visualisation des plans de bits (bit planes)**
- **Analyse spectrale basique (stéganalyse)**
- **Encodage par manipulation DCT (JPEG)**
- **Watermarking invisible basique**

---

# 13. Code Analysis Tools _(Nouveau)_

## Analyse statique

- **Détecteur de secrets dans le code (API keys, passwords)**
- **Détecteur de patterns dangereux (SQL injection, XSS...)**
- **Analyseur de dépendances (package.json, requirements.txt)**
- **Détecteur de CVE dans dépendances (offline DB)**
- **Analyseur de complexité cyclomatique**
- **Analyseur de duplication de code**

## Obfuscation / Déobfuscation

- **Déobfuscateur JavaScript basique**
- **Déobfuscateur Base64 en cascade**
- **Analyseur de shellcode (hex → instructions)**
- **Détecteur d'obfuscation (entropie + patterns)**

## Génération de code

- **Générateur de Dockerfile basique**
- **Générateur de CI/CD pipeline (GitHub Actions)**
- **Générateur de configuration Nginx / Apache**
- **Générateur de script de sauvegarde**
- **Générateur de clés SSH config (~/.ssh/config)**

---

# 14. QR Code & Barcode Tools _(Nouveau)_

- **Générateur QR Code (texte, URL, email, vCard...)**
- **Lecteur / Décodeur QR Code (offline)**
- **Générateur Code128**
- **Générateur EAN-13 / EAN-8**
- **Générateur Code39**
- **Générateur Data Matrix**
- **Générateur Aztec Code**
- **Générateur PDF417**
- **Personnalisation couleur / logo QR Code**
- **Export QR Code en SVG / PNG**
- **Batch QR Code Generator**
- **Analyse de contenu QR (détection de phishing)**

---

# 15. Privacy & Anti-Tracking Tools _(Nouveau)_

## Anonymisation

- **Générateur d'identité fictive (offline)**
- **Générateur d'adresse email temporaire (locale)**
- **Générateur de numéro de carte fictif (Luhn valide)**
- **Masqueur / Tokeniseur de données PII**

## Analyse de vie privée

- **Analyseur de permissions d'application**
- **Détecteur de trackers dans une URL**
- **Nettoyeur de paramètres de tracking dans les URLs**
- **Analyseur de politique de confidentialité (checklist)**
- **Score de risque de vie privée**

## Outils anti-fingerprinting

- **Analyseur de fingerprint navigateur (offline)**
- **Référence de techniques de fingerprinting**
- **Générateur de User-Agent aléatoire**

---

# Résumé

L'application **Hackers v1.0** inclut **plus de 350 fonctionnalités offline** réparties dans les catégories suivantes :

| #   | Catégorie               | Fonctionnalités                                |
| --- | ----------------------- | ---------------------------------------------- |
| 1   | Cryptographie           | Hachage, Chiffrement, Signatures & Certificats |
| 2   | Password Toolkit        | Génération, Analyse, Gestion locale            |
| 3   | Encode / Decode         | 30+ formats                                    |
| 4   | File Security           | Hash, Intégrité, Analyse binaire               |
| 5   | Network Tools           | DNS, Scanner, CIDR, Firewall, SSL/TLS          |
| 6   | WiFi Tools              | Scanner, Analyse, Configuration                |
| 7   | Developer Tools         | JSON, JWT, Regex, SQL, Color, Time...          |
| 8   | Encoding Utilities      | UUID, OTP, Tokens, Clés                        |
| 9   | Forensics Tools         | EXIF, Stéganographie, Entropie, Timeline       |
| 10  | System Tools            | Infos, Monitoring, Audit sécurité              |
| 11  | OSINT Tools             | Username, Dorks, Extractors, Domain            |
| 12  | Steganography Studio    | Encodage/Décodage multi-formats                |
| 13  | Code Analysis           | Secrets, Obfuscation, Génération               |
| 14  | QR Code & Barcode       | Génération, Lecture, Export                    |
| 15  | Privacy & Anti-Tracking | Anonymisation, Analyse, Fingerprint            |

Cette application vise à devenir la **référence mondiale des boîtes à outils de cybersécurité offline pour mobile et desktop**.
