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
            child: Container(
              height: 20,
              width: 40,
              color: Colors.black,
              child: Text(
                doc["categoryName"].toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList();

        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: TabBar(
              onTap: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
              isScrollable: true,
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
