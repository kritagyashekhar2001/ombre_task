import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'add_likes_and_comment_event.dart';
part 'add_likes_and_comment_state.dart';

class AddLikesAndCommentBloc
    extends Bloc<AddLikesAndCommentEvent, AddLikesAndCommentState> {
  AddLikesAndCommentBloc() : super(AddLikesAndCommentInitial()) {
    on<AddLikes>((event, emit) async {
      try {
        List<dynamic> likesList = [];
        await FirebaseFirestore.instance
            .collection("videos")
            .doc(event.videoID)
            .get()
            .then((value) => likesList = value.data()!["likes"]);
        if (likesList.contains(FirebaseAuth.instance.currentUser!.uid)) {
          await FirebaseFirestore.instance
              .collection("videos")
              .doc(event.videoID)
              .update({
            "likes":
                FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
          });
        } else {
          await FirebaseFirestore.instance
              .collection("videos")
              .doc(event.videoID)
              .update({
            "likes":
                FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    });
  }
}
