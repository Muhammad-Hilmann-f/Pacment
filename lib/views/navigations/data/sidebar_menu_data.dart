import 'package:flutter/material.dart';
import '../models/sidebar_menu_item.dart';

class SidebarMenuData {
  static List<SidebarMenuItem> getMenuItems(String currentRoute) {
    return [
      SidebarMenuItem(
        title: 'Tracking',
        icon: Icons.local_shipping_outlined,
        route: '/dashboard',
        isActive: currentRoute == '/dashboard',
      ),
      SidebarMenuItem(
        title: 'Analytics',
        icon: Icons.analytics_outlined,
        route: '/analytics',
        isActive: currentRoute == '/analytics',
      ),
      SidebarMenuItem(
        title: 'Account',
        icon: Icons.person_outline,
        route: '/account',
        isActive: currentRoute == '/account',
      ),
      SidebarMenuItem(
        title: 'Setting',
        icon: Icons.settings_outlined,
        route: '/settings',
        isActive: currentRoute == '/settings',
      ),
      SidebarMenuItem(
        title: 'Help & Support',
        icon: Icons.help_outline,
        route: '/help',
        isActive: currentRoute == '/help',
      ),
    ];
  }
}