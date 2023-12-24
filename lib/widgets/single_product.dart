// import 'package:bygrocerry/pages/checkout/checkout.dart';
// import 'package:bygrocerry/pages/provider/cart_provider.dart';
// import 'package:bygrocerry/pages/provider/favorite_provider.dart';
// import 'package:bygrocerry/route/routing_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:bygrocerry/pages/provider/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import 'package:bygrocerry/pages/provider/favorite_provider.dart';

class SingleProduct extends StatefulWidget {
  final productId;
  final productCategory;
  final productRate;
  final productOldPrice;
  final productPrice;
  final productImage;
  final productName;
  final productDescription;
  final Function()? onTap;
  const SingleProduct({
    Key? key,
    required this.onTap,
    required this.productId,
    required this.productCategory,
    required this.productRate,
    required this.productOldPrice,
    required this.productPrice,
    required this.productImage,
    required this.productName,
    required this.productDescription,
  }) : super(key: key);

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool cartAdded = false;
  bool isFavorite = false;

  Widget buildimage() {
    final Uri? uri = Uri.tryParse(widget.productImage);

    if (uri == null || !uri.hasScheme) {
      return Text('Invalid URL');
    }

    return Image.network(widget.productImage);
  }

  @override
  Widget build(BuildContext context) {
    // FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    // FirebaseFirestore.instance
    //     .collection("favorite")
    //     .doc(FirebaseAuth.instance.currentUser?.uid)
    //     .collection("userFavorite")
    //     .doc(widget.productId)
    //     .get()
    //     .then(
    //       (value) => {
    //         if (this.mounted)
    //           {
    //             if (value.exists)
    //               {
    //                 setState(() {
    //                   isFavorite = value.get("productFavorite");
    //                 }),
    //               }
    //           }
    //       },
    //     );

    CartProvider cartProvider = Provider.of<CartProvider>(context);
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("userCart")
        .doc(widget.productId)
        .get()
        .then(
          (value) => {
            if (this.mounted)
              {
                if (value.exists)
                  {
                    setState(() {
                      cartAdded = true;
                    }),
                  }
              }
          },
        );

    return Container(
      width: double.infinity,
      //  height: MediaQuery.of(context).size.height * .20,
      margin: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 5.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 15.0,
      ),

      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          //contains the image

          SizedBox(
            width: MediaQuery.of(context).size.width * .01,
          ),
          //contains the name, category and price
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.productName,
                  //  maxLines: 1,
                  softWrap: true,
                  //  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.productCategory,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "\₹ ${widget.productPrice}",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromRGBO(64, 175, 110, 1)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    widget.productOldPrice != widget.productPrice
                        ? Text(
                            "\₹ ${widget.productOldPrice}   ",
                            style: GoogleFonts.poppins(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color.fromRGBO(95, 95, 95, 1)),
                          )
                        : Text(""),
                  ],
                ),
                Text(
                  widget
                      .productDescription, //   "nothing new just testing things onothing new just testing things onothing new just testing things onothing new just testing things out hahahahahshshhshahahahahahaasdasdsadsfdas", // widget.productDescription,
                  maxLines: 10,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
                // LayoutBuilder(
                //   builder: (BuildContext context, BoxConstraints constraints) {
                //     final span = TextSpan(
                //       text:
                //           "hahabsdkjasbdfjhawebfjhebwrhfjkaberfhjberosadsadsadsfuhberouyfberuyfberuoyfberuoyfberyuofberouyfberuybf", // widget.productDescription,
                //       style: GoogleFonts.poppins(
                //         fontWeight: FontWeight.w400,
                //         fontSize: 10,
                //       ),
                //     );
                //     final tp = TextPainter(
                //       text: span,
                //       textDirection: TextDirection.ltr,
                //       maxLines: 2,
                //     );
                //     tp.layout(maxWidth: constraints.maxWidth);

                //     if (tp.didExceedMaxLines) {
                //       // The text is overflowing
                //       overflowing = true;
                //     } else {
                //       // The text is not overflowing
                //       overflowing = false;
                //     }

                //     return Text.rich(
                //       span,
                //       maxLines: overflowing && readmore ? 10 : 2,
                //       softWrap: true,
                //       overflow: TextOverflow.ellipsis,
                //     );
                //   },
                // ),
                // TextButton(
                //   onPressed: () {},
                //   child: Text("Ream more..."),
                // ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.001,
          ),
          //contains the card icon on the top and favorite on the bottom
          // Column(
          //   children: [
          //     GestureDetector(
          //       onTap: () async {
          //         DocumentReference docRef = FirebaseFirestore.instance
          //             .collection("cart")
          //             .doc(FirebaseAuth.instance.currentUser!.uid)
          //             .collection("userCart")
          //             .doc(widget.productId);

          //         DocumentSnapshot docSnap = await docRef.get();
          //         if (docSnap.exists) {
          //           print('Product is already in the cart');
          //         } else {
          //           cartAdded = true;
          //           docRef.set(
          //             {
          //               "productId": widget.productId,
          //               "productImage": widget.productImage,
          //               "productName": widget.productName,
          //               "productPrice": widget.productPrice,
          //               "productOldPrice": widget.productPrice,
          //               "productDescription": widget.productDescription,
          //               "productQuantity": 1,
          //               "productCategory": widget.productCategory,
          //             },
          //           );
          //         }
          //         RoutingPage.goTonext(
          //           context: context,
          //           navigateTo: CheckOutPage(),
          //         );
          //       },
          //       child: Container(
          //         padding: EdgeInsets.all(10),
          //         //   width: MediaQuery.of(context).size.width * .15,
          //         //  height: MediaQuery.of(context).size.width * .15,
          //         decoration: BoxDecoration(
          //           color: Color.fromRGBO(254, 205, 67, 1),
          //           borderRadius: BorderRadius.circular(50),
          //         ),
          //         child: Icon(
          //           cartAdded
          //               ? CupertinoIcons.cart_fill
          //               : CupertinoIcons.cart,
          //           size: 14,
          //           color: const Color.fromARGB(255, 0, 0, 0),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       height: MediaQuery.of(context).size.width * .05,
          //     ),
          //     Container(
          //       width: MediaQuery.of(context).size.width * .08,
          //       height: MediaQuery.of(context).size.width * .08,
          //       decoration: BoxDecoration(
          //         color: Color.fromRGBO(64, 175, 110, 1),
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Icon(
          //         Icons.favorite_border,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            width: MediaQuery.of(context).size.width * .35,
            height: MediaQuery.of(context).size.width * .35,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .30,
                  height: MediaQuery.of(context).size.width * .30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.productImage),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Positioned(
                  //top: MediaQuery.of(context).size.width * .02 - 50,
                  left: MediaQuery.of(context).size.width * .075,
                  bottom: MediaQuery.of(context).size.width * .02,
                  //     height: 10,
                  //bottom: 50,
                  child: cartAdded
                      ? Container(
                          width: 55,
                          height: 20, //MediaQuery.of(context).size.width * .05,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(64, 190, 117, 1),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(33, 160, 86, 1),
                              width: .5,
                            ),
                            //borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("remove from cart");
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                              Text(
                                "2",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("add to cart");
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            print("add to card");
                            FirebaseFirestore.instance
                                .collection("cart")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("userCart")
                                .doc(widget.productId)
                                .set(
                              {
                                "productId": widget.productId,
                                "productImage": widget.productImage,
                                "productName": widget.productName,
                                "productPrice": widget.productPrice,
                                "productOldPrice": widget.productPrice,
                                "productDescription": widget.productDescription,
                                "productQuantity": 1,
                                "productCategory": widget.productCategory,
                              },
                            );
                          },
                          child: Container(
                            width: 60,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(252, 219, 213, 1),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Color.fromRGBO(232, 42, 4, 1),
                                width: .5,
                              ),
                              //borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Row(
                                //  mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  //   Spacer(),
                                  Center(
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 222, 61, 61),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Color.fromARGB(255, 222, 61, 61),
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),

      //           onPressed: () {
      //             setState(
      //               () {
      //                 //  isFavorite = !isFavorite;

      //                 if (isFavorite == true) {
      //                   favoriteProvider.favorite(
      //                     productId: widget.productId,
      //                     productCategory: widget.productCategory,
      //                     productRate: widget.productRate,
      //                     productOldPrice: double.parse(widget.productOldPrice),
      //                     productPrice: double.parse(widget.productPrice),
      //                     productImage: buildimage,
      //                     productFavorite: true,
      //                     productName: widget.productName,
      //                   );
      //                 } else if (isFavorite == false) {
      //                   favoriteProvider.deleteFavorite(
      //                       productId: widget.productId);
      //                 }
      //               },
      //             );
      //           },
    );
  }
}
