import 'package:btp/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not, we will ask for permission first
      await Permission.storage.request();
    }

    io.Directory _directory;
    if (io.Platform.isAndroid) {
      // Redirects it to the download folder in Android
      _directory = io.Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await io.Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(Uint8List bytes, String name) async {
    final path = await _localPath;
    File file = File('$path/$name');
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsBytes(bytes);
  }
}

class NumberGridPage extends StatefulWidget {
  final Map<dynamic, dynamic> str;
  String selectedSubject;
  String selectedTerm;
  String selectedExam;
  String selectedName;
  String selectedRollNumber;

  NumberGridPage({super.key, required this.str, required this.selectedExam, required this.selectedSubject, required this.selectedTerm, required this.selectedName, required this.selectedRollNumber});

  @override
  _NumberGridPageState createState() => _NumberGridPageState();
}

class _NumberGridPageState extends State<NumberGridPage> {
  void _showSuccessMessageAndNavigate() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Successful'),
          content: Text('Excel is successfully downloaded in the downloads folder of phone'),
            actions: <Widget>[
            TextButton(
            onPressed: () {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 5);
            },
            child: Text('OK'),
        ),
        ]
        );
      },
    );



    // Navigate to the home page

  }

  void addToExcel() {
    final xcel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).setText("S. No.");
    sheet.getRangeByIndex(1, 2).setText("Name");
    sheet.getRangeByIndex(1, 3).setText("Roll Number");

    for (var i = 1; i < 11; i++) {
      sheet.getRangeByIndex(1, i + 3).setText('Q $i');
    }
    sheet.getRangeByIndex(1, 14).setText("Total Marks");

    sheet.getRangeByIndex(2, 1).setText("1.");
    sheet.getRangeByIndex(2, 2).setText(widget.selectedName);
    sheet.getRangeByIndex(2, 3).setText(widget.selectedRollNumber);
    for (var i = 4; i < 15; i++) {
      sheet.getRangeByIndex(2, i).setText(controllers[i - 4].text.toString());
    }
  }

  void saveExcel() async {
    final List<int> bytes = workbook.saveAsStream();
    Uint8List uint8list = Uint8List.fromList(bytes);

    // Save the file
    await FileStorage.writeCounter(uint8list, "${widget.selectedSubject}_${widget.selectedTerm}_${widget.selectedExam}.xlsx");
    workbook.dispose();

    // Show success message and navigate after saving
    _showSuccessMessageAndNavigate();
  }

  xcel.Workbook workbook = xcel.Workbook();

  final List<TextEditingController> controllers = List.generate(11, (index) => TextEditingController());

  List<String> textshown = ['Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6', 'Q7', 'Q8', 'Q9', 'Q10', 'Total Marks'];

  @override
  void initState() {
    super.initState();
    print(widget.str);
    // for (var i = 0; i < 11; i++) {
    //   if (!widget.str.containsKey('${i + 1}')) {
    //     controllers[i].text = '0';
    //   } else {
    //     controllers[i].text = widget.str['${i+1}'].toString();
    //   }
    // }
    var tr = 0;
    for(var i = 1; i < widget.str.length - 1; i++){
      controllers[i-1].text = widget.str['$i'].toString();
      tr++;
    }
    for(var i = tr; i<10; i++){
      controllers[i].text = '0';
    }
    controllers[10].text = widget.str['${tr+1}'].toString();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23,
        ),
        title: Text('Confirm Marks'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Color(0xff131621),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [Colors.blue, Colors.black],
        //   ),
        // ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(11, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 140,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          textshown[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 140,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: TextFormField(

                        textAlign: TextAlign.center,
                        controller: controllers[index],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xff131621),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              addToExcel();
              saveExcel();
            },
            child: Text(
              'Add to Excel',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
