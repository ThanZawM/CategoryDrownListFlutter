class Category {
  final String message;

  Category({this.message});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(message: json['message']);
  }
}
