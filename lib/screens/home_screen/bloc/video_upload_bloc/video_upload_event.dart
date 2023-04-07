part of 'video_upload_bloc.dart';

@immutable
abstract class VideoUploadEvent {}

class UploadVideo extends VideoUploadEvent {
  final String caption;
  final String videoPath;

  UploadVideo(this.caption, this.videoPath);
}
