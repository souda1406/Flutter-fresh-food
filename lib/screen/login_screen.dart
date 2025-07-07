// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import 'grocery_home_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header Image Section
              Container(
                width: size.width,
                height: size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/vegetables.webp'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // Fresh Food Title
              Text(
                "Fresh Food",
                style: GoogleFonts.pacifico(
                  fontSize: 32,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              SizedBox(height: 40),
              
              // Login Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      label: "Email",
                      hintText: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      label: "Password",
                      hintText: "Enter your password",
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Login Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLoginSimple,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: CircleBorder(),
                            padding: EdgeInsets.zero,
                            elevation: 3,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_forward,
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 25),
                    
                    // Footer Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _handleForgetPassword,
                          child: Text(
                            "Forget password?",
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _handleSignUp,
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // // Handle Login Function
  // void _handleLogin() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     try {
  //       // Simulate API call
  //       await Future.delayed(Duration(seconds: 2));
        
  //       // Here you would typically call your authentication service
  //       print('Login attempt:');
  //       print('Email: ${_emailController.text}');
  //       print('Password: ${_passwordController.text}');
        
  //       // Show success message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Login successful!'),
  //           backgroundColor: Color(0xFF4CAF50),
  //         ),
  //       );
        
  //       // Navigate to next screen
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => GroceryHomeScreen()),
  //       );
        
  //     } catch (error) {
  //       // Show error message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Login failed. Please try again.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     } finally {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }
void _handleLoginSimple() {
  // Navigate directly without validation
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => GroceryHomeScreen()),
  );
}
  // Handle Forget Password
  void _handleForgetPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forget Password'),
          content: Text('Password reset functionality will be implemented here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Handle Sign Up
  void _handleSignUp() {
    // Navigate to sign up screen
    print('Navigate to Sign Up screen');
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => SignUpScreen()),
    // );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}