import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()async {
                String mail = emailController.text.trim();
                String pass = passwordController.text.trim();

                if(mail.isEmpty || pass.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter all the fields")));
                }else{
                  try{
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: mail, password: pass).then((value){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registered Successfully")));
                    });
                    Navigator.pushNamed(context, '/login');
                  }catch(err){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${err.toString()}")),
                    );
                  }
                }
              },
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
