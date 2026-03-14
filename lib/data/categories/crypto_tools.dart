import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
/// CRYPTOGRAPHY TOOLS
/// Hashing, Encryption, Signatures & Certificates
/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class CryptoTools {
  CryptoTools._();

  static const List<ToolModel> all = [
    // Hashing â€” MVP implemented
    ToolModel(
      id: 'hash_generator',
      name: 'Hash Generator',
      description:
          'Generate MD5, SHA1, SHA224, SHA256, SHA384, SHA512 hashes from any text input.',
      category: ToolCategory.crypto,
      icon: Icons.security,
      tags: ['hash', 'md5', 'sha', 'sha256', 'digest'],
      isAvailable: true,
      routePath: '/crypto/hash-generator',
    ),
    ToolModel(
      id: 'hmac_generator',
      name: 'HMAC Generator',
      description:
          'Generate HMAC-SHA256 and HMAC-SHA512 message authentication codes.',
      category: ToolCategory.crypto,
      icon: Icons.verified,
      tags: ['hmac', 'sha256', 'sha512', 'mac'],
      isAvailable: true,
      routePath: '/crypto/hmac',
    ),
    ToolModel(
      id: 'hash_comparator',
      name: 'Hash Comparator',
      description:
          'Compare two hash values to verify integrity. Supports all common algorithms.',
      category: ToolCategory.crypto,
      icon: Icons.compare_arrows,
      tags: ['compare', 'hash', 'verify'],
      isAvailable: true,
      routePath: '/crypto/hash-comparator',
    ),
    ToolModel(
      id: 'bcrypt_hash',
      name: 'Bcrypt Hash',
      description:
          'Generate and verify Bcrypt password hashes with configurable cost factor.',
      category: ToolCategory.crypto,
      icon: Icons.lock_reset,
      tags: ['bcrypt', 'password', 'hash'],
      isAvailable: true,
      routePath: '/crypto/bcrypt',
    ),
    ToolModel(
      id: 'argon2_hash',
      name: 'Argon2 Hash',
      description: 'Argon2id memory-hard password hashing function.',
      category: ToolCategory.crypto,
      icon: Icons.shield_outlined,
      tags: ['argon2', 'password', 'hash'],
      isAvailable: true,
      routePath: '/crypto/argon2',
    ),
    ToolModel(
      id: 'salt_generator',
      name: 'Salt Generator',
      description:
          'Generate cryptographically secure random salts of configurable length.',
      category: ToolCategory.crypto,
      icon: Icons.auto_fix_normal,
      tags: ['salt', 'random', 'crypto'],
      isAvailable: true,
      routePath: '/crypto/salt',
    ),
    ToolModel(
      id: 'blake2b_hash',
      name: 'BLAKE2b Hash',
      description: 'High-speed cryptographic hash using BLAKE2b algorithm.',
      category: ToolCategory.crypto,
      icon: Icons.biotech,
      tags: ['blake2', 'hash'],
      isAvailable: true,
      routePath: '/crypto/blake2',
    ),
    ToolModel(
      id: 'blake2s_hash',
      name: 'BLAKE2s Hash',
      description: 'BLAKE2s â€” optimized for 8 to 32-bit platforms.',
      category: ToolCategory.crypto,
      icon: Icons.biotech,
      tags: ['blake2', 'hash'],
      isAvailable: true,
      routePath: '/crypto/blake2s',
    ),
    ToolModel(
      id: 'ripemd160_hash',
      name: 'RIPEMD-160 Hash',
      description: 'RIPEMD-160 cryptographic hash function used in Bitcoin.',
      category: ToolCategory.crypto,
      icon: Icons.fingerprint,
      tags: ['ripemd', 'hash', 'bitcoin'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'keccak256_hash',
      name: 'Keccak-256 Hash',
      description:
          'Keccak-256 / SHA3-256 hash used in Ethereum smart contracts.',
      category: ToolCategory.crypto,
      icon: Icons.fingerprint,
      tags: ['keccak', 'sha3', 'ethereum', 'hash'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'crc_checksum',
      name: 'CRC Checksum',
      description:
          'Compute CRC16, CRC32, and CRC64 checksums for data integrity.',
      category: ToolCategory.crypto,
      icon: Icons.rule,
      tags: ['crc', 'checksum', 'integrity'],
      isAvailable: true,
      routePath: '/crypto/crc',
    ),
    ToolModel(
      id: 'adler32_checksum',
      name: 'Adler-32 Checksum',
      description: 'Fast Adler-32 checksum algorithm used in zlib.',
      category: ToolCategory.crypto,
      icon: Icons.rule,
      tags: ['adler', 'checksum'],
      isAvailable: false,
    ),

    // Encryption â€” MVP implemented
    ToolModel(
      id: 'aes_tool',
      name: 'AES Encrypt / Decrypt',
      description:
          'AES-128/256 encryption with CBC and GCM modes. Secure symmetric encryption.',
      category: ToolCategory.crypto,
      icon: Icons.lock,
      tags: ['aes', 'encrypt', 'decrypt', 'cbc', 'gcm'],
      isAvailable: true,
      routePath: '/crypto/aes',
    ),
    ToolModel(
      id: 'rsa_tool',
      name: 'RSA Key Generator',
      description:
          'Generate RSA 2048/4096 bit key pairs. Supports PEM export format.',
      category: ToolCategory.crypto,
      icon: Icons.vpn_key,
      tags: ['rsa', 'keys', 'asymmetric', 'pem'],
      isAvailable: true,
      routePath: '/crypto/rsa-keygen',
    ),
    ToolModel(
      id: 'pbkdf2_tool',
      name: 'PBKDF2 Key Derivation',
      description:
          'Derive cryptographic keys from passwords using PBKDF2-SHA256/SHA512.',
      category: ToolCategory.crypto,
      icon: Icons.key,
      tags: ['pbkdf2', 'kdf', 'key', 'derivation'],
      isAvailable: true,
      routePath: '/crypto/pbkdf2',
    ),
    ToolModel(
      id: 'chacha20_tool',
      name: 'ChaCha20-Poly1305',
      description: 'Encrypt and decrypt using ChaCha20-Poly1305 AEAD cipher.',
      category: ToolCategory.crypto,
      icon: Icons.lock_outline,
      tags: ['chacha20', 'poly1305', 'encrypt'],
      isAvailable: true,
      routePath: '/crypto/chacha20',
    ),
    ToolModel(
      id: 'rsa_encrypt',
      name: 'RSA Encrypt / Decrypt',
      description:
          'Encrypt and decrypt messages using RSA public/private key pairs.',
      category: ToolCategory.crypto,
      icon: Icons.lock_person,
      tags: ['rsa', 'encrypt', 'decrypt'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'random_key_gen',
      name: 'Random Key Generator',
      description:
          'Generate cryptographically secure random 256-bit or 512-bit keys.',
      category: ToolCategory.crypto,
      icon: Icons.shuffle,
      tags: ['random', 'key', 'csprng'],
      isAvailable: true,
      routePath: '/crypto/random-key',
    ),
    ToolModel(
      id: 'hkdf_tool',
      name: 'HKDF Key Derivation',
      description: 'HMAC-based Extract-and-Expand Key Derivation Function.',
      category: ToolCategory.crypto,
      icon: Icons.key,
      tags: ['hkdf', 'kdf', 'derivation'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'triple_des',
      name: '3DES Encrypt / Decrypt',
      description:
          'Triple DES symmetric block cipher for legacy compatibility.',
      category: ToolCategory.crypto,
      icon: Icons.lock_outline,
      tags: ['3des', 'des', 'encrypt'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'blowfish_tool',
      name: 'Blowfish Cipher',
      description: 'Blowfish symmetric block cipher encryption and decryption.',
      category: ToolCategory.crypto,
      icon: Icons.lock_outline,
      tags: ['blowfish', 'encrypt'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'vigenere_cipher',
      name: 'VigenÃ¨re Cipher',
      description: 'Classical polyalphabetic substitution cipher.',
      category: ToolCategory.crypto,
      icon: Icons.abc,
      tags: ['vigenere', 'cipher', 'classical'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'caesar_cipher',
      name: 'Caesar Cipher',
      description:
          'Caesar shift cipher â€” encode and decode with any shift value.',
      category: ToolCategory.crypto,
      icon: Icons.abc,
      tags: ['caesar', 'cipher', 'shift'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'otp_generator',
      name: 'One-Time Pad',
      description: 'Generate and apply a one-time pad for perfect secrecy.',
      category: ToolCategory.crypto,
      icon: Icons.password,
      tags: ['otp', 'one-time-pad', 'encrypt'],
      isAvailable: false,
    ),

    // Signatures & Certificates
    ToolModel(
      id: 'ecdsa_keys',
      name: 'ECDSA Key Generator',
      description: 'Generate ECDSA key pairs for digital signatures.',
      category: ToolCategory.crypto,
      icon: Icons.vpn_key_outlined,
      tags: ['ecdsa', 'keys', 'signature'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'ed25519_keys',
      name: 'Ed25519 Key Generator',
      description: 'Generate Ed25519 keys for EdDSA digital signatures.',
      category: ToolCategory.crypto,
      icon: Icons.vpn_key_outlined,
      tags: ['ed25519', 'keys', 'signature'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'x509_analyzer',
      name: 'X.509 Certificate Analyzer',
      description: 'Parse and inspect X.509 certificates in PEM or DER format.',
      category: ToolCategory.crypto,
      icon: Icons.workspace_premium,
      tags: ['x509', 'certificate', 'pem', 'tls'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'msg_signature',
      name: 'Message Signer / Verifier',
      description: 'Sign messages and verify signatures using RSA/ECDSA keys.',
      category: ToolCategory.crypto,
      icon: Icons.draw_outlined,
      tags: ['sign', 'verify', 'signature'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'csr_generator',
      name: 'CSR Generator',
      description:
          'Generate Certificate Signing Requests for SSL/TLS certificates.',
      category: ToolCategory.crypto,
      icon: Icons.description_outlined,
      tags: ['csr', 'certificate', 'ssl'],
      isAvailable: false,
    ),
  ];
}


