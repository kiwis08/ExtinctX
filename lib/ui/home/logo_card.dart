import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoCard extends StatelessWidget {
  const LogoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Color(0xFF1F3A37),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Image.asset(
        'assets/extinctx_logo.png',
      ),
    );
  }
}
