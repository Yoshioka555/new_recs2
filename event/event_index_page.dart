import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login/login_page.dart';


class EventIndexPage extends StatelessWidget {
  const EventIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: const Icon(Icons.timer),
                  onPressed: () async {

                  }
              ),
            ),
          ],
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.0,
          title: const Text('Event Page'),
        ),
        body: Center(
          child: TextButton.icon(
            icon: const Icon(
              Icons.logout_outlined,
            ),
            onPressed: () async {
              try {
                showDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: const Text("ログアウトしますか？"),
                      actions: [
                        CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel')),
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) {
                                    return const LoginPage();
                                  }
                              ),
                            );
                            const snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('ログアウトしました'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                        )
                      ],
                    ));

              } catch (e) {
//失敗した場合
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            label: const Text('ログアウト'),
          ),
        ),
    );
  }

}