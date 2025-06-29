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
        title: 'History',
        icon: Icons.history_outlined,
        route: '/history',
        isActive: currentRoute == '/history',
      ),
    ];
  }
}