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
    final theme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1.5,
              color: theme.inversePrimary,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: Icon(
              icon,
              color: theme.inversePrimary,
              size: 30,
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.inversePrimary,
                  fontFamily: 'Poppins'),
            ),
            trailing: Text(budget,
                style: TextStyle(
                    color: theme.inversePrimary,
                    fontSize: 12,
                    fontFamily: 'Poppins')),
            subtitle: Text(currency,
                style: TextStyle(
                    color: theme.inversePrimary,
                    fontSize: 10,
                    fontFamily: 'Poppins')),
            textColor: TColor.white,
          ),
        ),
      ),
    );
  }
}
