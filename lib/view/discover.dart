import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spot_me/route/route.dart' as route;

class discoverPage extends StatefulWidget {
  const discoverPage({Key? key}) : super(key: key);

  @override
  State<discoverPage> createState() => _discoverPageState();
}

class _discoverPageState extends State<discoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Container(
                    child: Text("DISCOVER",
                              style: TextStyle(
                                  fontSize: 50, color: Colors.black))),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                Text("Welcome USER",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black)),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, route.login), child: Text(
              "Sign Out",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontFamily: "WorkSansBold"),
            ))
              ]),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red),
                      child: Center(
                          child: Text("Save Me",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white))),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: Center(
                            child: Text("Become Rescuer",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)))),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                  width: 380,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: Center(
                      child: Text("Shelter",
                          style:
                              TextStyle(fontSize: 20, color: Colors.white)))),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      width: 180,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                        width: 180,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.cyan,
                        )),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      )),
    ));
  }
}
