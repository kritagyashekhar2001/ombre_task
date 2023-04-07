import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'video_play_event.dart';
part 'video_play_state.dart';

enum StreamEvents { loadVideos, nextVideos ,addLikes}

class VideoPlayBloc {
  final _stateStreamController = StreamController<List?>.broadcast();
  StreamSink<List?> get videoSink => _stateStreamController.sink;
  Stream<List?> get videoStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<StreamEvents>();
  StreamSink<StreamEvents> get eventSink => _eventStreamController.sink;
  Stream<StreamEvents> get eventStream => _eventStreamController.stream;
  int listlength = 0;
  late dynamic currentCollection;
  late dynamic lastVisible;

  VideoPlayBloc() {
    List videoList = [];

    eventStream.listen((event) async {
      if (event == StreamEvents.loadVideos) {
        var messRef = FirebaseFirestore.instance.collection("videos");
        var stream = messRef.snapshots();
        currentCollection = await messRef.get();
        lastVisible = currentCollection.docs[currentCollection.docs.length - 1];

        stream.listen((value) {
          videoList = [];
          for (var i in value.docs) {
            videoList.add(i.data());
          }
          listlength = videoList.length;
          // videoList.shuffle();
          videoSink.add(videoList);
        });
      } else if (event == StreamEvents.nextVideos) {
        var messRef = FirebaseFirestore.instance
            .collection('videos')
            .startAfterDocument(lastVisible)
            .limit(5);
        dynamic stream = messRef.snapshots();
        currentCollection = await messRef.get();
        if (currentCollection.docs.length >= 1) {
          lastVisible =
              currentCollection.docs[currentCollection.docs.length - 1];
        }

        stream.listen((value) {
          for (var i in value.docs) {
            videoList.add(i.data());
          }
          listlength = videoList.length;

          videoSink.add(videoList);
        });
      }
    });
  }
}
