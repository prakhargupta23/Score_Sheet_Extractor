
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  Function function;
  String value;
  Button({required this.value, required this.function, super.key});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      ElevatedButton(
          onPressed: (){
            widget.function();
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Set the border radius here
              ),
            ),
            backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff1F75FE)),
          ),
          child: Text(
            widget.value,
            style: const TextStyle(
              // fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
            ),
          )
      ),
    );

  }
}

