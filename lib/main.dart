import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Services/Auth/bloc/auth_bloc.dart';
import 'package:notes/Services/Auth/bloc/auth_events.dart';
import 'package:notes/Services/Auth/bloc/auth_state.dart';
import 'package:notes/Services/Auth/firebase_auth_provider.dart';
import 'package:notes/Views/EmailView.dart';
import 'package:notes/Views/Loginpage.dart';
import 'package:notes/Views/NotesView/create_update_note_view.dart';
import 'package:notes/Views/NotesView/NotesPage.dart';
import 'package:notes/Views/Registerpage.dart';
import 'package:notes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createorupdatenoteroute: (context) => CreateUpdateNoteView(),
        homeRoute: (context) => const NotesPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedOut) {
          return const LoginPage();
        } else if (state is AuthStateLoggedIn) {
          return const NotesPage();
        } else if (state is AuthStateVerificationRequired) {
          return const VerifyEmailView();
        } else if (state is AuthStateRegistering) {
          return const RegisterPage();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main() {
//   runApp(const MaterialApp(home: _HomePageState()));
// }

// class _HomePageState extends StatefulWidget {
//   const _HomePageState({Key? key}) : super(key: key);

//   @override
//   State<_HomePageState> createState() => __HomePageStateState();
// }

// class __HomePageStateState extends State<_HomePageState> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         backgroundColor: Colors.grey[900],
//         appBar: AppBar(
//           title: const Text('Counter' , style: TextStyle(color: Colors.white),),
//           backgroundColor: Colors.grey[900],
//           centerTitle: true,
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           builder: (context, state) {
//             final reason = (state is CounterStateInvalid) ? state.reason : '';
//             return Column(
//               children: [
//                 Text('Current Value: ${state.value}' , style: TextStyle(color: Colors.white),),
//                 Visibility(
//                   child: Text('Invalid Input: $reason' , style: TextStyle(color: Colors.red),),
//                   visible: state is CounterStateInvalid,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
                  
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(
//                       ),
//                       hintText: 'Enter a number',
//                       hintStyle: TextStyle(color: Colors.grey),
//                     ),
//                     keyboardType: TextInputType.number,
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),

//                 Center(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () => context.read<CounterBloc>().add(CounterEventIncrement(_controller.text)),
//                         icon: const Icon(Icons.add, color: Color.fromARGB(255, 160, 94, 236), size: 40),
//                       ),
//                       IconButton(
//                         onPressed: () => context.read<CounterBloc>().add(CounterEventDecrement(_controller.text)),
//                         icon: const Icon(Icons.remove, color: Color.fromARGB(255, 160, 94, 236), size: 40),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             );
//           },
//           listener: (context, state) {
//             _controller.clear();
//           },
//         ),
//       ),
//     );
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState({required this.value});
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value: value);
// }

// class CounterStateInvalid extends CounterState {
//   final String reason;
//   const CounterStateInvalid({required this.reason, required int previousValue})
//     : super(value: previousValue);
// }

// abstract class CounterEvent {
//   final String value;
//   const CounterEvent({required this.value});
// }

// class CounterEventIncrement extends CounterEvent {
//   const CounterEventIncrement(String value) : super(value: value);
// }

// class CounterEventDecrement extends CounterEvent {
//   const CounterEventDecrement(String value) : super(value: value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<CounterEventIncrement>((event, emit) {
//       final value = int.tryParse(event.value);
//       if (value == null) {
//         emit(CounterStateInvalid(reason: event.value, previousValue: state.value));
//       } else {
//         emit(CounterStateValid(value + state.value));
//       }
//     });
//     on<CounterEventDecrement>((event, emit) {
//       final value = int.tryParse(event.value);
//       if (value == null) {
//         emit(CounterStateInvalid(reason: event.value, previousValue: state.value));
//       } else {
//         emit(CounterStateValid(value - state.value));
//       }
//     });
//   }
// }