import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greatplaces/helpers/location_helper.dart' as locationHelper;
import 'package:greatplaces/models/place.dart';
import 'package:greatplaces/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = locationHelper.generateLocationPreviewImageUrl(lat, lng);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      // user did not grant permission or internet fails
      print(error);
      return;
    }
  }

  Future<void> _selectOnMap() async {
    try {
      final currentLocation = await Location().getLocation();
      final selectedLocation = await Navigator.push<LatLng>(
          context,
          MaterialPageRoute(
            builder: (ctx) => MapScreen(
              initialLocation: PlaceLocation(
                latitude: currentLocation.latitude,
                longitude: currentLocation.longitude,
              ),
              isSelecting: true,
            ),
            fullscreenDialog: true,
          ));
      if (selectedLocation == null) return;
      _showPreview(selectedLocation.latitude, selectedLocation.longitude);
      widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
    } catch (error) {
      print(error);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 170,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text("No location chosen", textAlign: TextAlign.center)
              : Image.network(_previewImageUrl, fit: BoxFit.cover, width: double.infinity),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select on map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
