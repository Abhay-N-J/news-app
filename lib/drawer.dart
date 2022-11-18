import 'package:flutter/material.dart';
import 'package:news_app/second.dart';
import 'home.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ListTile(
            title: const Text("Headlines"),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Home.route, (route) => false);
            },
          ),
          ListTile(
            title: const Text("Country News"),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Country.route, (route) => false);
            },
          )
        ],
      ),
    );
  }
}
