import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoteBookLogo extends StatelessWidget {
  const NoteBookLogo({super.key, this.size = 120});

  final double size;

  static const String _svg = '''
<svg viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="pencilGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#86efac"/>
      <stop offset="100%" stop-color="#4ade80"/>
    </linearGradient>
  </defs>
  <g>
    <rect x="20" y="20" width="160" height="140" rx="12" fill="#6ee7b7"/>
    <rect x="20" y="20" width="30" height="140" rx="12" fill="#047857"/>
    <rect x="130" y="20" width="20" height="50" fill="#047857"/>
    <circle cx="35" cy="60" r="4" fill="#065f46"/>
    <circle cx="35" cy="90" r="4" fill="#065f46"/>
    <circle cx="35" cy="120" r="4" fill="#065f46"/>
    <rect x="20" y="90" width="160" height="90" rx="12" fill="white"/>
    <rect x="20" y="90" width="30" height="90" rx="12" fill="#047857"/>
    <circle cx="35" cy="110" r="4" fill="#065f46"/>
    <circle cx="35" cy="140" r="4" fill="#065f46"/>
    <circle cx="35" cy="170" r="4" fill="#065f46"/>
    <line x1="60" y1="105" x2="170" y2="105" stroke="#d1d5db" stroke-width="2"/>
    <line x1="60" y1="120" x2="170" y2="120" stroke="#d1d5db" stroke-width="2"/>
    <line x1="60" y1="135" x2="170" y2="135" stroke="#d1d5db" stroke-width="2"/>
    <line x1="60" y1="150" x2="170" y2="150" stroke="#d1d5db" stroke-width="2"/>
    <line x1="60" y1="165" x2="170" y2="165" stroke="#d1d5db" stroke-width="2"/>
  </g>
  <g transform="translate(110, 130) rotate(-30)">
    <rect x="0" y="0" width="60" height="16" rx="2" fill="url(#pencilGradient)"/>
    <rect x="60" y="0" width="6" height="16" fill="#94a3b8"/>
    <rect x="66" y="2" width="10" height="12" rx="2" fill="#f59e0b"/>
    <path d="M 0 4 L -12 8 L 0 12 Z" fill="#fed7aa"/>
    <path d="M 0 6 L -10 8 L 0 10 Z" fill="#374151"/>
    <rect x="5" y="3" width="40" height="3" rx="1.5" fill="white" opacity="0.4"/>
  </g>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.string(
        _svg,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
