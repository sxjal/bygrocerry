import 'package:bygrocerry/widgets/grid_view_widget.dart';
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

  var productStream =
      FirebaseFirestore.instance.collection("products").snapshots();
  //get the length of the stream
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

  Widget buildCategory({
    required String categoryName,
    required String categoryId,
  }) {
    print("categoryName $categoryName");
    print("categoryId $categoryId");

    return Expanded(
      child: Container(
        width: 300,
        height: 200,
        child: GridViewWidget(
          subCollection: categoryName,
          collection: "categories",
          id: categoryId,
        ),
        // width: 300,
        //height: 200, //MediaQuery.of(context).size.height,
        // child: StreamBuilder(
        //   stream:
        //       FirebaseFirestore.instance.collection("categories").snapshots(),
        //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
        //     if (!streamSnapshort.hasData) {
        //       return Center(child: const CircularProgressIndicator());
        //     }
        //     print("inside streambuilder");
        //     return ListView.builder(
        //       scrollDirection: Axis.vertical,
        //       physics: BouncingScrollPhysics(),
        //       itemCount: streamSnapshort.data!.docs.length,
        //       itemBuilder: (ctx, index) {
        //         print("prinintg streamsnapshot categoryname");
        //         print(categoryName);
        //         print(streamSnapshort.data!.docs[index].id);
        //         return GridViewWidget(
        //           subCollection: categoryName,
        //           collection: "categories",
        //           id: streamSnapshort.data!.docs[index].id,
        //         );
        //       },
        //     );
        //   },
        // ),
      ),
    );
  }

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

        final tabs = snapshot.data!.docs
            .asMap()
            .map((index, doc) {
              return MapEntry(
                  index,
                  Tab(
                    child: Text(
                      doc["categoryName"].toString(),
                    ),
                  ));
            })
            .values
            .toList();
        var othertabs = [
          Tab(
            text: "All products",
          ),
          Tab(
            text: "Best Sells",
          ),
        ];

        tabs.insertAll(0, othertabs);

        final categoriesSpecific = snapshot.data!.docs
            .asMap()
            .map(
              (index, doc) {
                return MapEntry(
                  index,
                  buildCategory(
                    categoryName: doc["categoryName"].toString(),
                    //fetch the document id of this category

                    categoryId: doc["categoryId"].toString(),
                  ),
                );
              },
            )
            .values
            .toList();

        var othetabs = [
          Text(
            "All products",
          ),
          Text(
            "BestSells",
          ),
        ];
        categoriesSpecific.insertAll(0, othetabs);

        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: TabBar(
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
              children: categoriesSpecific,
            ),
          ),
        );
      },
    );
  }
}
