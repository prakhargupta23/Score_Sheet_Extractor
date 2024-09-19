import 'dart:convert';
import 'dart:io';
import 'package:btp/models/button.dart';
import 'package:btp/models/textfield.dart';
import 'package:btp/screen/cropped_image.dart';
import 'package:btp/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StudentPersonalDetailsPage extends StatefulWidget {

  String selectedSubject;
  String selectedTerm;
  String selectedExam;

  StudentPersonalDetailsPage({required this.selectedExam, required this.selectedSubject, required this.selectedTerm, super.key});

  @override
  State<StudentPersonalDetailsPage> createState() => _StudentPersonalDetailsPageState();
}

class _StudentPersonalDetailsPageState extends State<StudentPersonalDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  String selectedName = '';
  String selectedRollNumber = '';
  late File selected_image;
  bool _loading = false;
  var image;
  late Map<dynamic, dynamic> respond;

  Future pickImagefromCamera() async {
    final returnedimage = await ImagePicker().pickImage(source: ImageSource.camera);
    selected_image = File(returnedimage!.path);
    String base64Image = base64Encode(selected_image.readAsBytesSync());
    setState(() {
      _loading = true;
    });
    String url = 'http://192.168.1.4:5000';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'image': base64Image,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    final Map<dynamic, dynamic> data = json.decode(response.body);

    // print(data);
    // print('StatusCode : ${response.statusCode}');
    // print('Return Data : ${response.body}');
    setState(() {
      respond = data;
    });
    print(respond);
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please fill all the fields'),
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
        title: Text('Student Details'),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Colors.black87,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23
        ),
      ),
      body: Container(
        // color: Color(0xff131621),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
            radius: 1.5,
          ),
        ),
        child: Center(
          child: _loading ? Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ) :Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                SizedBox(height: 20.0),
                TextFormField(
                  controller: rollNoController,
                  decoration: InputDecoration(
                    labelText: 'Roll No',
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
                SizedBox(height: 20.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    if(nameController.text.trim().isEmpty || rollNoController.text.trim().isEmpty){
                      _showErrorDialog();
                    }
                    else{
                      await pickImagefromCamera();
                      setState(() {
                        _loading = false;
                        selectedRollNumber = rollNoController.text.toString();
                        selectedName = nameController.text.toString();
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute( builder: (context) => Cropped(str: respond, selectedExam: widget.selectedExam, selectedSubject: widget.selectedSubject, selectedTerm: widget.selectedTerm, selectedName: selectedName, selectedRollNumber: selectedRollNumber),
                              settings: RouteSettings(
                                arguments: respond,
                              )

                          ));
                    }

                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Take Photo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
