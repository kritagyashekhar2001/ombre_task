import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ombre_task/screens/home_screen/bloc/add_likes_and_comment/add_likes_and_comment_bloc.dart';
import 'package:ombre_task/screens/onboarding_screens/bloc/login_bloc.dart';
import 'package:ombre_task/screens/onboarding_screens/login_screen.dart';

import 'screens/home_screen/bloc/video_upload_bloc/video_upload_bloc.dart';
import 'screens/home_screen/home_screen.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

Map<String, Widget Function(BuildContext)> routeLinks = {
  '/': (_) => _auth.currentUser == null
      ? BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginScreen(),
        )
      : BlocProvider(
          create: (context) => AddLikesAndCommentBloc(),
          child: VideoScreen(),
        ),
  '/addVideoScreen': (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => VideoUploadBloc()),
          BlocProvider(create: (context) => AddLikesAndCommentBloc()),
        ],
        child: VideoScreen(),
      ),
};
