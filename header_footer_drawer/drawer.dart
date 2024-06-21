import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../user/email_reset_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../login/login_page.dart';
import '../user/edit_user_page.dart';
import 'drawer_model.dart';

class UserDrawer extends StatelessWidget {
  // 定数コンストラクタ
  const UserDrawer({Key? key,}) : super(key: key);

  // build()
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DrawerModel>(
      create: (_) => DrawerModel()..fetchUserList(),
      child: Drawer(
        backgroundColor: Colors.yellow,
        child: Consumer<DrawerModel>(builder: (context, model, child) {
          return ListView(
            children: ListTile.divideTiles(
              context: context,
                  color: Colors.black26,
                  tiles: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15,),
                        const Text('Menu & MyAccount',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(height: 7,),
                        Text(
                          'UserName：${model.name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Group：${model.group}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Grade：${model.grade}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Email：${model.email}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '出席状況：${model.status}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 15,),

                      ],
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title: TextButton.icon(
                        icon: const Icon(
                          color: Colors.black,
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
                        label: const Text(
                            'ログアウト',
                          style: TextStyle(
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title: TextButton.icon(
                        onPressed: () async {
                          //メールアドレスとパスワード変更ページに遷移
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) {
                                  return const EmailResetPage();
                                }
                            ),
                          );
                        },
                        icon: const Icon(
                          color: Colors.black,
                          Icons.email_rounded,
                        ),
                        label: const Text(
                            'Email変更',
                          style: TextStyle(
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title: TextButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) {
                                  return EditMyPage(name: model.name, group: model.group, grade: model.grade, userImage: model.imgURL,);
                                }
                            ),
                          );
                        },
                        icon: const Icon(
                          color: Colors.black,
                          Icons.manage_accounts,
                        ),
                        label: const Text(
                            'アカウント情報変更',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title: Link(
                        // 開きたいWebページのURLを指定
                        uri: Uri.parse('https://p.al.kansai-u.ac.jp/'),
                        // targetについては後述
                        target: LinkTarget.self,
                        builder: (BuildContext ctx, FollowLink? openLink) {
                          return TextButton.icon(
                            onPressed: openLink,
                            label: const Text(
                              'Polemanage',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            icon: const Icon(
                              Icons.poll,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title: Link(
                        // 開きたいWebページのURLを指定
                        uri: Uri.parse('https://al.kansai-u.ac.jp/'),
                        // targetについては後述
                        target: LinkTarget.self,
                        builder: (BuildContext ctx, FollowLink? openLink) {
                          return TextButton.icon(
                            onPressed: openLink,
                            label: const Text(
                              '研究室ホームページ',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            icon: const Icon(
                                Icons.home,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(),
                  ],
            ).toList(),
          );
        }),
      ),
    );
  }
}


