part of 'video_upload_bloc.dart';

@immutable
abstract class VideoUploadState {}

class VideoUploadInitial extends VideoUploadState {}

class VideoUploaded extends VideoUploadState {}

class VideoUploadError extends VideoUploadState {}

class VideoUploading extends VideoUploadState {}
