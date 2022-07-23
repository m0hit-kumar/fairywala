enum ServiceCategory{
  Vegetable,
  Fruit,
  Icecream,
  FoldingNiwarMaker
}

class Service {
  final bool? accepted;
  final String consumerID;
  final String consumerEmail;
  final int consumerPhone;
  final DateTime recieveDateTime;
  final DateTime? createdON;
  final String recieveCoordinates;
  final List<Map<String,dynamic>> items;
  final String consumerName;
  final ServiceCategory serviceCategory;


  Service({
    this.accepted,
    this.createdON,
    required this.consumerName,
    required this.recieveDateTime,
    required this.consumerEmail,
    required this.items,
    required this.recieveCoordinates,
    required this.consumerPhone,
    required this.consumerID,
    required this.serviceCategory
  });
}
