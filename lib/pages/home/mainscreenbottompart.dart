import 'package:bygrocerry/pages/detailPage/details_page.dart';
import 'package:bygrocerry/route/routing_page.dart';
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
  ScrollController _scrollController = ScrollController();
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

  Widget buildProduct({
    required Stream<QuerySnapshot<Map<String, dynamic>>>? stream,
  }) {
    return Container(
      // height: 200,
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
          if (!streamSnapshort.hasData) {
            return Center(child: const CircularProgressIndicator());
          }
          return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: streamSnapshort.data!.docs.length,
            itemBuilder: (ctx, index) {
              var varData = searchFunction(query, streamSnapshort.data!.docs);
              var data = varData[index];

              return Column(
                children: [
                  SingleProduct(
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
                          productPrice:
                              (data["productPrice"] as num).toDouble(),
                          productRate: data["productRate"],
                          productDescription: data["productDescription"],
                        ),
                      );
                    },
                    productDescription: data["productDescription"],
                    productId: data["productId"],
                    productCategory: data["productCategory"],
                    productRate: data["productRate"],
                    productOldPrice: data["productOldPrice"],
                    productPrice: data["productPrice"],
                    productImage: data["productImage"],
                    productName: data["productName"],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  index == streamSnapshort.data!.docs.length - 1
                      ? endofcategory(scrollController: _scrollController)
                      : SizedBox(),
                ],
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
                  buildProduct(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .doc(doc.id)
                        .collection(
                          doc["categoryName"].toString(),
                        )
                        .snapshots(),
                  ),
                );
              },
            )
            .values
            .toList();

        var othetabs = [
          buildProduct(
            stream: FirebaseFirestore.instance
                .collection(
                  "products",
                )
                .snapshots(),
          ),
          buildProduct(
            stream: FirebaseFirestore.instance
                .collection(
                  "products",
                )
                .where(
                  "productRate",
                  isGreaterThanOrEqualTo: 4,
                )
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
            backgroundColor: Color.fromRGBO(248, 249, 251, 1),
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

class endofcategory extends StatelessWidget {
  const endofcategory({
    Key? key,
    required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(
            "You've reached the end of this category",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 185, 185, 185),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Have any questions?"),
              TextButton(
                onPressed: () {},
                child: Text("Read our FAQs"),
              ),
              IconButton(
                onPressed: () {
                  _scrollController.animateTo(
                    0.0,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Icon(Icons.arrow_upward),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
        ],
      ),
    );
  }
}
