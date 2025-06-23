part of '../cubit/forum_cubit.dart';

abstract class ForumState {}

class ForumLoading extends ForumState {}

class ForumLoaded extends ForumState {
  final List<Forum> forums;
  ForumLoaded(this.forums);
}

class ForumError extends ForumState {
  final String message;
  ForumError(this.message);
}
