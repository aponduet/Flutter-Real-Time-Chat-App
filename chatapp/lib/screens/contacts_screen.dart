import 'package:chatapp/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ContactScreen extends StatelessWidget {
  ContactScreen({Key? key}) : super(key: key);
  final List<UserModel> userData = [
    UserModel(id: 1, name: "Rony", age: 29, sex: "male", imageUrl: "1.jpg"),
    UserModel(
        id: 2, name: "Shondha", age: 25, sex: "female", imageUrl: "2.jpg"),
    UserModel(id: 3, name: "Rocky", age: 23, sex: "male", imageUrl: "3.jpg"),
    UserModel(id: 4, name: "Sohel", age: 22, sex: "male", imageUrl: "4.jpg"),
    UserModel(id: 5, name: "Trisha", age: 20, sex: "Female", imageUrl: "5.jpg"),
    UserModel(id: 6, name: "Tanha", age: 20, sex: "Female", imageUrl: "6.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Contacts",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: ListView.builder(
            itemCount: userData.length,
            itemBuilder: ((context, index) =>
                SingleUser(data: userData[index]))),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: "Channels",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class SingleUser extends StatelessWidget {
  final UserModel data;
  const SingleUser({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        // Codes will come soon
      }),
      hoverColor: Colors.white,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        AssetImage("../../images/${data.imageUrl}"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${data.name}"),
                      Text("${data.sex}"),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChatScreen(userData: data)));
                  },
                  child: const Text("Chat"))

              // const SizedBox(
              //   height: 5,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
