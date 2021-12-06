import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:monster_smiths_experiments/widgets/Todo/TodoPage.dart';
import 'package:monster_smiths_experiments/widgets/home/settingsThemePage/SettingsThemePage.dart';
import 'package:package_info/package_info.dart';

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
                child: Image.asset('assets/icon.png', height: Theme.of(context).textTheme.headline1.fontSize),
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
                        color: Theme.of(context).colorScheme.background,
                        child: ListTile(
                          leading: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          title: Text('Todo'),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TodoPage())),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.background,
                        child: ListTile(
                          leading: Icon(RpgAwesome.perspective_dice_six,
                              color: Colors.red),
                          title: Text('Random'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      snapshot.data.version,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    );
                  return LinearProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.color_lens),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsThemePage())),
      ),
    );
  }
}
