import '../services/api_service.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/todo_model.dart';

class UserRepository {
  final ApiService apiService;
  UserRepository(this.apiService);

  Future<List<User>> getUsers(int limit, int skip, [String? query]) async {
    final data = await apiService.fetchUsers(limit, skip, query);
    return (data['users'] as List).map((e) => User.fromJson(e)).toList();
  }

  Future<List<Post>> getUserPosts(int userId) async {
    final data = await apiService.fetchUserPosts(userId);
    return (data['posts'] as List).map((e) => Post.fromJson(e)).toList();
  }

  Future<List<Todo>> getUserTodos(int userId) async {
    final data = await apiService.fetchUserTodos(userId);
    return (data['todos'] as List).map((e) => Todo.fromJson(e)).toList();
  }
}
