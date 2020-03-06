import 'package:flutter/material.dart';
import 'package:nekochan/screens/board_list_screen.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Color(0xffd7dbf1),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Nekochan',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              ListTile(
                leading: Icon(Icons.burst_mode),
                title: Text('Boards'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, BoardListScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
