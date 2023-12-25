import 'package:bygrocerry/pages/home/mainscreenbottompart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bygrocerry/pages/detailPage/details_page.dart';
import 'package:bygrocerry/route/routing_page.dart';
import 'single_product.dart';

class GridViewWidget extends StatefulWidget {
  final String id;
  final String subCollection;
  final String collection;

  const GridViewWidget({
    Key? key,
    required this.collection,
    required this.subCollection,
    required this.id,
  }) : super(key: key);

  @override
  _GridViewWidgetState createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  ScrollController _scrollController = ScrollController();
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

        print("inside streambuilder");

        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              // shrinkWrap: true,
              itemCount: snapshort.data!.docs.length,
              itemBuilder: (ctx, index) {
                var data = snapshort.data!.docs[index];
                print(data['productId']);
                return Column(
                  children: [
                    SingleProduct(
                      onTap: () {},
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
                    index == snapshort.data!.docs.length - 1
                        ? endofcategory(scrollController: _scrollController)
                        : SizedBox(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
