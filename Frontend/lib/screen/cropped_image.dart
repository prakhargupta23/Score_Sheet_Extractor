import 'dart:convert';

import 'package:btp/models/button.dart';
import 'package:btp/screen/marks_recheck.dart';
import 'package:flutter/material.dart';

class Cropped extends StatefulWidget {
  final Map<dynamic, dynamic> str;
  String selectedSubject;
  String selectedTerm;
  String selectedExam;
  String selectedName;
  String selectedRollNumber;
  Cropped({super.key, required this.str, required this.selectedExam, required this.selectedSubject, required this.selectedTerm, required this.selectedName, required this.selectedRollNumber});

  @override
  State<Cropped> createState() => _CroppedState();
}

class _CroppedState extends State<Cropped> {

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    return Scaffold(

      // appBar: AppBar(
      //   elevation: 1.7,
      //   shadowColor: Colors.black12,
      //   backgroundColor: Colors.transparent,
      //   leadingWidth: 40,
      //   // leading: Container(
      //   //   height: 80.0,
      //   //   width: 80.0,
      //   //   margin: const EdgeInsets.only(right: 20, top: 10, bottom: 5),
      //   //   decoration: BoxDecoration(
      //   //     color: Colors.blue,
      //   //     boxShadow: [
      //   //       BoxShadow(
      //   //         color: Colors.blue.withOpacity(0.5),
      //   //         blurRadius: 10,
      //   //         offset: const Offset(0, 0),
      //   //       ),
      //   //     ],
      //   //     borderRadius: BorderRadius.circular(14.0),
      //   //     image: const DecorationImage(
      //   //       image: AssetImage('assets/images/pro.png'),
      //   //     ),
      //   //   ),
      //   // ),
      // ),
      backgroundColor: Color(0xff131621),
      body: Center(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Image.memory(base64Decode(widget.str['image'])),
              ),
              SizedBox(height: 14,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(value: 'Retake Image', function: (){
                    Navigator.pop(context);
                  }),
                  Button(value: 'Next', function: (){
                    //print(widget.str);
                    // for(var i = 0; i<11; i++){
                    //   print('Value- ');
                    //   print(widget.str['$i']);
                    // }
                    // print('12');

                    Navigator.push(context, MaterialPageRoute(builder: (context) => NumberGridPage(str: widget.str, selectedExam: widget.selectedExam, selectedSubject: widget.selectedSubject, selectedTerm: widget.selectedTerm, selectedName: widget.selectedName, selectedRollNumber: widget.selectedRollNumber), settings: RouteSettings(
                      arguments: data,
                    )));
                  }),
                ],
              ),



            ],
          ),
      ),
    );
  }
}
