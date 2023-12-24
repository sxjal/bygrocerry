import 'package:bygrocerry/pages/detailPage/details_page.dart';
import 'package:bygrocerry/route/routing_page.dart';
import 'package:bygrocerry/widgets/grid_view_widget.dart';
import 'package:bygrocerry/widgets/single_product.dart';
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
    return Container(
      width: 300,
      height: 200,
      child: GridViewWidget(
        subCollection: categoryName,
        id: categoryId,
      ),
    );
  }

  Widget buildProduct(
      {required Stream<QuerySnapshot<Map<String, dynamic>>>? stream}) {
    return Container(
      height: 200,
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
          if (!streamSnapshort.hasData) {
            return Center(child: const CircularProgressIndicator());
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: streamSnapshort.data!.docs.length,
            itemBuilder: (ctx, index) {
              var varData = searchFunction(query, streamSnapshort.data!.docs);
              var data = varData[index];
              // var data = streamSnapshort.data!.docs[index];
              return SingleProduct(
                onTap: () {
                  RoutingPage.goTonext(
                    context: context,
                    navigateTo: DetailsPage(
                      productCategory: data["productCategory"],
                      productId: data["productId"],
                      productImage: data["productImage"],
                      productName: data["productName"],
                      productOldPrice:
                          (data["productOldPrice"] as num).toDouble(),
                      productPrice: (data["productPrice"] as num).toDouble(),
                      productRate: data["productRate"],
                      productDescription: data["productDescription"],
                    ),
                  );
                },
                productId: data["productId"],
                productCategory: data["productCategory"],
                productRate: data["productRate"],
                productOldPrice: data["productOldPrice"],
                productPrice: data["productPrice"],
                productImage: data["productImage"],
                productName: data["productName"],
              );
            },
          );
        },
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
                    categoryId: doc.id, //doc["categoryId"].toString(),
                  ),
                );
              },
            )
            .values
            .toList();

        var othetabs = [
          buildProduct(
            stream:
                FirebaseFirestore.instance.collection("products").snapshots(),
          ),
          buildProduct(
            stream: FirebaseFirestore.instance
                .collection("products")
                .where("productRate", isGreaterThan: 4)
                .orderBy(
                  "productRate",
                  descending: true,
                )
                .snapshots(),
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
