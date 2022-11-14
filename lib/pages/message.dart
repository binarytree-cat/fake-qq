import 'package:flutter/material.dart';
import '../entity/user.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);
  static const routeName = '/MessagePageState';
  @override
  State<MessagePage> createState() => _MessagePageState();
}

/// 对话消息实现功能
class _MessagePageState extends State<MessagePage> {
  // 聊天的对象
  late ChatUser chatUser;
  // 消息文本 Controller
  TextEditingController messageController = TextEditingController();
  // 输入框发送按钮显示
  bool textFieldSendButtonVisible = false;

  List<Widget> rows = [];

  void sendMessage() {
    String message = messageController.text;
    rows.add(getMessageBubble(message));
  }

  Widget getMessageBubble(String s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                child: Text(
                  s,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                decoration: BoxDecoration(color: Colors.blue),
                padding: EdgeInsets.all(10),
              ),
              CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/profile photo.jpg'))
            ],
          ),
        )
      ],
    );
  }

  ListView getListView(){
    return ListView(
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    chatUser = ModalRoute.of(context)!.settings.arguments as ChatUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(chatUser.name),
        centerTitle: true,
      ),
      body: getListView(),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(5),
                child: TextField(
                  onTap: () {
                    setState(() {
                      textFieldSendButtonVisible = true;
                    });
                  },
                  onSubmitted: (String) {
                    setState(() {
                      textFieldSendButtonVisible = false;
                    });
                  },
                  controller: messageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Visibility(
                        visible: textFieldSendButtonVisible,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                // TODO 发送消息
                                sendMessage();
                                messageController.clear();
                              });
                            },
                            icon: Icon(Icons.send))),
                  ),
                ),
              ))),
    );
  }
}
