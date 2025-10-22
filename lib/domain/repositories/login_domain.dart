abstract class LoginRepo {
  Future<Map<String, dynamic>> login(
    String username,
    String password,
    String uuid,
    String device,
  );
  Future<Map<String, dynamic>> logout();
}
