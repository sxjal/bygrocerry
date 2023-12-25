import 'package:bygrocerry/model/user_model.dart';
import 'package:bygrocerry/pages/home/mainscreenbottompart.dart';
// import 'package:bygrocerry/widgets/grid_view_widget.dart';
import 'package:bygrocerry/widgets/single_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:bygrocerry/widgets/grid_view_widget.dart';

class FavoritePage extends StatefulWidget {
  final UserModel user;
  const FavoritePage({Key? key, required this.user}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(64, 190, 117, 1),
        title: Text("Favorites"),
        leading: Icon(
          Icons.favorite,
          color: Color.fromARGB(255, 222, 61, 61),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("favorite")
            .doc(widget.user.userUid)
            .collection("userFavorite")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshort) {
          if (!snapshort.hasData) {
            return Center(
              child: Text("No data"),
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
      ),
    );
  }
}
