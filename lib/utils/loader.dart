

 void _showLoadingDialog() {
    showDialog(
      barrierDismissible: false, // User can't dismiss the dialog by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }