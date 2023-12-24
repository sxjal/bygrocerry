import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bygrocerry/pages/detailPage/details_page.dart';
import 'package:bygrocerry/route/routing_page.dart';
import 'single_product.dart';

class GridViewWidget extends StatefulWidget {
  final String id;

  final String subCollection;

  const GridViewWidget({
    Key? key,
    required this.subCollection,
    required this.id,
  }) : super(key: key);

  @override
  _GridViewWidgetState createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.id)
          .collection(widget.subCollection)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshort) {
        if (!snapshort.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              // shrinkWrap: true,
              itemCount: snapshort.data!.docs.length,
              itemBuilder: (ctx, index) {
                var data = snapshort.data!.docs[index];

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
                  productDescription: data["productDescription"],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
