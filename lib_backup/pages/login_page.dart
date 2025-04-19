import 'package:flutter/material.dart';
import 'package:studytogether_app/uiComponents/my_textfield.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onTap;
  //constructor for the login page
  LoginPage({super.key, required this.onTap});

//when user clicks on ree=gister button this function is called
//final void Function() onTap;

//text controllers for the text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),

              // Logo
              Image.asset(
                'assets/images/LogoF.png',
                height: 100,
              ),

              // study together motive
              Text(
                ' Find, Connect, Succeed ',
                style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 15,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 50), //gap between logo and text boxes

              // email entry
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // password
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () {
                    // TODO: handle login logic here
                    print(
                        'Login pressed. Username: ${emailController.text}, Password: ${passwordController.text}');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[900], //overall color of the button
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // not a member?, register.

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      'Register here',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 49, 89),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
