import 'dart:ui';
import 'package:btp/screen/common_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.auth}) : super(key: key);
  final FirebaseAuth auth;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> _photoUrlFuture;

  @override
  void initState() {
    super.initState();
    _photoUrlFuture = _getUserPhotoUrl();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _photoUrlFuture,
      builder: (context, snapshot) {
        Widget leadingWidget;
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          leadingWidget = CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!),
          );
        } else {
          leadingWidget = Image.asset(
            'assets/images/avatar.png',
            color: null, // No color change to the existing avatar icon
          ); // Placeholder widget
        }

        return Container(
          child: Scaffold(
            // backgroundColor: Color(0xff131621),
            // Set the desired background color
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // elevation: 2,
              shadowColor: Colors.black12,
              backgroundColor: Color(0xff091254),
              leadingWidth: 40,
              leading: Container(), // Remove the existing leading
              actions: [
                // SizedBox(width: 10), // Add some spacing
                leadingWidget, // Display the user's profile photo
                SizedBox(width: 10), // Add some spacing
              ],
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              // color: Colors.blue,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
                  radius: 1.5,
                ),
              ),
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [Colors.blue, Color(0xff0001AD)],
              //   ),
              // ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 60,),
                    Center(child: _buildCard(context, 'assets/images/excel.jpg', 'Create New Excel Sheet', 1)),
                    SizedBox(height: 25,),
                    Center(child: _buildCard(context, 'assets/images/excel.jpg', 'Update existing Excel Sheet', 2)),
                    //_buildCard(context, 'assets/images/ex2.png', 'Create Excel Sheet'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, String path, String cardData, int i) {
    return GestureDetector(
      onTap: () {
        if (i == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsPage()),
          );
        } else {
          _showErrorDialog();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.25, // Height set to 25% of screen height
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ), // Applying blur effect
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3), // Greyish tint with opacity
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    path,
                    // fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        cardData,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<String?> _getUserPhotoUrl() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.photoURL;
    }
    return null;
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('To be added'),
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
}
