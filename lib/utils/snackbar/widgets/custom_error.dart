import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  const CustomError({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 113, 113),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('Error', style: TextStyle(color: Colors.white),),
               Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
                weight: 100,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
