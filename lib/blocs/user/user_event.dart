// lib/blocs/user/user_event.dart
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final int limit;
  final int skip;
  final String? query;

  FetchUsers({this.limit = 10, this.skip = 0, this.query});
}
class SearchUsers extends UserEvent {
  final String query;

  SearchUsers(this.query);
}