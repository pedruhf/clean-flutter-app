import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const SimpleDialog(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(
                  'Aguarde...',
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],
        );
      });
}

void hideLoading(BuildContext context) {
  if (!Navigator.canPop(context)) return;
  Navigator.of(context).pop();
}
