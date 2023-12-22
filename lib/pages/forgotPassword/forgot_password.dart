import 'package:bygrocerry/pages/signup/signup_page.dart';
import 'package:bygrocerry/route/routing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bygrocerry/widgets/my_button.dart';
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
                              fontSize: 56,
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
                                "A world of",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 227, 223, 223),
                                  fontSize: 36,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: const Text(
                                "possibility in",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 227, 223, 223),
                                  fontSize: 36,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: const Text(
                                "an app",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 227, 223, 223),
                                  fontSize: 36,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.045,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.10),
                    //  child: loginAuthProvider.loading == true
                    child: false
                        ? CircularProgressIndicator(
                            color: Color.fromARGB(255, 251, 251, 251),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text)
                                  .whenComplete(
                                    () => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "You'll receive an email shortly if an account exists with the email you entered.",
                                        ),
                                      ),
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 0),
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
                                    "log me in",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 60, 119, 121),
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
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "First time at Heavens Mart?",
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
                            "Sign up",
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
