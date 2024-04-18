import 'package:flutter/material.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LostModeScreen extends StatefulWidget {
  @override
  _LostModeScreenState createState() => _LostModeScreenState();
}

class _LostModeScreenState extends State<LostModeScreen> {
  bool _isLostModeEnabled = false;
  final int _activationCode = 12345;

  void _toggleLostMode(bool value) {
    setState(() {
      _isLostModeEnabled = value;
    });

    if (_isLostModeEnabled) {
      Fluttertoast.showToast(
        msg:
            'Lost mode activated. Phone cannot be turned off without password.',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost Mode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Lost Mode',
              style: TextStyle(fontSize: 24.0),
            ),
            Switch(
              value: _isLostModeEnabled,
              onChanged: _toggleLostMode,
            ),
            if (_isLostModeEnabled)
              Text(
                'Phone in lost mode. Please activate to use.',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isLostModeEnabled) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LockScreen(
                  onSuccess: () {
                    // Add any actions you want to perform after successful unlock
                    Navigator.pop(context);
                  },
                  showWrongPassDialog: true,
                  wrongPassContent: "Wrong pass please try again.",
                  wrongPassTitle: "Opps!",
                  wrongPassCancelButtonText: "Cancel",
                  title: 'Enter Activation Code',
                  passLength: 5, // Assuming the activation code is 5 digits
                  passCodeVerify: (passcode) async {
                    var myPass = [1, 2, 3, 4];
                    for (int i = 0; i < myPass.length; i++) {
                      if (passcode[i] != myPass[i]) {
                        return false;
                      }
                    }

                    return true;
                  },
                ),
              ),
            );
          }
        },
        child: Icon(Icons.lock),
      ),
    );
  }
}

