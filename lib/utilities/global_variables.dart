import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rivaan_a_instagram/screens/add_post_screen.dart';
import 'package:rivaan_a_instagram/screens/feed_screen.dart';
import 'package:rivaan_a_instagram/screens/search_screen.dart';

import '../screens/profile_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  const Center(child: Text('Favourites')),
  ProfileScreen(currentOrFoundUid: FirebaseAuth.instance.currentUser!.uid),
];
