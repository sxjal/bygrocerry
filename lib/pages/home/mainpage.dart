import 'package:bygrocerry/model/user_model.dart';
import 'package:bygrocerry/pages/home/mainscreenbottompart.dart';
import 'package:bygrocerry/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.user, // Add this line to define the 'user' field
  }) : super(key: key);

  final UserModel user; // Add this line to define the 'user' field

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

  NetworkImage buildImage(imageUrl) {
    final Uri? uri = Uri.tryParse(imageUrl);

    if (uri == null || !uri.hasScheme) {
      return NetworkImage("images/user.png");
    }

    return NetworkImage(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            // fit: StackFit.passthrough,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .07,
                  left: MediaQuery.of(context).size.width * .08,
                  right: MediaQuery.of(context).size.width * .08,
                ),
                height: MediaQuery.of(context).size.height * .35,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: .1,
                    image: AssetImage(
                      "images/bgpattern.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(33, 160, 86, 1),
                      Color.fromRGBO(64, 190, 117, 1)
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome,",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color.fromARGB(255, 225, 225, 225),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Text(
                              widget.user.fullName,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.height * .1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: widget.user.imageurl == "notset"
                                  ? DecorationImage(
                                      image: AssetImage("images/user.png"),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: buildImage(widget.user
                                          .imageurl), // NetworkImage(widget.user.imageurl),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Container(
                      height: 40,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          fillColor: Color.fromARGB(139, 251, 251, 251),
                          hintText: "Search by name...",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(159, 0, 0, 0),
                          ),
                          suffixIconColor: Color.fromARGB(114, 0, 0, 0),
                          focusColor: Color.fromARGB(114, 0, 0, 0),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        cursorColor: Color.fromARGB(114, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .3,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
                      ),
                      query == ""
                          ? Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: MainScreenBottomPart(),
                              ),
                            )
                          : Text("Search Results for $query"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
