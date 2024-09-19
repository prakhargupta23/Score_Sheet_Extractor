import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  String labelText;
  var controller;
  final Function callback;
  TextInputType keyboardtype;
  InputText({required this.callback, required this.labelText, required this.keyboardtype ,required this.controller,super.key});

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardtype,
        onChanged: (value){
          widget.callback(widget.controller);
        },
        decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )
        ),
      ),
    );
  }
}
