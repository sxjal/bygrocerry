import 'package:bygrocerry/pages/forgotPassword/forgot_password.dart';
import 'package:bygrocerry/pages/signup/signup_page.dart';
import 'package:bygrocerry/route/routing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bygrocerry/pages/login/components/login_auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode _passwordFocusNode = FocusNode();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    LoginAuthProvider loginAuthProvider =
        Provider.of<LoginAuthProvider>(context);
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
                            "Sign in",
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
                          TextFormField(
                            focusNode: _passwordFocusNode,
                            controller: password,
                            autocorrect: false,
                            obscureText: !_passwordVisible,
                            style: const TextStyle(color: Colors.white),
                            cursorColor:
                                const Color.fromARGB(255, 197, 197, 197),
                            decoration: InputDecoration(
                              label: Text(
                                "Password",
                                style: TextStyle(
                                    color: Color.fromARGB(93, 255, 255, 255)),
                              ),
                              border: InputBorder.none,
                              suffixIcon: _passwordFocusNode.hasFocus
                                  ? IconButton(
                                      // Add this line
                                      icon: Icon(
                                        // Choose the icon based on password visibility
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: const Color.fromARGB(
                                            255, 160, 160, 160),
                                      ),
                                      onPressed: () {
                                        // Update the state i.e., toggle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    )
                                  : null,
                            ),
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
                    child: loginAuthProvider.loading == true
                        ? CircularProgressIndicator(
                            color: Color.fromARGB(255, 251, 251, 251),
                          )
                        : GestureDetector(
                            onTap: () {
                              print(email.text);
                              print(password.text);
                              loginAuthProvider.loginPageVaidation(
                                emailAdress: email,
                                password: password,
                                context: context,
                              );
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.10),
                    child: TextButton(
                      onPressed: () {
                        RoutingPage.goTonext(
                          context: context,
                          navigateTo: ForgotPassword(),
                        );
                      },
                      child: Text(
                        "Forgot Password",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 202, 202, 202),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
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
                          "First time at Havens Mart?",
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
