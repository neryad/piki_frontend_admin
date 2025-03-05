import 'package:flutter/material.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';

class ActionSearchBar extends StatelessWidget {
  final String actionButtonText;
  final VoidCallback onActionPressed;
  final Color actionButtonColor;
  final IconData actionIcon;
  final Function(String) onSearch;

  const ActionSearchBar({
    super.key,
    required this.actionButtonText,
    required this.onActionPressed,
    required this.actionButtonColor,
    required this.actionIcon,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen =
            constraints.maxWidth < 600; // punto de quiebre para móviles

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: 16,
          ),
          child: Flex(
            direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: isSmallScreen
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              ReusableButton(
                childText: actionButtonText,
                onPressed: onActionPressed,
                buttonColor: actionButtonColor,
                childTextColor: Colors.white,
                iconData: actionIcon,
              ),
              if (isSmallScreen)
                const SizedBox(height: 16), // espaciado vertical en móvil
              SizedBox(
                width: isSmallScreen
                    ? double.infinity
                    : MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onSearch,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
