import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({super.key, required this.hintText, this.onChange, this.errorMsg, this.obscureText, this.icon});
  final ValueChanged<String>? onChange;
  final String hintText;
  final String? errorMsg;
  final bool? obscureText;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 7.0,
          shadowColor: const Color.fromARGB(170, 158, 158, 158),
          borderRadius: BorderRadius.circular(30.0),
          child: TextField(
            obscureText: obscureText ?? false,
            keyboardType: TextInputType.emailAddress,
            onChanged: onChange,
            style: const TextStyle(
              fontSize: 13.0
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 20.0, 0),
                child: Icon(icon ?? Icons.person),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 13.0
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(30.0)
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white
                ),
                borderRadius: BorderRadius.circular(30.0)
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white
                ),
                borderRadius: BorderRadius.circular(30.0)
              ),
              hintText: hintText,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Text(errorMsg ?? "", style: const TextStyle(color: Colors.red))
      ],
    );
  }
}