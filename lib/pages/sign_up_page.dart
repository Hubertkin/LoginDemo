import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:log_in_app/authentication_service.dart';
import 'package:log_in_app/pages/homepage.dart';
import 'package:log_in_app/model/user_model.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isObscure = true;
  bool isSignedIn = false;
  bool isLoading = false;

  // ignore: non_constant_identifier_names
  String? SignedUp;
  final AuthenticationService _authenticationService =
      AuthenticationService(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Sign Up Page',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formkey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(
                height: 30,
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
                onSaved: (newValue) => firstNameController.text = newValue!,
                autofocus: false,
                controller: firstNameController,
                validator: _firstNameValidator,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_circle),
                  labelText: 'First Name',
                  hintText: 'Please enter your first name',
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
                onSaved: (newValue) => surnameController.text = newValue!,
                autofocus: false,
                controller: surnameController,
                validator: _secondNameValidator,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_circle),
                  labelText: 'Surname',
                  hintText: 'Please enter your surname',
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
                autofocus: false,
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
                height: 20,
              ),
              TextFormField(
                autofocus: false,
                onSaved: (newValue) =>
                    confirmPasswordController.text = newValue!,
                controller: confirmPasswordController,
                obscuringCharacter: '*',
                obscureText: _isObscure,
                validator: _confirmPasswordValidator,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter password',
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
                    :ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: const StadiumBorder()),
                  onPressed: () {
                    signUp(emailController.text, passwordController.text);
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      SignedUp =
          await _authenticationService.signUp(email: email, password: password);
      
      if (SignedUp == 'Signed up') {
        context.read<AuthenticationService>().signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign up successful'),
            backgroundColor: Colors.green,
          ),
        );
        postDetailsToFirestore();
        setState(() {
        isLoading = false;
      });
      } else if (SignedUp != 'Signed up') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$SignedUp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.surname = surnameController.text;

    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully :)'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  String? _confirmPasswordValidator(value) {
    RegExp regExp = RegExp(r'^.{6,}$');
    if (value.isEmpty || value == null) {
      return 'Enter a password';
    } else if (confirmPasswordController.text != passwordController.text) {
      return 'Please the password does not match';
    } else if (!regExp.hasMatch(value)) {
      return ('Enter valid Password(Min. 6 characters) ');
    }

    return null;
  }
}

String? _firstNameValidator(value) {
  RegExp regExp = RegExp(r'^.{3,}$');
  if (value.isEmpty || value == null) {
    return 'First Name cannot be empty';
  } else if (!regExp.hasMatch(value)) {
    return ('Enter valid name(Min. 3 character)');
  }
  return null;
}

String? _secondNameValidator(value) {
  RegExp regExp = RegExp(r'^.{3,}$');
  if (value.isEmpty || value == null) {
    return 'Surname cannot be empty';
  } else if (!regExp.hasMatch(value)) {
    return ('Enter valid name(Min. 3 character)');
  }
  return null;
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
