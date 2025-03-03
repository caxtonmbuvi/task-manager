import 'package:flutter/material.dart';

class ModeSwitcher extends StatelessWidget {
  const ModeSwitcher({
    super.key,
    this.primaryColor,
    this.secondaryColor,
    required this.title,
    required this.iconData,
    required this.isDarkMode,
    required this.onToggle,
  });

  final Color? primaryColor;
  final Color? secondaryColor;
  final String title;
  final IconData iconData;
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isDarkMode),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: secondaryColor ?? Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(
                    iconData,
                    color: primaryColor ?? Colors.blue.shade200,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: primaryColor ?? Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          Switch(
            value: isDarkMode,
            onChanged: onToggle,
            activeColor: Colors.blue,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
