import 'package:chatapp/screens/chat_page.dart';
import 'package:chatapp/services/auth/auth_gate.dart';
import 'package:chatapp/services/auth/auth_survice.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});
  ChatService chatService = ChatService();
  AuthService authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () => sighnOut(context),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: userBuilder(),
    );
  }

  StreamBuilder<dynamic> userBuilder() {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("There Some Error .."),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => usersListViwe(context, userData))
                .toList(),
          );
        }
      },
    );
  }

  void sighnOut(BuildContext context) {
    final _auth = AuthService();
    _auth.signOut().whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthGate()),
        (Route<dynamic> route) => false));
  }

  Widget usersListViwe(BuildContext context, dynamic userData) {
    return userData['email'] == _auth.currentUser!.email
        ? SizedBox()
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            title: userData["email"],receiverID:userData["uid"] ,
                          ))),
              child: Container(padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height*0.09,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.secondary),
                child: Row(
                  children: [const Icon(Icons.person),SizedBox(width: 25,), Text(userData["email"])],
                ),
              ),
            ),
        );
  }
}
