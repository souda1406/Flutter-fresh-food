import 'dart:convert'; // Import for jsonEncode/jsonDecode

class BlogPost {
  final String id;
  final String title;
  final String content;
  final String author;
  final String imageUrl;
  final DateTime publishDate;
  int likes;
  bool isLiked;
  List<Comment> comments;
  final String category; // Moved to final as it's typically set at creation

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.imageUrl,
    required this.publishDate,
    required this.category,
    this.likes = 0,
    this.isLiked = false,
    List<Comment>? comments,
  }) : comments = comments ?? [];

  // Convert a BlogPost object to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'imageUrl': imageUrl,
      'publishDate': publishDate.toIso8601String(), // Convert DateTime to String
      'category': category,
      'likes': likes,
      'isLiked': isLiked,
      'comments': comments.map((comment) => comment.toJson()).toList(), // Serialize comments
    };
  }

  // Create a BlogPost object from a Map (for JSON deserialization)
  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      imageUrl: json['imageUrl'],
      publishDate: DateTime.parse(json['publishDate']), // Convert String back to DateTime
      category: json['category'],
      likes: json['likes'],
      isLiked: json['isLiked'],
      comments: (json['comments'] as List)
          .map((item) => Comment.fromJson(item))
          .toList(),
    );
  }
}

class Comment {
  final String id;
  final String author;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.timestamp,
  });

  // Convert a Comment object to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to String
    };
  }

  // Create a Comment object from a Map (for JSON deserialization)
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']), // Convert String back to DateTime
    );
  }
}