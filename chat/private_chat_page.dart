import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:labmaidfastapi/domain/user_data.dart';
import 'package:provider/provider.dart';

class PrivateChatPage extends StatefulWidget {
  final int privateChatroomId;
  final UserData userData;
  final UserData myData;
  const PrivateChatPage({Key? key,
    required this.privateChatroomId,
    required this.userData,
    required this.myData,
  }) : super(key:key);

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

/*
class ChatL10nJa extends ChatL10n {
  const ChatL10nJa({
    super.attachmentButtonAccessibilityLabel = '画像アップロード',
    super.emptyChatPlaceholder = 'メッセージがありません。',
    super.fileButtonAccessibilityLabel = 'ファイル',
    super.inputPlaceholder = 'メッセージを入力してください',
    super.sendButtonAccessibilityLabel = '送信',
  });
}

 */

class _PrivateChatPageState extends State<PrivateChatPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.userData.name),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
              onPressed: () async {

              },
              icon: const Icon(Icons.info)
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Text('aaa'),
    );
  }

  /*
  void handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   */

  /*
  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      imageFile = File(result.path);

      if(imageFile!= null) {
        final task = await FirebaseStorage.instance.ref().child('groupChats/${randomString()}').putFile(imageFile!);
        task.ref.getDownloadURL();
        img = await task.ref.getDownloadURL();
      }
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: myUser!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: img!,
        width: image.width.toDouble(),
      );


      setState(() {
        _addMessage(message);
      });

      Map<String, dynamic> chatImageMap = {
        'message': '',
        'sendFile': '',
        'mimeType': '',
        'sendImg': message.uri,
        'height': image.height,
        'name': result.name,
        'size': bytes.length,
        'width': image.width,
        'senderId': myUser!.id,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      sendImageStore(widget.roomId, chatImageMap, randomString());

    }
  }

   */

  /*
  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null && result.files.single.path != null) {
      docFile = File(result.files.single.path!);

      if(docFile!= null) {
        final task = await FirebaseStorage.instance.ref().child('groupChats/${randomString()}').putFile(docFile!);
        task.ref.getDownloadURL();
        file = await task.ref.getDownloadURL();
      }
      final message = types.FileMessage(
        author: myUser!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: file!,
      );

      setState(() {
        _addMessage(message);
      });

      Map<String, dynamic> chatFileMap = {
        'message': '',
        'sendImg': '',
        'height': 0,
        'width': 0,
        'sendFile': message.uri,
        'name': result.files.single.name,
        'size': result.files.single.size,
        'mimeType': lookupMimeType(result.files.single.path!),
        'senderId': myUser!.id,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      sendFileStore(widget.roomId, chatFileMap, randomString());

    }
  }

   */

  /*
  void _addMessage(types.Message message) {
    messages.insert(0, message);
  }

   */

}