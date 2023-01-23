import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/contact.dart';
import 'package:spot_me/view/bottomNav/map2.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  Widget build(BuildContext context) {
    final _contact = Provider.of<List<Contact>>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Emergency Contact List'),
          centerTitle: true,
        ),
        body: Container(
          child: ListView.builder(
              itemCount: _contact.length,
              itemBuilder: ((context, index) {
                final contact = _contact[index];
                return ListTile(
                    leading: Icon(Icons.emergency),
                    title: Text(contact.name),
                    subtitle: Text(contact.phoneNumber),
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: contact.phoneNumber,
                      );
                      await launchUrl(launchUri);
                    });
              })),
        ));
  }
}
