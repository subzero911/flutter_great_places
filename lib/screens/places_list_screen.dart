import 'package:flutter/material.dart';
import 'package:greatplaces/providers/places_repository.dart';
import 'package:greatplaces/screens/add_place_screen.dart';
import 'package:greatplaces/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your places"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<PlacesRepository>(context, listen: false).fetchPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<PlacesRepository>(
                builder: (ctx, greatPlaces, child) => greatPlaces.items.length <= 0
                    ? child
                    : ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(greatPlaces.items[i].image),
                          ),
                          title: Text(greatPlaces.items[i].title),
                          subtitle: Text(greatPlaces.items[i].location.address),
                          onTap: () {
                            // go to detail page
                            Navigator.pushNamed(
                              context,
                              PlaceDetailScreen.routeName,
                              arguments: greatPlaces.items[i].id,
                            );
                          },
                        ),
                      ),
                child: Center(
                  child: const Text('Got no places yet. Start adding some!'),
                ),
              ),
      ),
    );
  }
}
