import 'package:flutter/material.dart';
import 'custom_dialog.dart';

// komponen buat implementasi dialog, parameternya pake title, message, onConfirmed, dan dialogType
// how to use:
// DialogActionButton(
//      title: 'Submit Confirmation',
//      message: 'Are you sure you want to submit?',
//      dialogType: DialogType.discard,
//      onConfirmed: () {
//             print('Confirmed!');
//      },
//             child: const Text('Submit'),
// ),

class DialogActionButton extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirmed;
  final DialogType dialogType;
  final Widget child;

  const DialogActionButton({
    super.key,
    required this.title,
    required this.message,
    required this.dialogType,
    required this.child,
    this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showCustomDialog(
        context: context,
        type: dialogType,
        title: title,
        message: message,
        onConfirmed: onConfirmed,
      ),
      child: child,
    );
  }
}
