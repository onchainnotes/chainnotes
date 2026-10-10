import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';

import 'package:chain_notes/features/wallet/domain/entity/chain.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:web3dart/web3dart.dart';

class Erc721MintService {
  Erc721MintService._();

  static final Erc721MintService instance = Erc721MintService._();

  BigInt tokenIdFromNote(Note note) {
    var id = note.id.replaceFirst(RegExp(r'^new_'), '');

    final composite = RegExp(r'^(\d+)_(.+)$').firstMatch(id);
    if (composite != null) {
      final suffix = composite.group(2)!;
      try {
        return BigInt.parse(suffix);
      } catch (_) {

      }
    }

    final num = int.tryParse(id);
    if (num != null && num >= 0) {
      return BigInt.from(num);
    }

    final hash = id.hashCode & 0x7FFFFFFF;
    return BigInt.from(hash);
  }

  String? buildSafeMintCalldata({
    required String to,
    required BigInt tokenId,
  }) {
    try {
      final function = ContractFunction(
        'safeMint',
        [
          const FunctionParameter('to', AddressType()),
          const FunctionParameter('tokenId', UintType()),
        ],
      );

      final encoded = function.encodeCall([
        EthereumAddress.fromHex(to),
        tokenId,
      ]);

      return _toHex(encoded);
    } catch (e) {
      debugPrint("safeMint calldata error: $e");
      return null;
    }
  }

  String? buildMintNoteCalldata({
    required String tokenUri,
    required String contentUri,
  }) {
    try {
      final function = ContractFunction(
        'mintNote',
        [
          const FunctionParameter('tokenUri', StringType()),
          const FunctionParameter('contentUri', StringType()),
        ],
      );

      final encoded = function.encodeCall([
        tokenUri,
        contentUri,
      ]);

      final calldata = _toHex(encoded);

      debugPrint("calldata: $calldata");

      return calldata;
    } catch (e) {
      debugPrint("mintNote calldata error: $e");
      return null;
    }
  }

  String? buildMintCalldataForNote({
    String? tokenUri,
    String? contentUri,
  }) {
    if (tokenUri == null ||
        tokenUri.isEmpty ||
        contentUri == null ||
        contentUri.isEmpty) {
      return null;
    }

    final calldata = buildMintNoteCalldata(
      tokenUri: tokenUri,
      contentUri: contentUri,
    );

    debugPrint("我的calldata: $calldata");

    return calldata;
  }

  Erc721MintTxParams buildMintTxParams({
    required Chain chain,
    required String contractAddress,
    required String fromAddress,
    required String calldata,
    BigInt? value,
  }) {
    final normalizedContract = _normalizeAddress(contractAddress);

    return Erc721MintTxParams(
      chain: chain,
      to: normalizedContract,
      from: _normalizeAddress(fromAddress),
      data: calldata.startsWith('0x') ? calldata : '0x$calldata',
      value: value ?? BigInt.zero,
    );
  }

  static String _normalizeAddress(String addr) {
    if (addr.startsWith('0x')) return addr;
    return '0x$addr';
  }

  static String _toHex(List<int> bytes) {
    return '0x${bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join()}';
  }

  static Uint8List _addressToBytes(String address) {
    final s = address.startsWith('0x')
        ? address.substring(2)
        : address;

    if (s.length != 40) {
      throw ArgumentError('Invalid address length: $address');
    }

    return Uint8List.fromList([
      for (int i = 0; i < 40; i += 2)
        int.parse(s.substring(i, i + 2), radix: 16)
    ]);
  }

  static Uint8List _uint256ToBytes(BigInt value) {
    if (value < BigInt.zero) {
      throw ArgumentError('tokenId must be non-negative');
    }

    var hex = value.toRadixString(16);

    if (hex.length % 2 == 1) hex = '0$hex';

    hex = hex.padLeft(64, '0');

    if (hex.length > 64) {
      throw ArgumentError('tokenId exceeds uint256 range');
    }

    return Uint8List.fromList([
      for (int i = 0; i < 64; i += 2)
        int.parse(hex.substring(i, i + 2), radix: 16)
    ]);
  }
}

class Erc721MintTxParams {
  Erc721MintTxParams({
    required this.chain,
    required this.to,
    required this.from,
    required this.data,
    BigInt? value,
  }) : value = value ?? BigInt.zero;

  final Chain chain;
  final String to;
  final String from;
  final String data;
  final BigInt value;

  Map<String, String> toRpcParams() {
    return {
      'from': from,
      'to': to,
      'data': data,
      'value': '0x${value.toRadixString(16)}',
    };
  }
}