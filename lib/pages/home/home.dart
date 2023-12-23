import 'package:bygrocerry/pages/cartPage/cart_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:bygrocerry/appColors/app_colors.dart';
// import 'package:bygrocerry/pages/detailPage/details_page.dart';
// import 'package:bygrocerry/route/routing_page.dart';
// import 'package:bygrocerry/widgets/build_drawer.dart';
// import 'package:bygrocerry/widgets/grid_view_widget.dart';
// import 'package:bygrocerry/widgets/single_product.dart';
import 'package:bygrocerry/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:bygrocerry/pages/home/mainpage.dart';

late UserModel userModel;
Size? size;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel userModel =
      UserModel(fullName: "", emailAddress: "", userUid: "", imageurl: "");
  Future getCurrentUserDataFunction() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          userModel = UserModel.fromDocument(documentSnapshot);
        } else {
          print("Document does not exist in the database");
        }
      },
    );
  }

  @override
  void initState() {
    getCurrentUserDataFunction();
    super.initState();
  }

  dynamic selected;
  var heart = false;
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false, //to make floating action button notch transparent

      //to avoid the floating action button overlapping behavior,
      // when a soft keyboard is displayed
      resizeToAvoidBottomInset: true,

      bottomNavigationBar: StylishBottomBar(
        backgroundColor: Colors.white,
        option: AnimatedBarOptions(
          // iconSize: 32,
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
          // opacity: 0.3,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.house_outlined,
            ),
            selectedIcon: const Icon(
              Icons.house_rounded,
            ),
            selectedColor: Colors.green,
            title: const Text('Home'),
          ),
          BottomBarItem(
            icon: const Icon(
              Icons.favorite_border,
            ),
            selectedColor: Colors.green,
            title: const Text('Favorites'),
          ),
          BottomBarItem(
            icon: const Icon(
              Icons.history,
            ),
            selectedIcon: const Icon(
              Icons.history_edu,
            ),
            selectedColor: Colors.green,
            title: const Text(
              'Order History',
            ),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        currentIndex: selected ?? 0,
        onTap: (index) {
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            );
          });
        },
        backgroundColor: Colors.green,
        child: Icon(
          CupertinoIcons.cart,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: PageView(
        controller: controller,
        children: [
          HomePage(user: userModel),
          Center(child: Text('Style')),
          Center(child: Text('Orders')),
        ],
      ),
    );
  }
}
