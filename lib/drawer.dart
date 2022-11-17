import 'package:flutter/material.dart';
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
            title: const Text("Home"),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Home.route, (route) => false);
            },
          ),
          ListTile(
            title: const Text("SecondPage"),
          )
        ],
      ),
    );
  }
}
