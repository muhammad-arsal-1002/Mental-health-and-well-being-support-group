import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:marsal/arsal/splash.dart';
import 'package:marsal/arsal/getstarted.dart';
import 'package:marsal/arsal/login.dart';
import 'package:marsal/arsal/signup.dart';
import 'package:marsal/arsal/resetpassword.dart';
import 'package:marsal/arsal/dashboard.dart';
import 'package:marsal/arsal/Aitalk.dart';
import 'package:marsal/arsal/group1.dart';
import 'package:marsal/arsal/group2.dart';
import 'package:marsal/arsal/search.dart';
import 'package:marsal/arsal/creategroup.dart';
import 'package:marsal/arsal/groupdetail.dart';
import 'package:marsal/arsal/exercise.dart';
import 'package:marsal/arsal/profile.dart';
import 'package:marsal/arsal/editprofile.dart';

Future <void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    // All theme properties have been removed.
    // The app will now use Flutter's default theme.
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/getstarted': (context) => OnboardingScreen(),
      '/login': (context) => LoginWidget(),
      '/signup': (context) => SignupWidget(),
      '/resetpassword': (context) => ResetPasswordScreen(),
      '/dashboard': (context) => DashboardScreen(),
      '/Aitalk': (context) => AiTalkScreen(),
      '/group1': (context) => GroupScreen(),
      '/group2': (context) => Group2(),
      '/search': (context) => Search2Widget(),
      '/creategroup': (context) => CreateGroupScreen(),
      '/groupdetail': (context) => GroupDetail(),
      '/exercise': (context) => ExercisesScreen(),
      '/profile': (context) => Profile(),
      '/editprofile' : (context) => EditProfileWidget(),
    },
  ));
}