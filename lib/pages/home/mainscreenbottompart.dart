import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreenBottomPart extends StatefulWidget {
  const MainScreenBottomPart({Key? key}) : super(key: key);

  @override
  State<MainScreenBottomPart> createState() => MainScreenBottomPartState();
}

class MainScreenBottomPartState extends State<MainScreenBottomPart> {
  var selectedTab = 0;

  var categoryStream =
      FirebaseFirestore.instance.collection("categories").snapshots();
  //get the length of the stream

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final tabs = snapshot.data!.docs.map((doc) {
          return Tab(
            text: doc["categoryName"].toString(),
          );
        }).toList();

        final othertabs = [
          Tab(
            text: "All products",
          ),
          Tab(
            text: "Best Sells",
          ),
        ];

        tabs.insertAll(0, othertabs);

        return DefaultTabController(
          length: tabs.length + 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: TabBar(
              onTap: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Color.fromRGBO(33, 160, 86, 1),
                  width: 2.0,
                ),
              ),
              labelColor: Color.fromRGBO(
                  33, 160, 86, 1), // This is the color of the selected tab
              unselectedLabelColor: const Color.fromARGB(
                  255, 0, 0, 0), // This is the color of the unselected tab

              tabs: tabs,
            ),
            body: TabBarView(
              children: tabs.map(
                (tab) {
                  return Center(
                    child: Text(
                      tab.child.toString(),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}
