import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:pointycastle/export.dart';

class RsaService {
  RsaService._();

  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateKeyPair(int bitLength) {
    final rng = FortunaRandom();
    final secureRandom = Random.secure();
    final seeds = List<int>.generate(32, (_) => secureRandom.nextInt(256));
    rng.seed(KeyParameter(Uint8List.fromList(seeds)));

    final keyGen = RSAKeyGenerator();
    keyGen.init(ParametersWithRandom(
      RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
      rng,
    ));

    final pair = keyGen.generateKeyPair();
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      pair.publicKey as RSAPublicKey,
      pair.privateKey as RSAPrivateKey,
    );
  }

  static String publicKeyToPem(RSAPublicKey key) {
    // DER encode a SubjectPublicKeyInfo structure for RSA
    final modLen = _bigIntBytes(key.modulus!);
    final expLen = _bigIntBytes(key.publicExponent!);

    // Build inner RSAPublicKey SEQUENCE
    final inner = _encodeSequence([
      _encodeInteger(key.modulus!),
      _encodeInteger(key.publicExponent!),
    ]);

    // Build AlgorithmIdentifier SEQUENCE (rsaEncryption OID + NULL)
    final algoId = _encodeSequence([
      _encodeOid([1, 2, 840, 113549, 1, 1, 1]),
      _encodeNull(),
    ]);

    // BIT STRING wrapping the inner RSAPublicKey
    final bitString = _encodeBitString(inner);

    // Outer SEQUENCE
    final outer = _encodeSequence([algoId, bitString]);

    final b64 = base64.encode(outer);
    return '-----BEGIN PUBLIC KEY-----\n${_wrapBase64(b64)}\n-----END PUBLIC KEY-----';
  }

  static String privateKeyToPem(RSAPrivateKey key) {
    // Build PKCS#8 PrivateKeyInfo
    final rsa = _encodeSequence([
      _encodeInteger(BigInt.zero),   // version
      _encodeInteger(key.modulus!),
      _encodeInteger(key.publicExponent!),
      _encodeInteger(key.privateExponent!),
      _encodeInteger(key.p!),
      _encodeInteger(key.q!),
      _encodeInteger(key.privateExponent! % (key.p! - BigInt.one)),
      _encodeInteger(key.privateExponent! % (key.q! - BigInt.one)),
      _encodeInteger(key.q!.modInverse(key.p!)),
    ]);

    final algoId = _encodeSequence([
      _encodeOid([1, 2, 840, 113549, 1, 1, 1]),
      _encodeNull(),
    ]);

    final pkcs8 = _encodeSequence([
      _encodeInteger(BigInt.zero),
      algoId,
      _encodeOctetString(rsa),
    ]);

    final b64 = base64.encode(pkcs8);
    return '-----BEGIN PRIVATE KEY-----\n${_wrapBase64(b64)}\n-----END PRIVATE KEY-----';
  }

  // ── Manual DER/ASN.1 encoding helpers ───────────────────────────────────────

  static Uint8List _encodeLength(int len) {
    if (len < 0x80) return Uint8List.fromList([len]);
    if (len <= 0xFF) return Uint8List.fromList([0x81, len]);
    if (len <= 0xFFFF) return Uint8List.fromList([0x82, len >> 8, len & 0xFF]);
    return Uint8List.fromList([0x83, len >> 16, (len >> 8) & 0xFF, len & 0xFF]);
  }

  static Uint8List _encodeTLV(int tag, Uint8List value) {
    return Uint8List.fromList([tag, ..._encodeLength(value.length), ...value]);
  }

  static Uint8List _encodeSequence(List<Uint8List> items) {
    final combined = Uint8List.fromList(items.expand((x) => x).toList());
    return _encodeTLV(0x30, combined);
  }

  static Uint8List _encodeInteger(BigInt n) {
    var bytes = _bigIntBytes(n);
    // Ensure positive (add 0x00 if high bit set)
    if (bytes.first >= 0x80) bytes = Uint8List.fromList([0x00, ...bytes]);
    return _encodeTLV(0x02, bytes);
  }

  static Uint8List _encodeBitString(Uint8List data) {
    // Prepend 0x00 (no unused bits)
    final bs = Uint8List.fromList([0x00, ...data]);
    return _encodeTLV(0x03, bs);
  }

  static Uint8List _encodeOctetString(Uint8List data) {
    return _encodeTLV(0x04, data);
  }

  static Uint8List _encodeNull() {
    return Uint8List.fromList([0x05, 0x00]);
  }

  static Uint8List _encodeOid(List<int> components) {
    final bytes = <int>[];
    bytes.add(40 * components[0] + components[1]);
    for (var i = 2; i < components.length; i++) {
      var val = components[i];
      if (val == 0) {
        bytes.add(0);
      } else {
        final buf = <int>[];
        while (val > 0) {
          buf.insert(0, (val & 0x7F) | (buf.isEmpty ? 0 : 0x80));
          val >>= 7;
        }
        bytes.addAll(buf);
      }
    }
    return _encodeTLV(0x06, Uint8List.fromList(bytes));
  }

  static Uint8List _bigIntBytes(BigInt n) {
    if (n == BigInt.zero) return Uint8List.fromList([0]);
    var hex = n.toRadixString(16);
    if (hex.length % 2 != 0) hex = '0$hex';
    return Uint8List.fromList(
      List.generate(hex.length ~/ 2, (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)),
    );
  }

  static String _wrapBase64(String b64) {
    final buf = StringBuffer();
    for (var i = 0; i < b64.length; i += 64) {
      buf.writeln(b64.substring(i, (i + 64).clamp(0, b64.length)));
    }
    return buf.toString().trimRight();
  }
}
