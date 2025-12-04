abstract class SalesRepo {
  Future<Map<String, dynamic>> fetchSalesman(String username);
  Future<Map<String, dynamic>> addOrModifySalesman(
    String userId,
    String id,
    String name,
    String tier,
    int status, {
    bool isModify = false,
  });
}
