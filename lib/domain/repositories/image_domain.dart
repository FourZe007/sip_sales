abstract class ImageRepo {
  Future<Map<String, dynamic>> uploadProfilePicture(
    String mode,
    String employeeId,
    String img,
  );

  Future<Map<String, dynamic>> getHDImage(
    String branch,
    String shop,
    String actId,
    String date,
  );
}
