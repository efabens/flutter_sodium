import 'dart:typed_data';
import 'dart:convert';
import 'sodium.dart';

/// Computes a fixed-length fingerprint for an arbitrary long message using the BLAKE2b algorithm.
class GenericHash {
  /// The primitive name.
  static String get primitive => Sodium.cryptoGenerichashPrimitive;

  /// Generates a random key for use with generic hashing.
  static Uint8List generateKey() => Sodium.cryptoGenerichashKeygen();

  /// Computes a generic hash of specified length for given string value and optional key.
  static Uint8List hash(String value, {Uint8List key, int outlen}) {
    outlen ??= Sodium.cryptoGenerichashBytes;
    return Sodium.cryptoGenerichash(outlen, utf8.encode(value), key);
  }

  /// Computes a generic hash of specified length for given value and optional key.
  static Uint8List hashBytes(Uint8List value, {Uint8List key, int outlen}) {
    outlen ??= Sodium.cryptoGenerichashBytes;
    return Sodium.cryptoGenerichash(outlen, value, key);
  }

  /// Computes a generic hash of specified length for given stream of string values and optional key.
  static Future<Uint8List> hashStream(Stream<String> stream,
      {Uint8List key, int outlen}) async {
    outlen ??= Sodium.cryptoGenerichashBytes;
    var state = Sodium.cryptoGenerichashInit(key, outlen);
    await for (var value in stream) {
      state = Sodium.cryptoGenerichashUpdate(state, utf8.encode(value));
    }
    return Sodium.cryptoGenerichashFinal(state, outlen);
  }

  /// Computes a generic hash of specified length for given stream of byte values and optional key.
  static Future<Uint8List> hashByteStream(Stream<Uint8List> stream,
      {Uint8List key, int outlen}) async {
    outlen ??= Sodium.cryptoGenerichashBytes;
    var state = Sodium.cryptoGenerichashInit(key, outlen);
    await for (var value in stream) {
      state = Sodium.cryptoGenerichashUpdate(state, value);
    }
    return Sodium.cryptoGenerichashFinal(state, outlen);
  }
}
