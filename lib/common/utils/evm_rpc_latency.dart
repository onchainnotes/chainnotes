import 'package:http/http.dart' as http;

Future<int?> measureEvmJsonRpcLatencyMs(
  String rpcUrl, {
  Duration timeout = const Duration(seconds: 8),
}) async {
  final u = rpcUrl.trim();
  if (u.isEmpty) return null;
  final sw = Stopwatch()..start();
  try {
    final response = await http
        .post(
          Uri.parse(u),
          headers: const {'Content-Type': 'application/json'},
          body:
              '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}',
        )
        .timeout(timeout);
    sw.stop();
    final body = response.body;
    if (response.statusCode == 200 &&
        body.contains('result') &&
        !body.contains('"error"')) {
      return sw.elapsedMilliseconds;
    }
  } catch (_) {
    sw.stop();
  }
  return null;
}
