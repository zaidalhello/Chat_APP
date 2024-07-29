import 'package:chatapp/models/massge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> sendMessage(String message, String reseverID) async {
    String cuttrentUserID = _auth.currentUser!.uid;
    String cuttrentUserEmail = _auth.currentUser!.email ?? "";
    Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderID: cuttrentUserID,
        senderEmail: cuttrentUserEmail,
        reseverID: reseverID,
        message: message,
        timestamp: timestamp);
    List<String> ids = [cuttrentUserID, reseverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

 Stream<QuerySnapshot> getMessages({required String currentUserID, required String otherUserID}) {
  List<String> ids = [currentUserID, otherUserID];
  ids.sort();
  String chatRoomID = ids.join('_');
  return _firestore
      .collection('chat_rooms')
      .doc(chatRoomID)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
}


  Stream<dynamic> getUserStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

}
