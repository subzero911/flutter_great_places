import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:greatplaces/models/place.dart';
import 'package:greatplaces/providers/places_repository.dart';
import 'package:greatplaces/widgets/add_place_screen/location_input.dart';
import 'package:greatplaces/widgets/add_place_screen/image_input.dart';

class AddPlaceScreen extends StatefulWidget {
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
    // не нужно setState, так как мы ничего не перерисовываем
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null || _pickedLocation == null) {
      return;
    }
    Provider.of<PlacesRepository>(context, listen: false).addPlace(_titleController.text, _pickedImage, _pickedLocation);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(height: 10),
                    ImageInput(_selectImage),
                    SizedBox(height: 10),
                    LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            elevation: 0.0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
            onPressed: _savePlace,
          )
        ],
      ),
    );
  }
}
