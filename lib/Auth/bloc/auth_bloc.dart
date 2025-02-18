import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
        try{
          final UserCredential userCredential= await _auth.createUserWithEmailAndPassword(
            email: event.email, 
            password: event.password,
            );
         
       String uid = userCredential.user!.uid;
       await FirebaseFirestore.instance.collection('Users').doc(uid).set({
      'email': event.email,
      'password': event.password, 
    });
        }on FirebaseAuthException catch(e){   
           String errorMessage;
           if (e.code == 'email-already-in-use') {
              errorMessage = 'Email is already in use. Please try another one.';
           } else {
              errorMessage = 'An unexpected error occurred. Please try again.';
             } 
              emit(AuthError(error: errorMessage));
        }
    });
    on<SignInEvent>((event, emit) async{
       final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email, 
        password: event.password,
        );
        
    });
  }
}
