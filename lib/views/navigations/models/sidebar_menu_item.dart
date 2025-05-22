import 'package:flutter/material.dart';

class SidebarMenuItem {
  final String title;
  final IconData icon;
  final String route;
  final bool isActive;

  const SidebarMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.isActive = false,
  });
}
