abstract class ImageRepo {
  Future<Map<String, dynamic>> uploadProfilePicture(
    String mode,
    String employeeId,
    String img,
  );
}
