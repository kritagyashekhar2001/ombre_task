part of 'add_likes_and_comment_bloc.dart';

@immutable
abstract class AddLikesAndCommentState {}

class AddLikesAndCommentInitial extends AddLikesAndCommentState {}

class LikesChanged extends AddLikesAndCommentState {}
