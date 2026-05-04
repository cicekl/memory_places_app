import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_places_app/screens/dashboard.dart';
import 'package:memory_places_app/screens/login.dart';
import 'package:memory_places_app/services/auth_service.dart';
import 'package:memory_places_app/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {

const RegisterScreen ({super.key});

@override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }

}

class _RegisterScreenState extends State<RegisterScreen> {

void _changeAuthScreen() {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => LoginScreen(),
      ),
      );
}
final _authService = AuthService();
final _formKey = GlobalKey<FormState>();  
var _enteredEmail = '';
var _enteredPassword = '';
var _enteredName = '';
final _passwordController = TextEditingController();

void _submit () async{
final isValid = _formKey.currentState!.validate();

if(!isValid) {
  return;
}
_formKey.currentState!.save();

try {
  await _authService.signUp(
    email: _enteredEmail, 
    password: _enteredPassword, 
    fullName: _enteredName);

 if (!mounted) return;   

Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (ctx) => const DashboardScreen(),
  ),
);

}catch(error) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        error is FirebaseAuthException ? error.message ?? 'Authetication failed'
        : 'Something went wrong',
      ),
    ),
  );
}

}

@override
  void dispose() {    
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create account',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                        ),
                        Text('Start capturing your favorite places',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontFamily: 'RobotoSlab',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF728B25),
                        ),
                        ),
                        const SizedBox(height: 50,),
                        TextFormField(
                          decoration:  InputDecoration(
                            labelText: 'Full name',
                            labelStyle: TextStyle(
                              color: Color(0xFF4A3728),
                              ),
                             enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xFF8A9B61)),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF8A9B61), width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if(value == null || value.trim().isEmpty) {
                              return 'Please enter a valid full name.';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredName = newValue!;
                          },
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          decoration:  InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Color(0xFF4A3728),
                              ),
                             enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xFF8A9B61)),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF8A9B61), width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if(value == null || value.trim().isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredEmail = newValue!;
                          },
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Color(0xFF4A3728),
                              ),
                             enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xFF8A9B61)),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF8A9B61), width: 2),
                            ),
                          ),
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                          if(value == null || value.trim().length < 8) {
                              return 'Password must be at least 8 characters long.';
                            }

                            return null;  
                          },
                          onSaved: (newValue) {
                            _enteredPassword = newValue!;
                          },
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirm password',
                            labelStyle: TextStyle(
                              color: Color(0xFF4A3728),
                              ),
                             enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xFF8A9B61)),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF8A9B61), width: 2),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                          if(value == null || value.trim().length < 8) {
                              return 'Please confirm your password.';
                            }

                          if (value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }

                            return null;  
                          },
                        ),
                        const SizedBox(height: 30,),
                        PrimaryButton(btnText: 'Create Account', onPress: _submit),
                        const SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15,
                          ),
                          ),
                          const SizedBox(width: 10,),
                          InkWell(
                            onTap: () => _changeAuthScreen(),
                            child: Text("Sign In",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 15,
                              color: Color(0xFFEAB857),
                            ),
                            ),
                          ),
                      ]),
                      ],
                    ),
                  ),
              ),
                            )
            ],
          ),
        ),
      ),
    );
  }
}