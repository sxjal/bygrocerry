import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String query = "";
  var result;

  searchFunction(query, searchList) {
    result = searchList.where((element) {
      return element["productName"].toUpperCase().contains(query) ||
          element["productName"].toLowerCase().contains(query) ||
          element["productName"].toUpperCase().contains(query) &&
              element["productName"].toLowerCase().contains(query);
    }).toList();
    return result;
  }

  Future<String> getUserName(String userId) async {
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (doc.exists) {
      print((doc.data() as Map<String, dynamic>)['fullName'].toString());
      return (doc.data() as Map<String, dynamic>)['fullName'];
      // Replace 'name' with the field name in your Firestore
    } else {
      throw Exception('User does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          // fit: StackFit.passthrough,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .35,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   opacity: 0.5,
                //   image: AssetImage(
                //     "images/bgpattern.png",
                //   ),
                //   fit: BoxFit.cover,
                // ),
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(20),
                // ),
                color: Color.fromRGBO(53, 184, 108, 1),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 82, 82, 82),
                            ),
                          ),
                          Text(
                            getUserName(currentUser!.uid).toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 82, 82, 82),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        child: Text("photo"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .30,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 174, 87, 87),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                  ),
                ),
                //child: Text("photo"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
