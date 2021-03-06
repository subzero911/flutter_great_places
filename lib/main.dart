import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greatplaces/screens/add_place_screen.dart';
import 'package:provider/provider.dart';
import 'package:greatplaces/providers/places_repository.dart';
import 'package:greatplaces/screens/places_list_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => PlacesRepository(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlacesListScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AddPlaceScreen.routeName:
              return CupertinoPageRoute(builder: (ctx) => AddPlaceScreen());
            default:
              return null;
          }
        },
      ),
    );
  }
}
