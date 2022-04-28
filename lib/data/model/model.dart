class MyModel {
  final String id;
  final String title;
  final String body;

  MyModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        title = json['title'] ?? '',
        body = json['body'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> params = {
      'id': id,
      'title': title,
      'body': body,
    };
    return params;
  }
  
}
