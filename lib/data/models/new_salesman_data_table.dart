class NewSalesModel {
  final String id;
  final String name;
  final String tier;
  final int isActive;

  NewSalesModel({
    required this.id,
    required this.name,
    required this.tier,
    this.isActive = 1,
  });
}
