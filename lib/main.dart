/*
Copyright 2024 Cloud Software Inc.

NOTICE: This code is provided to Wisal Loussif for non-commercial use only.

This code is the intellectual property of Cloud Software Inc. and is protected by copyright laws.
It is provided to Wisal Loussif for their personal, non-commercial use only.
Any commercial use, reproduction, or distribution of this code is strictly prohibited without explicit permission from Cloud Software Inc.

Please respect our intellectual property rights and adhere to the terms of non-commercial usage.

Thank you for your understanding.
*/


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
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
        theme: myTheme,
        initialRoute: '/',
        routes: {
          '/': (context) =>const Wrapper(),
          '/auth': (context) =>const MainAuth(),
          '/home': (context) =>const UserWrapper(),
        },
      ),
    );
  }
}
