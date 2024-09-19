import 'dart:core';
import 'package:flutter/material.dart';
import 'package:btp/screen/students_details_page.dart';

class DetailsPage extends StatefulWidget {
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController textController = TextEditingController();

  String dropdownValue1 = '2023-24 II';
  String dropdownValue2 = 'Mid-term';
  String selectedSubject = '';
  List<String> termList = ['2023-24 I', '2023-24 II'];

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please enter a subject.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Exam Details'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // color: Color(0xff131621),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
            radius: 1.5,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            'Term:',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          DropdownButton<String>(
                            value: dropdownValue1,
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  dropdownValue1 = newValue;
                                }
                              });
                            },
                            dropdownColor: Colors.blue,
                            style: TextStyle(color: Colors.white),
                            items: termList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            'Exam:',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          DropdownButton<String>(
                            value: dropdownValue2,
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  dropdownValue2 = newValue;
                                }
                              });
                            },
                            dropdownColor: Colors.blue,
                            style: TextStyle(color: Colors.white),
                            items: <String>['Mid-term', 'Endterm']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedSubject = textController.text.toString();
                      });
                      if (textController.text.trim().isEmpty) {
                        _showErrorDialog();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentPersonalDetailsPage(
                                  selectedExam: dropdownValue2,
                                  selectedSubject: selectedSubject,
                                  selectedTerm: dropdownValue1)),
                        );
                      }
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
