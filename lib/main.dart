// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/user/user_event.dart';
import 'services/api_service.dart';
import 'blocs/user/user_bloc.dart';
import 'screens/user_list/user_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final apiService = ApiService();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: ThemeData.light(),
      home: BlocProvider(
        create: (_) => UserBloc(apiService)..add(FetchUsers()),
        child: UserListScreen(),
      ),
    );
  }
}
