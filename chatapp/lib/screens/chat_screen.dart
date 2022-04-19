import 'dart:convert';

import 'package:chatapp/models/chat_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final UserModel userData;
  ChatScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController inputController = TextEditingController();
  ChatModel? value;
  // Focusnode for auto focusing Input field when open the page
  late FocusNode myFocusNode;
  // Socket Implementation here
  final List<ChatModel> chatData = [
    // ChatModel(
    //   userId: 1,
    //   messageId: "1",
    //   message:
    //       "Hello Sohel, I Love You so much. Do you love me? Hello Sohel, I Love You so much. Do you love me? Hello Sohel, I Love You so much. Do you love me?",
    //   sendTime: "10.30am Friday,16",
    //   seenStatus: true,
    // ),
    // ChatModel(
    //   userId: 2,
    //   messageId: "2",
    //   message: "Hi Trisha, I am Fine, I love you too.",
    //   sendTime: "10.30am Friday,16",
    //   seenStatus: true,
    // ),
    // ChatModel(
    //   userId: 10,
    //   messageId: "3",
    //   message: "Thank You, do you miss me now?",
    //   sendTime: "10.30am Friday,16",
    //   seenStatus: false,
    // ),
    // ChatModel(
    //   userId: 2,
    //   messageId: "4",
    //   message:
    //       "Hello Sohel, I Love You so much. Do you love me? Hello Sohel, I Love You so much. Do you love me? Hello Sohel, I Love You so much. Do you love me?",
    //   sendTime: "10.30am Friday,16",
    //   seenStatus: true,
    // ),
    // ChatModel(
    //   userId: 2,
    //   messageId: "4",
    //   message: "why are you not seeing my message?",
    //   sendTime: "10.30am Friday,16",
    //   seenStatus: false,
    // ),
    // ChatModel(
    //   userId: 5,
    //   messageId: "5",
    //   message:
    //       "Hello Sohel, I Love You so much. Do you love me? Hello Sohel, I Love You so much. Do you love me? Hello Sohel, I Love You so much. Do you love me?",
    //   sendTime: "10.30am Friday,16",
    //   seenStatus: true,
    // ),
    // ChatModel(
    //   userId: 9,
    //   messageId: "6",
    //   message:
    //       "Hello Sohel, I Love You so much. Do you love me? Hello Sohel, I Love You so much. Do you love me? Hello Sohel, I Love You so much. Do you love me?",
    //   sendTime: "10.30am Friday,16",
    //   seenStatus: true,
    // ),
  ];

  //Socket Implementation Here....

  IO.Socket? socket; //initalize the Socket.IO Client Object

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    //--> call the initializeSocket method in the initState of our app.
    initializeSocket();
    print("The InitState function is Called!!");
  }

  @override
  void dispose() {
    print("The Dispose function is Called!!");
    socket
        ?.disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  void initializeSocket() {
    socket = IO.io('http://172.20.10.3:3000', <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket?.connect(); //connect the Socket.IO Client to the Server
    print(socket?.connected);

    //SOCKET EVENTS
    // --> listening for connection
    socket?.on('connect', (data) {
      print(socket?.connected);
    });

    //listen for incoming messages from the Server.
    socket?.on('reply', (data) {
      Map<String, dynamic> chatdata = jsonDecode(data);
      ChatModel chatObjData = ChatModel.fromJson(chatdata);

      ChatModel chatInfo = ChatModel(
        userId: chatObjData.userId,
        userName: chatObjData.userName,
        message: chatObjData.message,
        sendTime: chatObjData.sendTime,
        seenStatus: true,
        messageId: "4",
      );

      // this.mounted ব্যবহারের ফলে ডিসপোজ ফাংশনের পরে সেট স্টেট কল হওয়ার এরর থেকে মুক্তি পাওয়া যায়।

      if (this.mounted) {
        setState(() {
          chatData.add(chatInfo);
          print("The Setstate function is Called!!");
        });
      }
      //print(data.userId); //
    });

    //listens when the client is disconnected from the Server
    socket?.on('disconnect', (data) {
      print('disconnected');
    });
  }

  sendMessage() {
    ChatModel data = ChatModel(
      userId: widget.userData.id,
      userName: widget.userData.name,
      message: inputController.text,
      sendTime: DateTime.now().toLocal().toString().substring(0, 16),
    );
    String json = jsonEncode(data);
    socket?.emit("message", json);
    inputController.clear();
    myFocusNode.requestFocus();
    // print(json);
  }

  @override
  Widget build(BuildContext context) {
    print("The build function is Called!!");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20, //radius is 50
              backgroundImage: AssetImage(
                  '../../images/${widget.userData.imageUrl}'), //image url
            ),
            const SizedBox(
              width: 10,
            ),
            Text("${widget.userData.name}"),
          ],
        ),
      ),
      body: Container(
        color: Colors.white38,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chatData.length,
                    itemBuilder: (context, index) => MyText(
                      chat: chatData[index],
                      senderId: widget.userData.id,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 70,
                        height: 40,

                        // Message Input Area.
                        child: TextField(
                          controller: inputController,
                          focusNode: myFocusNode,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.account_circle,
                              color: Colors.black45,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            hintText: 'Type message here...',
                          ),
                          autofocus: true,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                        color: Colors.green,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Single Message Text Part (Used in ListView.Builder)
class MyText extends StatelessWidget {
  final ChatModel chat;
  final int? senderId;
  const MyText({Key? key, required this.chat, required this.senderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: senderId == chat.userId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: senderId == chat.userId ? Colors.yellow : Colors.green,
                border: Border.all(
                    color:
                        senderId == chat.userId ? Colors.yellow : Colors.green,
                    width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),

                  // Sender Or Recever Name
                  child: Text("${chat.userName}",
                      style: senderId == chat.userId
                          ? const TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)
                          : const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                ),
                Text("${chat.message}"),
                Divider(
                  color: senderId == chat.userId
                      ? Colors.yellowAccent
                      : Colors.greenAccent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${chat.sendTime}",
                        style: senderId == chat.userId
                            ? const TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold)
                            : const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold)),
                    Icon(
                      chat.seenStatus! ? Icons.done : Icons.done_all,
                      size: 20,
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
