import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bygrocerry/pages/home/home_page.dart';
import 'package:bygrocerry/route/routing_page.dart';

class LoginAuthProvider with ChangeNotifier {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(LoginAuthProvider.pattern.toString());

  bool loading = false;

  UserCredential? userCredential;

  void loginPageVaidation({
    required TextEditingController? emailAdress,
    required TextEditingController? password,
    required BuildContext context,
  }) async {
    if (emailAdress!.text.trim().isEmpty) {
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
                "Please enter an email address",
                style: TextStyle(color: Colors.white), // Change the text color
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating, // Make the SnackBar floating
          margin: EdgeInsets.only(
            bottom: 20,
            left: 50,
            right: 50,
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
                "Invalid email address",
                style: TextStyle(color: Colors.white), // Change the text color
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating, // Make the SnackBar floating
          margin: EdgeInsets.only(
            bottom: 20,
            left: 100,
            right: 100,
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
                "Please enter a valid password",
                style: TextStyle(color: Colors.white), // Change the text color
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating, // Make the SnackBar floating
          margin: EdgeInsets.only(
            bottom: 20,
            left: 50,
            right: 50,
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

        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailAdress.text,
          password: password.text,
        )
            .then(
          (value) async {
            loading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                //duration
                duration: Duration(seconds: 2),
                backgroundColor: Color.fromARGB(
                    255, 12, 194, 121), // Change the background color
                clipBehavior: Clip.antiAliasWithSaveLayer,
                dismissDirection: DismissDirection.horizontal,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(50), // Add rounded corners
                ),
                content: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                    child: Text(
                      "Login Successfull",
                      style: TextStyle(
                          color: Colors.white), // Change the text color
                    ),
                  ),
                ),
                behavior:
                    SnackBarBehavior.floating, // Make the SnackBar floating
                margin: EdgeInsets.only(
                  bottom: 20,
                  left: 20,
                  right: 20,
                ), // Add margin
                // Add padding
              ),
            );
            notifyListeners();
            await RoutingPage.goTonext(
              context: context,
              navigateTo: HomePage(),
            );
            return null;
          },
        );
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        print("inside catch");
        loading = false;
        notifyListeners();
        print(e.code);

        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color.fromARGB(
                  255, 176, 66, 20), // Change the background color
              clipBehavior: Clip.antiAliasWithSaveLayer,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Add rounded corners
              ),
              content: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    "User not found",
                    style:
                        TextStyle(color: Colors.white), // Change the text color
                  ),
                ),
              ),
              behavior: SnackBarBehavior.floating, // Make the SnackBar floating
              margin: EdgeInsets.only(
                bottom: 20,
                left: 80,
                right: 80,
              ), // Add margin
              // Add padding
            ),
          );
        } else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color.fromARGB(
                  255, 176, 66, 20), // Change the background color
              clipBehavior: Clip.antiAliasWithSaveLayer,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Add rounded corners
              ),
              content: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    "Invalid email address or Password",
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
        } else if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color.fromARGB(
                  255, 176, 66, 20), // Change the background color
              clipBehavior: Clip.antiAliasWithSaveLayer,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Add rounded corners
              ),
              content: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    "Invalid email address or Password",
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
