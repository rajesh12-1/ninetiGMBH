import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/post_model.dart';
import '../../models/todo_model.dart';
import '../../repositories/user_repository.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_indicator.dart';
import '../post/postScreen.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({required this.user});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<List<Post>> _postsFuture;
  late Future<List<Todo>> _todosFuture;
  final UserRepository repository = UserRepository(ApiService());

  @override
  void initState() {
    super.initState();
    _postsFuture = repository.getUserPosts(widget.user.id);
    _todosFuture = repository.getUserTodos(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newPost = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreatePostScreen()),
              );
              if (newPost != null) {
                setState(() {
                  _postsFuture = _postsFuture.then((posts) => [...posts, newPost]);
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(user.image)),
            SizedBox(height: 12),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 16)),

            SizedBox(height: 24),
            Text('Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading posts: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Text('No posts available.');
                }
                final posts = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    );
                  },
                );
              },
            ),

            SizedBox(height: 24),
            Text('Todos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            FutureBuilder<List<Todo>>(
              future: _todosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading todos: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Text('No todos available.');
                }
                final todos = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return CheckboxListTile(
                      title: Text(todo.todo),
                      value: todo.completed,
                      onChanged: null,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
