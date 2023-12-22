import 'package:bygrocerry/pages/login/login_page.dart';
import 'package:bygrocerry/pages/signup/signup_page.dart';
import 'package:bygrocerry/route/routing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //           TextFormField(
    //             keyboardType: TextInputType.emailAddress,
    //             decoration: InputDecoration(hintText: "Email"),
    //             onChanged: (value) {
    //               setState(() {
    //                 email = value.trim();
    //               });
    //             },
    //           ),
    //           SizedBox(
    //             height: 20,
    //           ),
    //           MyButton(
    // onPressed:
    //             text: "Send Request",
    //           )
    //         ],
    //       ),
    //     ),
    //   );
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 21, 50, 59),
                Color.fromARGB(255, 60, 119, 121),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Container(
                    margin: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.08),
                    child: Row(
                      children: [
                        const RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: const Text(
                                "Resetting your password",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 227, 223, 223),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: const Text(
                                "is as simple as a",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 227, 223, 223),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: const Text(
                                "click away",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 227, 223, 223),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.2,
                      right: MediaQuery.of(context).size.width * 0.2,
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: email,
                            autocorrect: false,
                            style: const TextStyle(color: Colors.white),
                            cursorColor:
                                const Color.fromARGB(255, 197, 197, 197),
                            decoration: const InputDecoration(
                              label: Text(
                                "Email",
                                style: TextStyle(
                                    color: Color.fromARGB(93, 255, 255, 255)),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.10),
                    //  child: loginAuthProvider.loading == true
                    child: GestureDetector(
                      onTap: () async {
                        if (email.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color.fromARGB(255, 176, 66,
                                  20), // Change the background color
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              dismissDirection: DismissDirection.horizontal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50), // Add rounded corners
                              ),
                              content: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Text(
                                    "Please enter an email address",
                                    style: TextStyle(
                                        color: Colors
                                            .white), // Change the text color
                                  ),
                                ),
                              ),
                              behavior: SnackBarBehavior
                                  .floating, // Make the SnackBar floating
                              margin: EdgeInsets.only(
                                bottom: 20,
                                left: 50,
                                right: 50,
                              ), // Add margin
                              // Add padding
                            ),
                          );
                          return;
                        }
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text)
                            .whenComplete(
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Color.fromARGB(255, 14, 183,
                                    95), // Change the background color
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                dismissDirection: DismissDirection.horizontal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Add rounded corners
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Center(
                                    child: Text(
                                      "You'll receive an email shortly if an account exists with the email you've entered.",
                                      style: TextStyle(color: Colors.white),
                                      // Change the text color
                                    ),
                                  ),
                                ),
                                behavior: SnackBarBehavior
                                    .floating, // Make the SnackBar floating
                                margin: EdgeInsets.only(
                                  bottom: 20,
                                  left: 50,
                                  right: 50,
                                ), // Add margin
                                // Add padding
                              ),
                            );
                            RoutingPage.goTonext(
                              context: context,
                              navigateTo: LoginPage(),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 5,
                          left: 20,
                          right: 20,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Reset Password",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 60, 119, 121),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_sharp,
                              color: Color.fromARGB(255, 60, 119, 121),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Remember your password?",
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(96, 255, 255, 255),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            RoutingPage.goTonext(
                              context: context,
                              navigateTo: SignupPage(),
                            );
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(203, 255, 255, 255),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
