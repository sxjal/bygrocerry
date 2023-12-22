import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bygrocerry/pages/home/home_page.dart';
import 'package:bygrocerry/route/routing_page.dart';

class SignupAuthProvider with ChangeNotifier {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(SignupAuthProvider.pattern.toString());
  UserCredential? userCredential;

  bool loading = false;

  void signupVaidation(
      {required TextEditingController? fullName,
      required TextEditingController? emailAdress,
      required TextEditingController? password,
      required BuildContext context}) async {
    if (fullName!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              Color.fromARGB(255, 176, 66, 20), // Change the background color
          clipBehavior: Clip.antiAliasWithSaveLayer,
          dismissDirection: DismissDirection.horizontal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Add rounded corners
          ),
          content: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Text(
                "Name cannot be empty",
                style: TextStyle(color: Colors.white), // Change the text color
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating, // Make the SnackBar floating
          margin: EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ), // Add margin
          // Add padding
        ),
      );
      return;
    } else if (emailAdress!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              Color.fromARGB(255, 176, 66, 20), // Change the background color
          clipBehavior: Clip.antiAliasWithSaveLayer,
          dismissDirection: DismissDirection.horizontal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Add rounded corners
          ),
          content: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Text(
                "Please enter an Email Address",
                style: TextStyle(color: Colors.white), // Change the text color
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating, // Make the SnackBar floating
          margin: EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ), // Add margin
          // Add padding
        ),
      );
      return;
    } else if (!regExp.hasMatch(emailAdress.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              Color.fromARGB(255, 176, 66, 20), // Change the background color
          clipBehavior: Clip.antiAliasWithSaveLayer,
          dismissDirection: DismissDirection.horizontal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Add rounded corners
          ),
          content: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Text(
                "Invalid Email Address",
                style: TextStyle(color: Colors.white), // Change the text color
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating, // Make the SnackBar floating
          margin: EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ), // Add margin
          // Add padding
        ),
      );
      return;
    } else if (password!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              Color.fromARGB(255, 176, 66, 20), // Change the background color
          clipBehavior: Clip.antiAliasWithSaveLayer,
          dismissDirection: DismissDirection.horizontal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Add rounded corners
          ),
          content: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Text(
                "Password cannot be empty",
                style: TextStyle(color: Colors.white), // Change the text color
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating, // Make the SnackBar floating
          margin: EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ), // Add margin
          // Add padding
        ),
      );
      return;
    } else if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              Color.fromARGB(255, 176, 66, 20), // Change the background color
          clipBehavior: Clip.antiAliasWithSaveLayer,
          dismissDirection: DismissDirection.horizontal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Add rounded corners
          ),
          content: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Text(
                "Password must be atleast 8 characters long",
                style: TextStyle(color: Colors.white), // Change the text color
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating, // Make the SnackBar floating
          margin: EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ), // Add margin
          // Add padding
        ),
      );
      return;
    } else {
      try {
        loading = true;
        notifyListeners();
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAdress.text,
          password: password.text,
        );
        loading = true;
        notifyListeners();

        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential!.user!.uid)
            .set(
          {
            "fullName": fullName.text,
            "emailAdress": emailAdress.text,
            "password": password.text,
            "userUid": userCredential!.user!.uid,
          },
        ).then((value) {
          loading = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Color.fromARGB(
                  255, 12, 194, 121), // Change the background color
              clipBehavior: Clip.antiAliasWithSaveLayer,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Add rounded corners
              ),
              content: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    "Welcome to Heavens Mart!",
                    style:
                        TextStyle(color: Colors.white), // Change the text color
                  ),
                ),
              ),
              behavior: SnackBarBehavior.floating, // Make the SnackBar floating
              margin: EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
              ), // Add margin
              // Add padding
            ),
          );
          RoutingPage.goTonext(
            context: context,
            navigateTo: HomePage(),
          );
        });
      } on FirebaseAuthException catch (e) {
        loading = false;
        notifyListeners();
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color.fromARGB(
                  255, 9, 98, 181), // Change the background color
              clipBehavior: Clip.antiAliasWithSaveLayer,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Add rounded corners
              ),
              content: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    "Password too weak",
                    style:
                        TextStyle(color: Colors.white), // Change the text color
                  ),
                ),
              ),
              behavior: SnackBarBehavior.floating, // Make the SnackBar floating
              margin: EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
              ), // Add margin
              // Add padding
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color.fromARGB(
                  255, 10, 128, 161), // Change the background color
              clipBehavior: Clip.antiAliasWithSaveLayer,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Add rounded corners
              ),
              content: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    "Email is already in use with other user.",
                    style:
                        TextStyle(color: Colors.white), // Change the text color
                  ),
                ),
              ),
              behavior: SnackBarBehavior.floating, // Make the SnackBar floating
              margin: EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
              ), // Add margin
              // Add padding
            ),
          );
        }
      }
    }
  }
}
