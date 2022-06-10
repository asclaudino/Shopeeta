import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.color,
      required this.textColor});
  final Function onPressed;
  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ]),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text,
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: textColor)),
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
        onTap: () {
          onPressed();
        },
      ),
    );
  }
}
