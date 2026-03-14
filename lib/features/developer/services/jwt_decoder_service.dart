import 'dart:convert';
import 'package:convert/convert.dart';

class JwtDecoderService {
  JwtDecoderService._();

  /// Decode JWT token and extract parts
  static Map<String, dynamic> decodeJwt(String token) {
    try {
      // Remove "Bearer " prefix if present
      final cleanToken = token.trim().startsWith('Bearer ') 
          ? token.trim().substring(7) 
          : token.trim();

      final parts = cleanToken.split('.');
      if (parts.length != 3) {
        throw FormatException('Invalid JWT format. Expected 3 parts separated by dots.');
      }

      final headerJson = _decodeBase64Url(parts[0]);
      final payloadJson = _decodeBase64Url(parts[1]);
      final signature = parts[2];

      final header = jsonDecode(headerJson) as Map<String, dynamic>;
      final payload = jsonDecode(payloadJson) as Map<String, dynamic>;

      // Parse common claims
      final expiry = payload['exp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch((payload['exp'] as int) * 1000)
          : null;
      
      final issuedAt = payload['iat'] != null
          ? DateTime.fromMillisecondsSinceEpoch((payload['iat'] as int) * 1000)
          : null;

      final isExpired = expiry != null && DateTime.now().isAfter(expiry);

      return {
        'valid': true,
        'header': header,
        'payload': payload,
        'signature': signature,
        'algorithm': header['alg'] ?? 'Unknown',
        'tokenType': header['typ'] ?? 'JWT',
        'issuedAt': issuedAt,
        'expiresAt': expiry,
        'isExpired': isExpired,
        'timeUntilExpiry': expiry != null 
            ? expiry.difference(DateTime.now()) 
            : null,
        'issuer': payload['iss'],
        'subject': payload['sub'],
        'audience': payload['aud'],
        'username': payload['name'] ?? payload['preferred_username'] ?? payload['username'],
      };
    } catch (e) {
      return {
        'valid': false,
        'error': e.toString(),
      };
    }
  }

  /// Analyze JWT security
  static Map<String, dynamic> analyzeSecurity(String token) {
    final decoded = decodeJwt(token);
    
    if (!decoded['valid']) {
      return {'error': decoded['error']};
    }

    final algorithm = decoded['algorithm'] as String;
    final issues = <String>[];
    final warnings = <String>[];
    final recommendations = <String>[];

    // Check algorithm
    if (algorithm == 'none') {
      issues.add('CRITICAL: Algorithm is "none" - token is unsigned!');
    } else if (algorithm.startsWith('HS')) {
      warnings.add('Using symmetric HMAC algorithm ($algorithm)');
      recommendations.add('Consider using asymmetric algorithms (RS256, ES256) for better security');
    } else if (algorithm.startsWith('RS') || algorithm.startsWith('ES') || algorithm.startsWith('PS')) {
      // Good - asymmetric
    }

    // Check for sensitive data in payload
    final payload = decoded['payload'] as Map<String, dynamic>;
    final sensitiveFields = ['password', 'secret', 'credit_card', 'ssn', 'private_key'];
    
    for (final field in sensitiveFields) {
      if (payload.containsKey(field)) {
        issues.add('Sensitive data found in payload: $field');
      }
    }

    // Check expiry
    if (decoded['isExpired'] == true) {
      warnings.add('Token has expired');
    } else if (decoded['timeUntilExpiry'] != null) {
      final days = (decoded['timeUntilExpiry'] as Duration).inDays;
      if (days > 365) {
        warnings.add('Token has very long expiry (>1 year)');
        recommendations.add('Consider shorter token lifetime for better security');
      } else if (days < 1) {
        warnings.add('Token expires soon (<24 hours)');
      }
    }

    // Check for standard claims
    if (!payload.containsKey('exp')) {
      warnings.add('No expiration claim (exp) - token never expires');
      recommendations.add('Always include expiration time');
    }
    
    if (!payload.containsKey('iat')) {
      warnings.add('No issued at claim (iat)');
    }

    if (!payload.containsKey('iss')) {
      recommendations.add('Consider adding issuer claim (iss)');
    }

    // Calculate security score
    int score = 100;
    score -= issues.length * 25;
    score -= warnings.length * 10;
    score = score.clamp(0, 100);

    String rating;
    if (score >= 90) {
      rating = 'Excellent';
    } else if (score >= 70) {
      rating = 'Good';
    } else if (score >= 50) {
      rating = 'Fair';
    } else if (score >= 30) {
      rating = 'Poor';
    } else {
      rating = 'Critical';
    }

    return {
      'score': score,
      'rating': rating,
      'issues': issues,
      'warnings': warnings,
      'recommendations': recommendations,
      'algorithm': algorithm,
      'hasExpiry': payload.containsKey('exp'),
      'isExpired': decoded['isExpired'],
    };
  }

  static String _decodeBase64Url(String input) {
    // Add padding if needed
    String normalized = input;
    while (normalized.length % 4 != 0) {
      normalized += '=';
    }
    
    // Replace URL-safe characters
    normalized = normalized.replaceAll('-', '+').replaceAll('_', '/');
    
    try {
      final bytes = base64Decode(normalized);
      return utf8.decode(bytes);
    } catch (e) {
      // Try decoding as hex
      try {
        final bytes = hex.decode(input);
        return utf8.decode(bytes);
      } catch (_) {
        throw FormatException('Failed to decode Base64URL string');
      }
    }
  }

  /// Create a sample JWT for testing (not for production use!)
  static String createSampleJwt() {
    final header = {
      'alg': 'HS256',
      'typ': 'JWT',
    };

    final payload = {
      'sub': '1234567890',
      'name': 'John Doe',
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      'role': 'developer',
    };

    final headerB64 = base64Encode(utf8.encode(jsonEncode(header)))
        .replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
    final payloadB64 = base64Encode(utf8.encode(jsonEncode(payload)))
        .replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');

    // Note: This is just for demo purposes, not a real signature
    final signature = 'sample_signature_for_testing_purposes_only';

    return '$headerB64.$payloadB64.$signature';
  }
}
