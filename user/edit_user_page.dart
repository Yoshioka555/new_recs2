import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../header_footer_drawer/footer.dart';
import 'edit_user_model.dart';
import '../pick_export/pick_export.dart';
import 'dart:typed_data';
import 'dart:convert';

class EditMyPage extends StatefulWidget {
  final String name;
  final String group;
  final String grade;
  final String userImage;
  const EditMyPage({Key? key, required this.name, required this.group, required this.grade, required this.userImage}) : super(key:key);
  @override
  _EditMyPageState createState() => _EditMyPageState();
}

class _EditMyPageState extends State<EditMyPage> {

  late TextEditingController _nameController;
  late TextEditingController _groupController;
  late TextEditingController _gradeController;
  late TextEditingController _userImageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _groupController = TextEditingController(text: widget.group);
    _gradeController = TextEditingController(text: widget.grade);
    _userImageController = TextEditingController(text: widget.userImage);
  }

  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditMyPageModel>(
      create: (_) => EditMyPageModel()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('ユーザー情報変更',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Consumer<EditMyPageModel>(builder: (context, model, child) {

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      //getImageFromGallery();
                      final _imageData = await Pick().pickFile();
                      setState(() {
                        imageData = _imageData;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 50,
                      backgroundImage: imageData != null ?
                      Image.memory(
                        imageData!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) {
                          return const Icon(
                            Icons.error,
                            color: Colors.red,
                          );
                        },
                      ).image
                      : _userImageController.text != '' ?
                      Image.memory(
                        base64Decode(_userImageController.text),
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) {
                          return const Icon(
                            Icons.error,
                            color: Colors.red,
                          );
                        },
                      ).image
                      : AssetImage('assets/images/default.png'),
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: '名前(苗字のみ)',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '選択した班：${_groupController.text}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blueAccent,
                            value: 'Web班',
                            groupValue: _groupController.text,
                            onChanged: (text) {
                              setState(() {
                                _groupController.text = text!;
                              });
                            },
                          ),
                          const Text('Web班'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blueAccent,
                            value: 'Grid班',
                            groupValue: _groupController.text,
                            onChanged: (text) {
                              setState(() {
                                _groupController.text = text!;
                              });
                            },
                          ),
                          const Text('Grid班'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blueAccent,
                            value: 'Network班',
                            groupValue: _groupController.text,
                            onChanged: (text) {
                              setState(() {
                                _groupController.text = text!;
                              });
                            },
                          ),
                          const Text('Network班'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blueAccent,
                            value: '教員',
                            groupValue: _groupController.text,
                            onChanged: (text) {
                              setState(() {
                                _groupController.text = text!;
                              });
                            },
                          ),
                          const Text('教員'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '選択した学年：${_gradeController.text}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  DropdownButton(
                      value: _gradeController.text,
                      items: const [
                        DropdownMenuItem(
                          value: 'B4',
                          child: Text('B4'),
                        ),
                        DropdownMenuItem(
                          value: 'M1',
                          child: Text('M1'),
                        ),
                        DropdownMenuItem(
                          value: 'M2',
                          child: Text('M2'),
                        ),
                        DropdownMenuItem(
                          value: 'D1',
                          child: Text('D1'),
                        ),
                        DropdownMenuItem(
                          value: 'D2',
                          child: Text('D2'),
                        ),
                        DropdownMenuItem(
                          value: 'D3',
                          child: Text('D3'),
                        ),
                        DropdownMenuItem(
                          value: '教授',
                          child: Text('教授'),
                        ),
                      ],
                      onChanged: (text) {
                        setState(() {
                          _gradeController.text = text!;
                        });
                      }
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      model.startLoading();
                      try {
                        await model.update(_nameController.text, _groupController.text, _gradeController.text);

                        if (imageData != null) {
                          await model.updateImage(imageData);
                        }
                        //ユーザー登録
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return const Footer(pageNumber: 3);
                              }
                          ),
                        );
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
  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    _gradeController.dispose();
    _userImageController.dispose();
    super.dispose();
  }
}