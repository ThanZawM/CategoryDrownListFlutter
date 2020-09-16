class Item {
  final String message;

  Item({this.message});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(message: json['message']);
  }
}
