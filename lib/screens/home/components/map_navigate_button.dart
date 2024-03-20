import 'package:flutter/material.dart';
import 'package:trasua_delivery/config/colors.dart';

class MapNavigateButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData iconData;
  const MapNavigateButton({
    super.key,
    this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: AppColors.orange100, // Make the button circular
          padding: const EdgeInsets.all(18),
        ),
        child: Icon(
          iconData,
          size: 22,
          color: AppColors.white100,
        ),
      ),
    );
  }
}
