import 'package:flutter/material.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/theme/app_theme.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final List<Widget> formFields;
  final VoidCallback onCancel;
  final Future<void> Function() onConfirm;
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
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    setState(() => _isLoading = true);
    await widget.onConfirm();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * widget.dialogSize,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...widget.formFields,
            const SizedBox(height: 16),
            if (_isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 10),
                  Text("Enviando información...",
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            if (!_isLoading)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxWidth < 400;

                  return Flex(
                    direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
                    mainAxisAlignment: isSmallScreen
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: isSmallScreen ? double.infinity : null,
                        child: ReusableButton(
                          childText: widget.cancelText,
                          onPressed: widget.onCancel,
                          buttonColor: widget.cancelButtonColor,
                          childTextColor: widget.cancelTextColor,
                          iconData: widget.cancelIcon,
                        ),
                      ),
                      SizedBox(
                        height: isSmallScreen ? 8 : 0,
                        width: isSmallScreen ? 0 : 8,
                      ),
                      SizedBox(
                        width: isSmallScreen ? double.infinity : null,
                        child: ReusableButton(
                          childText: widget.confirmText,
                          onPressed: _handleConfirm,
                          buttonColor: widget.confirmButtonColor,
                          childTextColor: widget.confirmTextColor,
                          iconData: widget.confirmIcon,
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
