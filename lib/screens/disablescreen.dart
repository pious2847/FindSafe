import 'package:flutter/material.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  Widget build(BuildContext context) {
    return screenLock(
      context: context,
      correctString: '1234',
      canCancel: false,
    );
  }
}
