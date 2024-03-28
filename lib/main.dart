import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/providers/role_provider.dart';
import 'package:inside_company/providers/users_list.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:inside_company/firebase_options.dart';
import 'package:inside_company/wrapper.dart';
 // Import your UserListProvider

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
        
        ChangeNotifierProvider(create: (_) => UserListProvider()), // Example: UserListProvider
        ChangeNotifierProvider(create: (_) => RoleListProvider()), // Example: UserListProvider
        
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
        },
      ),
    );
  }
}
