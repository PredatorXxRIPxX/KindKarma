import 'package:flutter/material.dart';
import 'package:kindkarma/api/api.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisible = false;

  void login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    } else {
      try {
        await account.createEmailPasswordSession(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully')),
        );
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
        return;
            } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error has occurred')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Lottie.asset(
              'assets/waves.json',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome back! Please login to your account',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) => email = value,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black38,
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) => password = value,
                    style: const TextStyle(color: Colors.white),
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black38,
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? const Icon(Icons.visibility, color: Colors.white)
                            : const Icon(Icons.visibility_off, color: Colors.white),
                      ),
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/forgot');
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    login(email, password);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black26,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
