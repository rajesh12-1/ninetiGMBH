import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;

  List<User> _users = [];
  int _skip = 0;
  final int _limit = 20;
  String? _currentQuery;
  Timer? _debounce;

  UserBloc(this.apiService) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    try {
      if (event.skip == 0) {
        emit(UserLoading());
        _users.clear();
        _skip = 0;
      }

      final data = await apiService.fetchUsers(event.limit, event.skip, event.query);
      final List<User> fetchedUsers = (data['users'] as List)
          .map((json) => User.fromJson(json))
          .toList();

      final hasReachedEnd = fetchedUsers.length < event.limit;

      _skip += fetchedUsers.length;
      _users.addAll(fetchedUsers);

      emit(UserLoaded(List.from(_users), hasReachedEnd));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onSearchUsers(SearchUsers event, Emitter<UserState> emit) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _currentQuery = event.query;
      _skip = 0;
      add(FetchUsers(limit: _limit, skip: _skip, query: _currentQuery));
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
