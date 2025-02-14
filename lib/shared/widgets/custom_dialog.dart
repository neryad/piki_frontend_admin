import 'package:flutter/material.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/theme/app_theme.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final List<Widget> formFields;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final double dialogSize;
  final String cancelText;
  final String confirmText;
  final Color cancelButtonColor;
  final Color confirmButtonColor;
  final Color cancelTextColor;
  final Color confirmTextColor;
  final IconData cancelIcon;
  final IconData confirmIcon;

  const CustomDialog({
    super.key,
    required this.title,
    required this.formFields,
    required this.onCancel,
    required this.onConfirm,
    this.cancelText = 'Cancelar',
    this.confirmText = 'Confirmar',
    this.dialogSize = 0.6,
    this.cancelButtonColor = AppTheme.radicalRed,
    this.confirmButtonColor = Colors.blue,
    this.cancelTextColor = Colors.white,
    this.confirmTextColor = Colors.white,
    this.cancelIcon = Icons.close,
    this.confirmIcon = Icons.check,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * dialogSize,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...formFields,
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth <
                    400; // punto de quiebre para diálogos pequeños

                return Flex(
                  direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: isSmallScreen
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: isSmallScreen ? double.infinity : null,
                      child: ReusableButton(
                        childText: cancelText,
                        onPressed: onCancel,
                        buttonColor: cancelButtonColor,
                        childTextColor: cancelTextColor,
                        iconData: cancelIcon,
                      ),
                    ),
                    SizedBox(
                      height: isSmallScreen ? 8 : 0,
                      width: isSmallScreen ? 0 : 8,
                    ),
                    SizedBox(
                      width: isSmallScreen ? double.infinity : null,
                      child: ReusableButton(
                        childText: confirmText,
                        onPressed: onConfirm,
                        buttonColor: confirmButtonColor,
                        childTextColor: confirmTextColor,
                        iconData: confirmIcon,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
