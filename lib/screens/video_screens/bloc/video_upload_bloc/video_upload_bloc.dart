import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:ombre_task/screens/video_screens/components/model/video.dart';
import 'package:video_compress/video_compress.dart';

part 'video_upload_event.dart';
part 'video_upload_state.dart';

class VideoUploadBloc extends Bloc<VideoUploadEvent, VideoUploadState> {
  VideoUploadBloc() : super(VideoUploadInitial()) {
    on<UploadVideo>((event, emit) async {
      emit(VideoUploading());
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        var allDocs =
            await FirebaseFirestore.instance.collection('videos').get();
        int len = allDocs.docs.length;
        String videoUrl =
            await uploadVideoToStorage("Video ${len + 1}", event.videoPath);
        String thumbnail =
            await uploadImageToStorage("Video ${len + 1}", event.videoPath);

        Video video = Video(
          username: FirebaseAuth.instance.currentUser!.displayName ?? '',
          uid: uid,
          id: "Video ${len + 1}",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          caption: event.caption,
          videoUrl: videoUrl,
          timestamp: FieldValue.serverTimestamp(),
          thumbnail: thumbnail,
        );

        await FirebaseFirestore.instance
            .collection('videos')
            .doc('Video ${len + 1}')
            .set(
              video.toJson(),
            )
            .then((value) {
          emit(VideoUploaded());
        });
      } catch (e) {
        print(e.toString());
        emit(VideoUploadError());
      }
    });
  }
  Future<File> compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file!;
  }

  Future<String> uploadVideoToStorage(String id, String videoPath) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('/videos/$id')
        .putFile(await compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<File> getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> uploadImageToStorage(String id, String videoPath) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
