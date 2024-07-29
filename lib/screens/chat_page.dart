import 'package:chatapp/componants/my_textField.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String title;
  final String receiverID;

  ChatPage({required this.title, required this.receiverID});
  final TextEditingController textEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService chatService = ChatService();

  void sendMessage() async {
    if (textEditingController.text.isNotEmpty) {
      await chatService.sendMessage(textEditingController.text, receiverID);
      textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String senderID = _auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            child: ChatListView(
              chatService: chatService,
              senderID: senderID,
              receiverID: receiverID,
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    allowPadding: false,
                    hintText: 'Send Message',
                    obscureText: false,
                    controller: textEditingController,
                  ),
                ),
                IconButton(
                  onPressed: sendMessage, // Corrected function call
                  icon: const Icon(Icons.arrow_upward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({
    super.key,
    required this.chatService,
    required this.senderID,
    required this.receiverID,
  });

  final ChatService chatService;
  final String senderID;
  final String receiverID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatService.getMessages(
        currentUserID: senderID,
        otherUserID: receiverID,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error..."),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data!.docs.map((doc) => buildMessageUI(doc)).toList(),
          );
        }
      },
    );
  }

  Widget buildMessageUI(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == senderID;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical:7),
      decoration: BoxDecoration(
        color: isCurrentUser?const Color.fromARGB(20, 33, 149, 243):const Color.fromARGB(83, 76, 175, 79),
        borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      alignment: alignment,
      child: Text(data["message"],style: TextStyle(fontSize: 16),),
      
    );
  }
}
