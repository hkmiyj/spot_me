import 'package:flutter/material.dart';
import 'package:spot_me/widget/showMap.dart';

class locatePage extends StatefulWidget {
  const locatePage({super.key});

  @override
  State<locatePage> createState() => _locatePageState();
}

class _locatePageState extends State<locatePage> {
  bottomSheetBar() {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.09,
      maxChildSize: 0.45,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white,
          child: ListView(
            controller: scrollController,
            children: [
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.red,
                  size: 45.0,
                ),
                title: Text("Iskandar"),
                subtitle: Text("500 Meter"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.red,
                  size: 45.0,
                ),
                title: Text(
                  "Najib".toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("500 Meter"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.red,
                  size: 45.0,
                ),
                title: Text("Anwar"),
                subtitle: Text("1.0KM"),
                trailing: Icon(Icons.arrow_forward_ios),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Locate Victim'),
          centerTitle: true,
        ),
        body: Stack(
          children: [Map(context), bottomSheetBar()],
        ));
  }
}
