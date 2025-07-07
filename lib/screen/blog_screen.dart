// lib/screens/blog_screen.dart
import 'package:flutter/material.dart';

class BlogPost {
  final String id;
  final String title;
  final String content;
  final String author;
  final String imageUrl;
  final DateTime publishDate;
  final String category;
  int likes;
  bool isLiked;
  List<Comment> comments;

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
}

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<BlogPost> blogPosts = [
    BlogPost(
      id: '1',
      title: '10 Benefits of Eating Fresh Spinach Daily',
      content: 'Spinach is packed with nutrients that can boost your health significantly. Rich in iron, vitamins A, C, and K, this leafy green vegetable supports immune function, bone health, and energy levels.',
      author: 'Dr. Sarah Green',
      imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
      publishDate: DateTime.now().subtract(Duration(hours: 2)),
      category: 'Leafy Greens',
      likes: 45,
      comments: [
        Comment(
          id: '1',
          author: 'John Doe',
          content: 'Great article! I\'ve been adding spinach to my smoothies.',
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        ),
        Comment(
          id: '2',
          author: 'Maria Lopez',
          content: 'Thanks for the tips. My kids love spinach now!',
          timestamp: DateTime.now().subtract(Duration(minutes: 15)),
        ),
      ],
    ),
    BlogPost(
      id: '2',
      title: 'Growing Organic Carrots: A Complete Guide',
      content: 'Learn how to grow the sweetest, most nutritious carrots in your own garden. From soil preparation to harvest, we cover everything you need to know about organic carrot cultivation.',
      author: 'Mike Garden',
      imageUrl: 'https://images.unsplash.com/photo-1445282768818-728615cc910a?w=400',
      publishDate: DateTime.now().subtract(Duration(days: 1)),
      category: 'Root Vegetables',
      likes: 32,
      comments: [
        Comment(
          id: '3',
          author: 'Green Thumb',
          content: 'This helped me improve my carrot yield by 50%!',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
        ),
      ],
    ),
    BlogPost(
      id: '3',
      title: 'Bell Peppers: Colors and Their Nutritional Differences',
      content: 'Did you know that different colored bell peppers have varying nutritional profiles? Red peppers contain more vitamin C than green ones, while yellow peppers are rich in carotenoids.',
      author: 'Nutrition Expert',
      imageUrl: 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
      publishDate: DateTime.now().subtract(Duration(days: 2)),
      category: 'Peppers',
      likes: 28,
    ),
    BlogPost(
      id: '4',
      title: 'Seasonal Vegetable Shopping: Spring Edition',
      content: 'Spring brings an abundance of fresh vegetables. Learn which vegetables are at their peak during spring months and how to select the best quality produce for your family.',
      author: 'Chef Anna',
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
      publishDate: DateTime.now().subtract(Duration(days: 3)),
      category: 'Seasonal',
      likes: 67,
      comments: [
        Comment(
          id: '4',
          author: 'Foodie Mom',
          content: 'Perfect timing! Just started my spring garden.',
          timestamp: DateTime.now().subtract(Duration(hours: 5)),
        ),
        Comment(
          id: '5',
          author: 'Healthy Eater',
          content: 'Love the seasonal approach to eating!',
          timestamp: DateTime.now().subtract(Duration(hours: 3)),
        ),
      ],
    ),
  ];

  void _toggleLike(String postId) {
    setState(() {
      final post = blogPosts.firstWhere((p) => p.id == postId);
      if (post.isLiked) {
        post.likes--;
        post.isLiked = false;
      } else {
        post.likes++;
        post.isLiked = true;
      }
    });
  }

  void _showCommentsSheet(BlogPost post) {
    final TextEditingController commentController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Comments (${post.comments.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: post.comments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No comments yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Be the first to comment!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: post.comments.length,
                        itemBuilder: (context, index) {
                          final comment = post.comments[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.green,
                                      child: Text(
                                        comment.author[0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      comment.author,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      _formatTime(comment.timestamp),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  comment.content,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (commentController.text.isNotEmpty) {
                          setState(() {
                            post.comments.add(
                              Comment(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                author: 'You',
                                content: commentController.text,
                                timestamp: DateTime.now(),
                              ),
                            );
                          });
                          setModalState(() {});
                          commentController.clear();
                        }
                      },
                      icon: Icon(Icons.send),
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vegetable News',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          final post = blogPosts[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                    child: Icon(
                      Icons.eco,
                      size: 80,
                      color: Colors.green,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          post.category,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      // Title
                      Text(
                        post.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Content preview
                      Text(
                        post.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 12),
                      // Author and date
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.green,
                            child: Text(
                              post.author[0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.author,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _formatTime(post.publishDate),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Action buttons
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _toggleLike(post.id),
                            child: Row(
                              children: [
                                Icon(
                                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: post.isLiked ? Colors.red : Colors.grey,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${post.likes}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 24),
                          InkWell(
                            onTap: () => _showCommentsSheet(post),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${post.comments.length}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              // Share functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Share feature coming soon!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: Icon(
                              Icons.share_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Create new post feature coming soon!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}