import 'package:bygrocerry/pages/checkout/check_out_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bygrocerry/route/routing_page.dart';
import 'package:bygrocerry/widgets/my_button.dart';

class SecondPart extends StatelessWidget {
  final String productName;
  final double productPrice;
  final double productOldPrice;
  final String productDescription;
  final String productId;
  final String productImage;
  final String productCategory;

  const SecondPart({
    Key? key,
    required this.productCategory,
    required this.productImage,
    required this.productId,
    required this.productDescription,
    required this.productName,
    required this.productPrice,
    required this.productOldPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              child: Image.network(
                productImage,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Text(
                productName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("\₹ $productPrice"),
                SizedBox(
                  width: 20,
                ),
                productPrice == productOldPrice
                    ? Text("")
                    : Text(
                        "\₹ $productOldPrice",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
              ],
            ),
            Column(
              children: [
                Divider(
                  thickness: 2,
                ),
              ],
            ),
            Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              productDescription,
              style: TextStyle(),
            ),
            MyButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("cart")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("userCart")
                    .doc(productId)
                    .set(
                  {
                    "productId": productId,
                    "productImage": productImage,
                    "productName": productName,
                    "productPrice": productPrice,
                    "productOldPrice": productPrice,
                    "productDescription": productDescription,
                    "productQuantity": 1,
                    "productCategory": productCategory,
                  },
                );
                RoutingPage.goTonext(
                  context: context,
                  navigateTo: CheckOutPage(),
                );
              },
              text: "Add to Cart",
            ),
          ],
        ),
      ),
    );
  }
}
