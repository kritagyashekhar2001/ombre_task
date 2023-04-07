part of 'add_likes_and_comment_bloc.dart';

@immutable
abstract class AddLikesAndCommentEvent {}

class AddLikes extends AddLikesAndCommentEvent {
  final String videoID;

  AddLikes(this.videoID);
}
