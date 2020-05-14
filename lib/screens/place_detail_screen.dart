import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:greatplaces/providers/places_repository.dart';
import 'package:greatplaces/screens/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  final id;

  PlaceDetailScreen(this.id);

  @override
  Widget build(BuildContext context) {
    final selectedPlace = Provider.of<PlacesRepository>(context, listen: false).findById(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: <Widget>[
          // фото
          Container(
            width: double.infinity,
            height: 250,
            child: Image.file(selectedPlace.image, fit: BoxFit.cover, width: double.infinity),
          ),
          SizedBox(height: 10),
          // адрес
          Text(
            selectedPlace.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 10),
          // карта в режиме чтения
          FlatButton(
            child: Text("View on Map"),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                    initialLocation: selectedPlace.location,
                    isSelecting: false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
