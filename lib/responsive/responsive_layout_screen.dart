import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivaan_a_instagram/providers/user_provider.dart';

import 'package:rivaan_a_instagram/utilities/global_variables.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          // WebScreen 600
          return widget.webScreenLayout;
        }
        // Mobile Screen
        return widget.mobileScreenLayout;
      },
    );
  }
}
