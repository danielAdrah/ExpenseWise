// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';

class AccountTile extends StatelessWidget {
  final String title;
  final String budget;
  final String currency;
  final IconData icon;
  const AccountTile({
    super.key,
    required this.title,
    required this.budget,
    required this.icon,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: const [
              Color(0XFF5A31F4),
              Color(0XFF8B5CF6),
            ]),
          ),
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // color: theme.surface,
              // border: Border.all(
              //   width: 1.5,
              //   color: theme.inversePrimary,
              // ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
              title: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins'),
              ),
              trailing: Text('\$$budget',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Poppins')),
              subtitle: Text(currency,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Poppins')),
              textColor: TColor.white,
            ),
          ),
        ),
      ),
    );
  }
}
