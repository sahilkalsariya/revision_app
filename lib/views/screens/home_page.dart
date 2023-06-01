import 'dart:io';

import 'package:adv_11_am_firebase_app/helpers/fcm_helper.dart';
import 'package:adv_11_am_firebase_app/helpers/firebase_auth_helper.dart';
import 'package:adv_11_am_firebase_app/helpers/firestore_helper.dart';
import 'package:adv_11_am_firebase_app/helpers/local_notification_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String? name;
  int? contact;
  String? email;
  String? image;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    LocalNotificationHelper.localNotificationHelper.initNotifications();

    FCMPushNotificationHelper.fcmPushNotificationHelper.getFCMToken();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  String? title, body;
  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logOut();

              Navigator.of(context).pushNamedAndRemoveUntil('login_page', (route) => false);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 70),
            CircleAvatar(radius: 80, foregroundImage: (user.photoURL != null) ? NetworkImage(user.photoURL as String) : null),
            const Divider(),
            (user.isAnonymous)
                ? Container()
                : (user.displayName == null)
                    ? Container()
                    : Text("Username: ${user.displayName}"),
            (user.isAnonymous) ? Container() : Text("Email: ${user.email}"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.getUser(),
          builder: (context, snapShots) {
            if (snapShots.hasError) {
              return Center(
                child: Text("Error: ${snapShots.error}"),
              );
            } else if (snapShots.hasData) {
              List data = snapShots.data!.docs;

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => ExpansionTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(data[index]['image']),
                    child: Text(
                      data[index]['name'][0],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(data[index]['name']),
                  subtitle: Text("Email: ${data[index]['email']}\nContact: ${data[index]['contact']}"),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed('detail_page', arguments: data[index]);
                          },
                          label: const Text("Edit"),
                          icon: const Icon(Icons.edit),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            FireStoreHelper.fireStoreHelper.removeRecord(id: data[index]['id']);
                          },
                          label: const Text("Delete"),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ImagePicker picker = ImagePicker();

          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text("Add user"),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            foregroundImage: (image != null) ? FileImage(File(image!)) : null,
                          ),
                          FloatingActionButton.small(
                            onPressed: () async {
                              XFile? file = await picker.pickImage(source: ImageSource.camera);

                              if (file != null) {
                                setState(() {
                                  image = file.path;
                                });
                              }
                            },
                            child: Icon(Icons.camera),
                          ),
                        ],
                      ),
                      TextFormField(
                        validator: (val) => (val!.isEmpty) ? "Please enter name" : null,
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Name"),
                        onSaved: (val) => name = val!,
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        validator: (val) => (val!.isEmpty) ? "Please enter email" : null,
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Email"),
                        onSaved: (val) => email = val!,
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        validator: (val) => (val!.isEmpty) ? "Please enter contact" : null,
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Contact"),
                        onSaved: (val) => contact = int.parse(val!),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (val) async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            await FireStoreHelper.fireStoreHelper.addUser(
                              name: name!,
                              email: email!,
                              contact: contact!,
                              image: image!,
                            );

                            image = null;

                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
