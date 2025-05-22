import 'package:flutter/material.dart';
import '../models/sidebar_menu_item.dart';

class SidebarMenuItemWidget extends StatelessWidget {
  final SidebarMenuItem menuItem;
  final VoidCallback onTap;

  const SidebarMenuItemWidget({
    super.key,
    required this.menuItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: menuItem.isActive 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  menuItem.icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  menuItem.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: menuItem.isActive 
                        ? FontWeight.w600 
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}