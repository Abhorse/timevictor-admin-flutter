import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage("assets/images/tvLogoFinal.png"),
          height: 100.0,
          width: 100.0,
        ),
        Center(
          child: Text('Hey, Welcome ton Timevector admin panel'),
        ),
      ],
    );
  }
}
