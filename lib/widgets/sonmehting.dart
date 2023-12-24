import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool overflowing = false;
  bool readmore = false;

  Widget buildimage() {
    final Uri? uri = Uri.tryParse(widget.productImage);

    if (uri == null || !uri.hasScheme) {
      return Text('Invalid URL');
    }

    return Image.network(widget.productImage);
  }

  @override
  Widget build(BuildContext context) {
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
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .20,
                height: MediaQuery.of(context).size.width * .20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.productImage),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * .18,
                left: (MediaQuery.of(context).size.width * .18) / 2,
                child: Container(
                  width: MediaQuery.of(context).size.width * .05,
                  height: MediaQuery.of(context).size.width * .05,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(64, 175, 110, 1),
                    //borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
