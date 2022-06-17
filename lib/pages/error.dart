import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/error.png', scale: 1.0),
            Card(
                child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.error),
                  title: const Text('Film Fan'),
                  subtitle: const Text(
                      'Something went wrong, Please make sure you  are connected to the internet and restart the app\n\nTap to close'),
                  onTap: () {
                    //closing the App
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else {
                      //not realistic in ios
                      exit(0);
                    }
                  },
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
