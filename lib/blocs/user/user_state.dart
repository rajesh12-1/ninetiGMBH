// lib/blocs/user/user_state.dart
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final bool hasReachedEnd;
  final String? query;  // Added query field

  UserLoaded(this.users, this.hasReachedEnd, {this.query});

  @override
  List<Object?> get props => [users, hasReachedEnd, query];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}
