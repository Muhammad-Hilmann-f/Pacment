import 'package:flutter/material.dart';
import '../../../widgets/profile_avatar.dart';

class DashboardAppBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback? onMenuTap; // Added menu callback

  const DashboardAppBar({
    super.key,
    required this.onProfileTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MenuButton(onTap: onMenuTap ?? () => Scaffold.of(context).openDrawer()),
          const _AppTitle(),
          ProfileAvatar(onTap: onProfileTap),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MenuButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: const Icon(
          Icons.menu,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Pacment',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
