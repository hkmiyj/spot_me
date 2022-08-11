import 'package:flutter/material.dart';
import 'package:spot_me/route/route.dart' as route;
import 'package:spot_me/widgets/bottom_navigation.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(),
      bottomNavigationBar: BottomNavBarWidget(),
    );
  }
}