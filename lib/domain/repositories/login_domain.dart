abstract class LoginRepo {
  Future<Map<String, dynamic>> login(
    String username,
    String password,
    String uuid,
    String device,
  );
  Future<Map<String, dynamic>> logout();
  Future<Map<String, dynamic>> forgotPassword(
    String employeeId,
    String currentPassword,
    String newPassword,
  );
  Future<Map<String, dynamic>> resetPassword(String employeeId);
  Future<Map<String, dynamic>> requestId(String phoneNumber);
}
