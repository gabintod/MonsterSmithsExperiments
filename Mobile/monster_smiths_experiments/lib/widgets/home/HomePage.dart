import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:monster_smiths_experiments/widgets/Todo/TodoPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Material(
                  elevation: 10,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'S\'E',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).backgroundColor,
                        child: ListTile(
                          leading: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          title: Text('Todo'),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TodoPage())),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).backgroundColor,
                        child: ListTile(
                          leading: Icon(RpgAwesome.perspective_dice_six, color: Colors.red),
                          title: Text('Random'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
