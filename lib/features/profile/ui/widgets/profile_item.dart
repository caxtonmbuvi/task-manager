import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
     this.primaryColor,
     this.secondaryColor,
    required this.title,
    this.ontap,
    required this.iconData,
  });

  final Color? primaryColor;
  final Color? secondaryColor;
  final String title;
  final VoidCallback? ontap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: SizedBox(
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
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
