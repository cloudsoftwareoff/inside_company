import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/providers/role_provider.dart';
import 'package:inside_company/providers/users_list.dart';
import 'package:inside_company/user_wrapper.dart';
import 'package:inside_company/views/auth/main_auth.dart';
import 'package:provider/provider.dart'; 
import 'package:inside_company/firebase_options.dart';
import 'package:inside_company/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserListProvider()), 
        ChangeNotifierProvider(
            create: (_) => RoleListProvider()),
        ChangeNotifierProvider(
            create: (_) => CurrentUserProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/auth': (context) => MainAuth(),
          '/home': (context) => UserWrapper(),
        },
      ),
    );
  }
}
