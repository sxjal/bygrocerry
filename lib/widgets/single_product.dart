import 'package:bygrocerry/pages/provider/favorite_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  int quantity = 1;

  void quantityFuntion(productId) async {
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userCart")
        .doc(productId)
        .update({
      "productQuantity": quantity,
    });
  }

  void deleteProductFuntion(productId) {
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userCart")
        .doc(productId)
        .delete();
  }

  Widget buildimage() {
    final Uri? uri = Uri.tryParse(widget.productImage);

    if (uri == null || !uri.hasScheme) {
      return Text('Invalid URL');
    }

    return Image.network(widget.productImage);
  }

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    FirebaseFirestore.instance
        .collection("favorite")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("userFavorite")
        .doc(widget.productId)
        .get()
        .then(
          (value) => {
            if (this.mounted)
              {
                if (value.exists)
                  {
                    setState(() {
                      isFavorite = value.get("productFavorite");
                    }),
                  }
              }
          },
        );

    //CartProvider cartProvider = Provider.of<CartProvider>(context);
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
                    quantity = value.get("productQuantity"),
                    setState(() {
                      cartAdded = true;
                    }),
                  }
                else
                  {
                    setState(() {
                      cartAdded = false;
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
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.001,
          ),
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
                  right: MediaQuery.of(context).size.width * .070,
                  top: MediaQuery.of(context).size.width * .02,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;

                        FirebaseFirestore.instance
                            .collection("favorite")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection("userFavorite")
                            .doc(widget.productId)
                            .set({
                          "productFavorite": isFavorite,
                        });
                      });
                    },
                    child: isFavorite == true
                        ? Icon(
                            Icons.favorite,
                            color: Color.fromARGB(255, 222, 61, 61),
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Color.fromARGB(255, 222, 61, 61),
                          ),
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
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                      quantityFuntion(widget.productId);
                                    });
                                  } else if (quantity == 1) {
                                    deleteProductFuntion(widget.productId);
                                    setState(() {
                                      cartAdded = false;
                                      deleteProductFuntion(widget.productId);
                                    });
                                  } else {
                                    print("error");
                                  }
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("add to cart");
                                  setState(() {
                                    quantity++;
                                    quantityFuntion(widget.productId);
                                  });
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
                          onTap: () async {
                            await FirebaseFirestore.instance
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
                            setState(() {
                              cartAdded = true;
                            });
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
    );
  }
}
