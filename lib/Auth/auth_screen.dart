import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/Auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _signUpFormKey = GlobalKey<FormState>();
   var _isLogin = true;
   final TextEditingController _emailController = TextEditingController();
  
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
   
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc,AuthState>(
     
        listenWhen: (previous,current)=> current is AuthActionState,
        buildWhen: (previous,current)=> current is! AuthActionState,
        listener: (context, state) {
            if(state is AuthError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
        },
        builder: (BuildContext context, state) {  
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: 
         
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
                
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(height: 16),
                
                // Heading
                Text(
                  _isLogin?"Let's get started!":"Welcome back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32),
                       Form(
                        key: _signUpFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                fillColor: Colors.grey[100],
                                filled: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide.none),
                                ),
                              keyboardType: TextInputType.emailAddress,
                              
                              autocorrect: false,
                              
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || 
                                    value.trim().isEmpty || 
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                
                              },
                            ),
                            SizedBox(height: 32),
                            TextFormField(
                              controller: _passwordController,
                              decoration:  InputDecoration(
                                labelText: 'Password',
                                fillColor: Colors.grey[100],
                                filled: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide.none),
                                ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                               
                              },
                            ),
                            const SizedBox(height: 32),
                            
                              Column(
                                children: [
                                   ElevatedButton(
                  onPressed: () {
                    if(_isLogin){
                      context.read<AuthBloc>().add(SignUpEvent(email: _emailController.text, password: _passwordController.text));
                    }else{
                      context.read<AuthBloc>().add(SignInEvent(email: _emailController.text, password: _passwordController.text));
                    }
                    
                  },
                 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 108, 99, 255),
                    minimumSize: Size(160, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    
                  ),
                  
                   child: Text(
                    _isLogin?'Sign up':'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                                 SizedBox(height: 24),
                
                Text(
                  _isLogin?'Or sign up with':'or log in with',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 24),
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(Colors.blue, Icons.facebook),
                    SizedBox(width: 16),
                    _socialButton(Colors.red, Icons.g_mobiledata),
                    SizedBox(width: 16),
                    _socialButton(Colors.black, Icons.apple),
                  ],
                ),
                SizedBox(height: 24),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin?'Already an account? ':"Don't have an account?" ,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => LoginScreen()),
                        // );
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                       _isLogin? 'Log in':'Get started',
                        style: TextStyle(
                          color: Color.fromARGB(255, 108, 99, 255),
                          fontWeight: FontWeight.bold,
                          
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
                   
                  
              ]
                    ),
          ),
                  
                );
        }
              ),
              
    );
  }

   Widget _socialButton(Color color, IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}


