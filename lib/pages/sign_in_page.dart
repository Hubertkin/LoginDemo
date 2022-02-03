import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:log_in_app/authentication_service.dart';
import 'package:log_in_app/pages/homepage.dart';
import 'package:log_in_app/pages/sign_up_page.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formkey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  bool isLoading = false;
  final AuthenticationService _authenticationService =
      AuthenticationService(FirebaseAuth.instance);

  // ignore: non_constant_identifier_names
  String? SignedIn;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formkey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(
                height: 40,
              ),
              const Center(
                child: Text(
                  'Welcome to KelTech App',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/logo2.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onSaved: (newValue) => emailController.text = newValue!,
                autofocus: false,
                controller: emailController,
                validator: _emailValidator,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email',
                  hintText: 'Please enter an email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  focusColor: Colors.red,
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onSaved: (newValue) => passwordController.text = newValue!,
                controller: passwordController,
                obscuringCharacter: '*',
                obscureText: _isObscure,
                validator: _passwordValidator,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
                    labelText: 'Password',
                    hintText: 'Please enter a password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    focusColor: Colors.red,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    )),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: const StadiumBorder()),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            context.read<AuthenticationService>().signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );

                            SignedIn = await _authenticationService.signIn(
                                email: emailController.text,
                                password: passwordController.text);
                            setState(() {
                              isLoading = false;
                            });
                            if (SignedIn == 'Signed in') {
                              Navigator.pushAndRemoveUntil(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                  (route) => false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Sign in successful'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (SignedIn != 'Signed in') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$SignedIn'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: Container(
                alignment: Alignment.center,
                child: clickable(context),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

String? _emailValidator(value) {
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  if (value.isEmpty || value == null) {
    return 'Enter an email';
  } else if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? _passwordValidator(value) {
  RegExp regExp = RegExp(r'^.{6,}$');
  if (value.isEmpty || value == null) {
    return 'Enter a password';
  } else if (!regExp.hasMatch(value)) {
    return ('Enter valid Password(Min. 6 characters) ');
  }
  return null;
}

clickable(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 17, color: Colors.black),
      children: <TextSpan>[
        const TextSpan(text: 'Don\'t have an account?  '),
        TextSpan(
            text: 'Sign Up',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              }),
      ],
    ),
  );
}
