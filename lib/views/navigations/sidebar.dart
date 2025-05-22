import 'package:flutter/material.dart';
import 'widgets/sidebar_header.dart';
import 'widgets/sidebar_menu_section.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;

  const AppSidebar({
    super.key,
    this.currentRoute = '/dashboard',
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E213A),
      child: Column(
        children: [
          const SidebarHeader(),
          Expanded(
            child: SidebarMenuSection(currentRoute: currentRoute),
          ),
        ],
      ),
    );
  }
}
