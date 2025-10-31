abstract class SpkLeasingFilterRepo {
  Future<Map<String, dynamic>> loadGroupDealer(String employeeId);
  Future<Map<String, dynamic>> loadDealer(String employeeId, String groupName);
  Future<Map<String, dynamic>> loadLeasing();
  Future<Map<String, dynamic>> loadCategory();
  Future<Map<String, dynamic>> loadSpkLeasingData(
    String employeeId,
    String date,
    String branch,
    String category,
    String leasing,
    String dealer,
  );
}
