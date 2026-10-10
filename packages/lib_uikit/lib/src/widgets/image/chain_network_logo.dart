import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'cached_network_image.dart';

const String kIconifyApiHost = 'api.iconify.design';

class ChainNetworkLogo extends StatelessWidget {
  const ChainNetworkLogo({
    super.key,
    this.chainLogoUrl,
    required this.fallbackColor,
    required this.fallbackLabel,
    this.size = 48,
  });

  final String? chainLogoUrl;

  final int fallbackColor;

  final String fallbackLabel;

  final double size;

  static bool _isSvgOrIconifyUrl(String url) {
    final u = url.toLowerCase();
    if (u.contains(kIconifyApiHost)) return true;
    return u.endsWith('.svg');
  }

  static Widget buildFallbackCircle({
    required double size,
    required int fallbackColor,
    required String fallbackLabel,
  }) {
    final label = fallbackLabel.isNotEmpty ? fallbackLabel : '?';
    final isMulti = label.runes.length > 1 || label.length > 1;
    final fontSize = (isMulti ? size * 0.38 : size * 0.44).clamp(12.0, 24.0);
    final inset = size * 0.14;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(fallbackColor),
            Color(fallbackColor).withValues(alpha: 0.85),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(inset),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
              textAlign: TextAlign.center,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = chainLogoUrl?.trim() ?? '';
    if (url.isEmpty) {
      return _buildFallback();
    }
    if (_isSvgOrIconifyUrl(url)) {
      return _ChainSvgNetworkLogo(
        url: url,
        size: size,
        fallbackColor: fallbackColor,
        fallbackLabel: fallbackLabel,
      );
    }
    return CachedNetworkImageBox(
      imageUrl: url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(size / 2),
      placeholder: _buildFallback(),
      errorWidget: _buildFallback(),
    );
  }

  Widget _buildFallback() => buildFallbackCircle(
        size: size,
        fallbackColor: fallbackColor,
        fallbackLabel: fallbackLabel,
      );
}

class _ChainSvgNetworkLogo extends StatefulWidget {
  const _ChainSvgNetworkLogo({
    required this.url,
    required this.size,
    required this.fallbackColor,
    required this.fallbackLabel,
  });

  final String url;
  final double size;
  final int fallbackColor;
  final String fallbackLabel;

  @override
  State<_ChainSvgNetworkLogo> createState() => _ChainSvgNetworkLogoState();
}

class _ChainSvgNetworkLogoState extends State<_ChainSvgNetworkLogo> {
  String? _svg;
  bool _failed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _ChainSvgNetworkLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _svg = null;
      _failed = false;
      _loading = true;
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final r = await http
          .get(Uri.parse(widget.url))
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      if (r.statusCode == 200 &&
          r.body.isNotEmpty &&
          r.body.trimLeft().startsWith('<')) {
        setState(() {
          _svg = r.body;
          _failed = false;
          _loading = false;
        });
      } else {
        setState(() {
          _failed = true;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _failed = true;
          _loading = false;
        });
      }
    }
  }

  Widget _fallback() => ChainNetworkLogo.buildFallbackCircle(
        size: widget.size,
        fallbackColor: widget.fallbackColor,
        fallbackLabel: widget.fallbackLabel,
      );

  @override
  Widget build(BuildContext context) {
    if (_failed) return _fallback();
    if (_loading || _svg == null) return _fallback();
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.size / 2),
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(widget.size * 0.12),
              child: SvgPicture.string(
                _svg!,
                width: widget.size,
                height: widget.size,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
        ),
      );
    } catch (_) {
      return _fallback();
    }
  }
}
