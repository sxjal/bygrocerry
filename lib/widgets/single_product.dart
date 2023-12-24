import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  }) : super(key: key);

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
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
    //  FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);

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

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        height: MediaQuery.of(context).size.height * .15,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            //contains the image
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
            SizedBox(
              width: MediaQuery.of(context).size.width * .05,
            ),
            //contains the name, category and price
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "very veruy very long text", //  widget.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.productCategory,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "\₹${widget.productPrice}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Spacer(),
            //contains the card icon on the top and favorite on the bottom
            Column(),
          ],
        ),
        //   Row(
        //     children: [
        //       Container(
        //         decoration: BoxDecoration(
        //           image: DecorationImage(
        //             fit: BoxFit.cover,
        //             image: NetworkImage(widget.productImage),
        //           ),
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         child: IconButton(
        //           highlightColor: Colors.transparent,
        //           splashColor: Colors.transparent,
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
        //           icon: Icon(
        //             isFavorite ? Icons.favorite : Icons.favorite_border,
        //             color: Colors.pink[700],
        //           ),
        //         ),
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           Text(
        //             widget.productName,
        //             style: TextStyle(
        //               fontWeight: FontWeight.normal,
        //             ),
        //           ),
        //           SizedBox(
        //             width: 20,
        //           ),
        //           Text(
        //             "\₹${widget.productPrice}",
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ],
        //       )
        //     ],
        //   ),
      ),
    );
  }
}
