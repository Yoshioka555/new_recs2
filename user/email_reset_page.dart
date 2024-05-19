import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../header_footer_drawer/footer.dart';
import '../login/login_page.dart';
import 'email_reset_model.dart';

class EmailResetPage extends StatefulWidget {
  const EmailResetPage({super.key});
  @override
  _EmailResetPageState createState() => _EmailResetPageState();
}

class _EmailResetPageState extends State<EmailResetPage> {

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmailResetModel>(
      create: (_) => EmailResetModel()..fetchEmailReset(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Email変更',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Consumer<EmailResetModel>(builder: (context, model, child) {

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.emailController,
                    decoration: const InputDecoration(
                        hintText: 'Email　　※必要'
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: model.passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),

                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      )
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      model.startLoading();
                      try {
                        await model.updateUserEmail();
                        
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
                          content: Text('メールアドレスの変更確認のメールを新しいメールアドレスに送信しました。確認してください。'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (error) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(error.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } finally {
                        model.endLoading();
                      }
                    },
                    child: const Text('変更する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

}