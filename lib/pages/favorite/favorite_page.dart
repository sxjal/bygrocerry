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
      body: Container(),
    );
  }
}
