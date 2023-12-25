// import 'package:firebase_auth/firebase_auth.dart';
import 'package:bygrocerry/model/user_model.dart';
import 'package:flutter/material.dart';
// import 'package:bygrocerry/widgets/grid_view_widget.dart';

class FavoritePage extends StatelessWidget {
  final UserModel user;
  const FavoritePage({Key? key, required UserModel this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(64, 190, 117, 1),
        title: Text("Favorites"),
        leading: Icon(
          Icons.favorite,
          color: Colors.white70,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
                    if (!streamSnapshort.hasData) {
                      return Center(
                        child: const CircularProgressIndicator(),
                      );
                    }
                    var varData =
                        searchFunction(query, streamSnapshort.data!.docs);
                    return result.isEmpty
                        ? Center(child: Text("Not Found"))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: result.length,
                            itemBuilder: (ctx, index) {
                              var data = varData[index];
                              return SingleProduct(
                                onTap: () {},
                                productDescription: data["productDescription"],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
