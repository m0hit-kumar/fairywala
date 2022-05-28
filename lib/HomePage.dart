import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _location = TextEditingController();

    CollectionReference request =
        FirebaseFirestore.instance.collection('request');
    Future<void> addRequest() {
      return request
          .add({'location': "location", 'need': "need", 'time': "time"})
          .then((value) => print("User Request"))
          .catchError((error) => print("Failed to Request: $error"));
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                  style: const TextStyle(
                    color: Color(0xFFbdc6cf),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                  controller: _location),
              TextField(
                  style: const TextStyle(
                    color: Color(0xFFbdc6cf),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Product Need',
                  ),
                  controller: _location),
              TextField(
                  style: const TextStyle(
                    color: Color(0xFFbdc6cf),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Location',
                  ),
                  controller: _location),
              TextField(
                  style: const TextStyle(
                    color: Color(0xFFbdc6cf),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Location',
                  ),
                  controller: _location),
              TextButton(
                onPressed: addRequest,
                child: const Text(
                  "Add User",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
