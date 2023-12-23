import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bygrocerry/pages/detailPage/details_page.dart';
import 'package:bygrocerry/route/routing_page.dart';
import 'single_product.dart';

class GridViewWidget extends StatefulWidget {
  final String id;
  final String collection;
  final String subCollection;

  const GridViewWidget({
    Key? key,
    required this.subCollection,
    required this.id,
    required this.collection,
  }) : super(key: key);

  @override
  _GridViewWidgetState createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(widget.collection)
          .doc(widget.id)
          .collection(widget.subCollection)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshort) {
        if (!snapshort.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var varData = searchFunction(query, snapshort.data!.docs);
        return GridView.builder(
          shrinkWrap: true,
          itemCount: result.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (ctx, index) {
            var data = varData[index];
            return SingleProduct(
              onTap: () {
                RoutingPage.goTonext(
                  context: context,
                  navigateTo: DetailsPage(
                    productCategory: data["productCategory"],
                    productId: data["productId"],
                    productImage: data["productImage"],
                    productName: data["productName"],
                    productOldPrice: data["productOldPrice"],
                    productPrice: data["productPrice"],
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
    );
  }
}
