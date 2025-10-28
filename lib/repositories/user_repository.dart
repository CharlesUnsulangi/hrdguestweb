import '../models/user.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService api;

  UserRepository({required this.api});

  Future<User?> getUser(String id) async {
    return api.fetchUser(id);
  }
}
