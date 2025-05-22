import 'package:flutter/material.dart';
import '../data/sidebar_menu_data.dart';
import 'sidebar_menu_item.dart';

class SidebarMenuSection extends StatelessWidget {
  final String currentRoute;

  const SidebarMenuSection({
    super.key,
    this.currentRoute = '/dashboard',
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = SidebarMenuData.getMenuItems(currentRoute);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = menuItems[index];
        return SidebarMenuItemWidget(
          menuItem: menuItem,
          onTap: () => _handleMenuTap(context, menuItem.route),
        );
      },
    );
  }

  void _handleMenuTap(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer
    
    // Navigate to the selected route
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}
