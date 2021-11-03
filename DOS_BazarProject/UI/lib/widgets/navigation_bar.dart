import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: [
          const SizedBox(
            height: 80,
            width: 150,
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _NavBarItem(title: 'Refresh Books'),
              SizedBox(width: 60),
              _NavBarItem(title: 'Show Book info'),
              SizedBox(width: 60),
              _NavBarItem(title: 'List Orders'),
              SizedBox(width: 60),
              _NavBarItem(title: 'Deployment '),
              SizedBox(width: 60),
            ],
          )
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  const _NavBarItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18),
    );
  }
}
