import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class MinutesIndexPage extends StatefulWidget {
  @override
  _MinutesIndexPageState createState() => _MinutesIndexPageState();
}

class _MinutesIndexPageState extends State<MinutesIndexPage> {
  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8000/ws_message/2'));
  final TextEditingController _controller = TextEditingController();

  List<String> messages = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24,),
            Expanded(
              child: StreamBuilder(
                  stream: channel.stream,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      messages.add(snapshot.data.toString());
                    }
                    return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context,index){
                          return ListTile(
                            title: Text(messages[index]),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close();

    super.dispose();
  }
}