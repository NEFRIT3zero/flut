import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:flut/models/user.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, User?>(
  (ref) => UserNotifier(),
);

class UserNotifier extends StateNotifier<User?> {

  UserNotifier() : super(null);

  void login(User user) {
    state = user;
  }

  void logout() {
    state = null;
  }
}