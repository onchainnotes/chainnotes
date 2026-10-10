part of trust_wallet_core_ffi;


class TWCardanoImpl extends TWCardano {
  static int TWCardanoMinAdaAmount(
    Uint8List tokenBundle,
  ) {
    final data = TWData.TWDataCreateWithBytes(
        tokenBundle.toPointerUint8(), tokenBundle.length);
    final result = TWCardano.TWCardanoMinAdaAmount(data);
    TWData.TWDataDelete(data);
    return result;
  }

  static int TWCardanoOutputMinAdaAmount(
      String toAddress, Uint8List tokenBundle, String coinsPerUtxoByte) {
    final to = TWStringImpl.toTWString(toAddress);
    final data = TWData.TWDataCreateWithBytes(
        tokenBundle.toPointerUint8(), tokenBundle.length);
    final bytes = TWStringImpl.toTWString(coinsPerUtxoByte);
    final result = TWCardano.TWCardanoOutputMinAdaAmount(to, data, bytes);
    TWData.TWDataDelete(data);
    TWStringImpl.delete(to);
    TWStringImpl.delete(bytes);
    return int.parse(TWStringImpl.toDartString(result));
  }

  static String getByronAddress(Uint8List publicKey) {
    final data = TWData.TWDataCreateWithBytes(
        publicKey.toPointerUint8(), publicKey.length);
    final result =
        TWStringImpl.toDartString(TWCardano.TWCardanoGetByronAddress(data));
    TWData.TWDataDelete(data);
    return result;
  }
}
