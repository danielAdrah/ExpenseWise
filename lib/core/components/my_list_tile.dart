import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  final String type;
  final String title;
  final String price;
  final DateTime date;

  const MyListTile({
    super.key,
    required this.type,
    required this.title,
    required this.price,
    required this.date,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1.5,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 6),
                blurRadius: 12,
                // blurStyle: BlurStyle.outer,
              )
            ],
          ),
          child: ListTile(
            leading: Image.asset(
              "assets/img/homeAppliances_cat.png",
              width: 40,
              height: 40,
            ),
            //  Icon(
            //   Icons.fastfood_outlined,
            //   size: 33,
            //   color: Theme.of(context).colorScheme.inversePrimary,
            // ),
            title: Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontFamily: 'Arvo',
              ),
            ),
            subtitle: Text(
              '${widget.date.day}/${widget.date.month}/${widget.date.year}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontFamily: 'Arvo',
                fontSize: 13,
              ),
            ),
            trailing: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.type,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: 'Arvo',
                    fontSize: 13,
                  ),
                ),
                Text(
                  '\$${widget.price}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: 'Arvo',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            textColor: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }
}
