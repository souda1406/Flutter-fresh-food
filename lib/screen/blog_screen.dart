import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'dart:convert'; // Import for jsonEncode/jsonDecode

import '../models/blog_post.dart'; // Import the separated models
import 'create_blog_screen.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<BlogPost> blogPosts = []; // Initialize as empty, will load from storage
  bool _isLoading = true; // Track loading state for initial data

  // Initial dummy data (used if no data is found in local storage)
  final List<BlogPost> _initialBlogPosts = [
    BlogPost(
      id: '1',
      title: '10 Benefits of Eating Fresh Spinach Daily',
      content: 'Spinach is packed with nutrients that can boost your health significantly. Rich in iron, vitamins A, C, and K, this leafy green vegetable supports immune function, bone health, and energy levels.',
      author: 'Dr. Sarah Green',
      imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
      publishDate: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'Leafy Greens',
      likes: 45,
      comments: [
        Comment(
          id: '1',
          author: 'John Doe',
          content: 'Great article! I\'ve been adding spinach to my smoothies.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        Comment(
          id: '2',
          author: 'Maria Lopez',
          content: 'Thanks for the tips. My kids love spinach now!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
      ],
    ),
    BlogPost(
      id: '2',
      title: 'Growing Organic Carrots: A Complete Guide',
      content: 'Learn how to grow the sweetest, most nutritious carrots in your own garden. From soil preparation to harvest, we cover everything you need to know about organic carrot cultivation.',
      author: 'Mike Garden',
      imageUrl: 'https://images.unsplash.com/photo-1445282768818-728615cc910a?w=400',
      publishDate: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Root Vegetables',
      likes: 32,
      comments: [
        Comment(
          id: '3',
          author: 'Green Thumb',
          content: 'This helped me improve my carrot yield by 50%!',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
    ),
    BlogPost(
      id: '3',
      title: 'Bell Peppers: Colors and Their Nutritional Differences',
      content: 'Did you know that different colored bell peppers have varying nutritional profiles? Red peppers contain more vitamin C than green ones, while yellow peppers are rich in carotenoids.',
      author: 'Nutrition Expert',
      imageUrl: 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
      publishDate: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Peppers',
      likes: 28,
    ),
    BlogPost(
      id: '4',
      title: 'Seasonal Vegetable Shopping: Spring Edition',
      content: 'Spring brings an abundance of fresh vegetables. Learn which vegetables are at their peak during spring months and how to select the best quality produce for your family.',
      author: 'Chef Anna',
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
      publishDate: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Seasonal',
      likes: 67,
      comments: [
        Comment(
          id: '4',
          author: 'Foodie Mom',
          content: 'Perfect timing! Just started my spring garden.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Comment(
          id: '5',
          author: 'Healthy Eater',
          content: 'Love the seasonal approach to eating!',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadBlogPosts(); // Load posts when the screen initializes
  }

  // Load blog posts from shared_preferences
  Future<void> _loadBlogPosts() async {
    setState(() {
      _isLoading = true; // Set loading to true while fetching data
    });
    final prefs = await SharedPreferences.getInstance();
    final String? blogPostsJson = prefs.getString('blogPosts');
    if (blogPostsJson != null) {
      try {
        final List<dynamic> postMaps = jsonDecode(blogPostsJson);
        setState(() {
          blogPosts = postMaps.map((map) => BlogPost.fromJson(map)).toList();
        });
      } catch (e) {
        print('Error decoding blog posts from local storage: $e');
        // Fallback to initial data if decoding fails
        setState(() {
          blogPosts = _initialBlogPosts;
        });
        _saveBlogPosts(); // Save initial data
      }
    } else {
      // If no data in storage, populate with initial dummy data
      setState(() {
        blogPosts = _initialBlogPosts;
      });
      _saveBlogPosts(); // Save initial data
    }
    setState(() {
      _isLoading = false; // Set loading to false after data is loaded
    });
  }

  // Save blog posts to shared_preferences
  Future<void> _saveBlogPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(blogPosts.map((post) => post.toJson()).toList());
    await prefs.setString('blogPosts', jsonString);
  }

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
    _saveBlogPosts(); // Save changes
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Comments (${post.comments.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
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
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No comments yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const Text(
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
                        padding: const EdgeInsets.all(16),
                        itemCount: post.comments.length,
                        itemBuilder: (context, index) {
                          final comment = post.comments[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
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
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      comment.author,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatTime(comment.timestamp),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  comment.content,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                          _saveBlogPosts(); // Save changes
                        }
                      },
                      icon: const Icon(Icons.send),
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

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd,yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vegetable News',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading // Show a loading indicator while data is being fetched
          ? const Center(child: CircularProgressIndicator())
          : blogPosts.isEmpty // Show empty state if no posts are available
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No blog posts yet!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        'Tap the + button to create your first post.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: blogPosts.length,
                  itemBuilder: (context, index) {
                    final post = blogPosts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                              child: Image.network(
                                post.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: Colors.grey.shade500,
                                    ),
                                  );
                                },
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: Colors.green,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                const SizedBox(height: 8),
                                Text(
                                  post.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.green,
                                      child: Text(
                                        post.author[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.author,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            _formatTime(post.publishDate),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
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
                                          const SizedBox(width: 4),
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
                                    const SizedBox(width: 24),
                                    InkWell(
                                      onTap: () => _showCommentsSheet(post),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.comment_outlined,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
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
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Share feature coming soon!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      child: const Icon(
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
        onPressed: () async {
          final newPost = await Navigator.of(context).push<BlogPost>(
            MaterialPageRoute(builder: (context) => CreateBlogScreen()),
          );

          if (newPost != null) {
            setState(() {
              blogPosts.insert(0, newPost);
            });
            _saveBlogPosts(); // Save the new post to local storage
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New blog post created!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
