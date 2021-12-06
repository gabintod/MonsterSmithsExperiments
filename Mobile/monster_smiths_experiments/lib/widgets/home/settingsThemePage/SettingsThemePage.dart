import 'package:flutter/material.dart';
import 'package:monster_smiths_experiments/widgets/home/Profiler.dart';

class SettingsThemePage extends StatefulWidget {
  @override
  _SettingsThemePageState createState() => _SettingsThemePageState();
}

class _SettingsThemePageState extends State<SettingsThemePage> {
  static List<Color> get allColors {
    List<Color> primaries = Colors.primaries.map<Color>((c) => Color(c.value)).toList();
    List<Color> accents = Colors.accents.map<Color>((c) => Color(c.value)).toList();
    primaries.addAll(accents);
    return primaries;
  }

  MaterialColor primarySwatch;
  Color accentColor;
  Brightness brightness;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        ColorScheme colorScheme = await Profiler.getColorScheme();

        if (mounted)
          setState(() {
            primarySwatch = Colors.primaries.firstWhere((color) => color.value == colorScheme?.primary?.value, orElse: () => Colors.blue);
            accentColor = colorScheme?.secondary ?? Colors.blue;
            brightness = colorScheme?.brightness ?? Brightness.light;
          });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Icon(
                    Icons.color_lens,
                    size: Theme.of(context).textTheme.headline2.fontSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    'Theme',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Brightness',
                        style: Theme.of(context).textTheme.caption),
                  ),
                  SwitchListTile(
                    title: Text(
                        brightness == Brightness.dark
                            ? 'Dark'
                            : 'Light'),
                    value: brightness == Brightness.dark,
                    onChanged: (value) {
                      setState(() {
                        setState(() => brightness = value ? Brightness.dark : Brightness.light);
                        _changeScheme();
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Primary color',
                        style: Theme.of(context).textTheme.caption),
                  ),
                  GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisCount: 6,
                    childAspectRatio: 1,
                    children: Colors.primaries
                        .map<Widget>(
                          (color) => GestureDetector(
                            onTap: () {
                              setState(() => primarySwatch = color);
                              _changeScheme();
                            },
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: color == primarySwatch ? Theme.of(context).colorScheme.secondary : null,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Secondary color',
                        style: Theme.of(context).textTheme.caption),
                  ),
                  GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisCount: 6,
                    childAspectRatio: 1,
                    children: allColors
                        .map<Widget>(
                          (color) => GestureDetector(
                            onTap: () {
                              setState(() => accentColor = color);
                              _changeScheme();
                            },
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: color.value == accentColor?.value ? Theme.of(context).colorScheme.primary : null,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeScheme() {
    Profiler.colorScheme = ColorScheme.fromSwatch(
      primarySwatch: primarySwatch,
      primaryColorDark: primarySwatch.shade900,
      accentColor: accentColor,
      // cardColor: primarySwatch,
      // backgroundColor: primarySwatch.shade300,
      // errorColor: primarySwatch,
      brightness: brightness ?? Brightness.light,
    );
    Profiler.saveColor();
  }
}
