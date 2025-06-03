class LocalPost {
  final String title;
  final String body;

  LocalPost({required this.title, required this.body});

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
      };

  factory LocalPost.fromJson(Map<String, dynamic> json) {
    return LocalPost(
      title: json['title'],
      body: json['body'],
    );
  }
}
