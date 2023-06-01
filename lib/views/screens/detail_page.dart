import 'package:adv_11_am_firebase_app/helpers/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<Object, Object> newData = {};

  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot data =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                initialValue: data['name'],
                onChanged: (val) {
                  newData['name'] = val;
                },
              ),
              TextFormField(
                initialValue: data['email'],
                onChanged: (val) {
                  newData['email'] = val;
                },
              ),
              TextFormField(
                initialValue: data['contact'].toString(),
                onChanged: (val) {
                  newData['contact'] = int.parse(val);
                },
              ),
              const SizedBox(
                height: 80,
              ),
              ElevatedButton(
                onPressed: () {
                  FireStoreHelper.fireStoreHelper.editUser(
                    id: data['id'],
                    data: newData,
                  );
                  Navigator.pop(context);
                },
                child: const Text("SUBMIT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
