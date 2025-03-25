import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModalPrimary {
  static Future<void> confirmationModal({
    required BuildContext context,
    String title = 'Confirmação',
    String content = 'Você tem certeza disso?',
    String confirmText = 'Sim',
    String cancelText = 'Não',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                onCancel?.call();
                context.pop();
              },
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () {
                onConfirm.call();
                context.pop();
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
