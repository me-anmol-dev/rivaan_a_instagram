import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivaan_a_instagram/utilities/global_variables.dart';
import '../providers/provider_list.dart';

class ResponsiveLayout extends ConsumerStatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  ConsumerState createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends ConsumerState<ResponsiveLayout> {
  // @override
  // void initState() {
  //   super.initState();
  //   addData();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(userProvider).refreshUser();
  }


  // addData() async {
  //   // final _userProvider = Provider.of<UserProvider>(context, listen: false);
  //   // await _userProvider.refreshUser();
  //
  // }

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
