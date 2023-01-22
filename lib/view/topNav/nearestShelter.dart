import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NearestShelter extends StatefulWidget {
  const NearestShelter({super.key});

  @override
  State<NearestShelter> createState() => _NearestShelterState();
}

class _NearestShelterState extends State<NearestShelter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearest Shelter'),
        centerTitle: true,
      ),
    );
  }
}
