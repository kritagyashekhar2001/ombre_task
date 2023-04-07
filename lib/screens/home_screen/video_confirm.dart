import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ombre_task/screens/home_screen/bloc/video_upload_bloc/video_upload_bloc.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Add Video"),
      ),
      body: BlocListener<VideoUploadBloc, VideoUploadState>(
        listener: (context, state) {
          if (state is VideoUploaded) {
            Navigator.pop(context);
          } else if (state is VideoUploadError) {
            const snackBar = SnackBar(
                content: Text("Something went wrong"),
                backgroundColor: Colors.red);

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.75,
                child: VideoPlayer(controller),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin:  EdgeInsets.symmetric(horizontal: size.width*0.05),
                    width: size.width *0.9,
                    child: TextFormField(
                      controller: _captionController,
                      decoration: const InputDecoration(
                        labelText: 'Caption',
                        icon: Icon(Icons.closed_caption),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.015,),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<VideoUploadBloc>(context).add(
                          UploadVideo(
                              _captionController.text, widget.videoPath));
                    },
                    child:  Text(
                      'Share!',
                      style: TextStyle(
                        fontSize: size.height*0.02,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
