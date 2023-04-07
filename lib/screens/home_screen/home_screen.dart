import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ombre_task/screens/home_screen/bloc/add_likes_and_comment/add_likes_and_comment_bloc.dart';
import 'package:ombre_task/screens/home_screen/bloc/video_play/video_play_bloc.dart';
import 'package:ombre_task/screens/home_screen/components/video_player.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ombre_task/screens/home_screen/video_confirm.dart';

import 'bloc/video_upload_bloc/video_upload_bloc.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final VideoPlayBloc videoPlayBloc = VideoPlayBloc();

  @override
  void initState() {
    videoPlayBloc.eventSink.add(StreamEvents.loadVideos);
    super.initState();
  }

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => VideoUploadBloc(),
            child: ConfirmScreen(
              videoFile: File(video.path),
              videoPath: video.path,
            ),
          ),
        ),
      );
    }
  }

  showOptionsDialog(BuildContext context) {
    
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: const Color(0xFFE57373),
        onPressed: () {
          showOptionsDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Reels"),
      ),
      body: StreamBuilder<List?>(
        stream: videoPlayBloc.videoStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return PageView.builder(
            itemCount: snapshot.data?.length ?? 0,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data = snapshot.data?[index];
              return Stack(
                children: [
                  VideoPlayerItem(
                    videoUrl: data["videoUrl"],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.05,
                                    bottom: size.height * 0.05),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      data["username"],
                                      style: TextStyle(
                                        fontSize: size.height * 0.025,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      data["caption"],
                                      style: TextStyle(
                                        fontSize: size.height * 0.02,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin:
                                  EdgeInsets.only(bottom: size.height * 0.15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          BlocProvider.of<
                                                      AddLikesAndCommentBloc>(
                                                  context)
                                              .add(AddLikes(data["id"]));
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          size: 40,
                                          color: data["likes"].contains(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid)
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        data["likes"].length.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      InkWell(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.comment,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        data["commentCount"].toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
