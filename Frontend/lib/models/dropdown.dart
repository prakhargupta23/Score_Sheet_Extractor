import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  CustomDropdown({required this.callback, required this.label,required this.selected ,required this.terms, super.key});
  List<String> terms;
  String selected ;
  String label;
  final Function callback;
  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          DropdownButton<String>(
            value: widget.selected,
            onChanged: (String? newValue) {
                setState(() {
                  widget.selected = newValue!;
                  widget.callback(newValue);
                });

            },
            items: widget.terms.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
