class Post {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final Map<String, int> reactions;
  final int views;
  final int userId;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      tags: List<String>.from(json['tags']),
      reactions: Map<String, int>.from(json['reactions']),
      views: json['views'],
      userId: json['userId'],
    );
  }
}