import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/base_card.dart';
import '../core/widgets/base_text.dart';
import 'characters_screen.dart';
import 'episodes_screen.dart';
import 'locations_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(
          text: 'RICK AND MORTY',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                const BaseText(
                  text: 'Explore the multiverse',
                  fontSize: 16,
                  color: Colors.white70,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _CategoryTile(
                  title: 'Characters',
                  subtitle: 'Meet the multiverse cast',
                  icon: Icons.face_retouching_natural,
                  color: AppTheme.neonGreen,
                  onTap: () => _open(context, const CharactersScreen()),
                ),
                const SizedBox(height: 16),
                _CategoryTile(
                  title: 'Locations',
                  subtitle: 'Travel across dimensions',
                  icon: Icons.public,
                  color: AppTheme.neonBlue,
                  onTap: () => _open(context, const LocationsScreen()),
                ),
                const SizedBox(height: 16),
                _CategoryTile(
                  title: 'Episodes',
                  subtitle: 'Browse every adventure',
                  icon: Icons.live_tv,
                  color: const Color(0xFFFFC857),
                  onTap: () => _open(context, const EpisodesScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: BaseCard(
          neonColor: color,
          child: Row(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      text: title.toUpperCase(),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    const SizedBox(height: 6),
                    BaseText(
                      text: subtitle,
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
