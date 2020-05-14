import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:greatplaces/helpers/db_helper.dart' as db;
import 'package:greatplaces/helpers/location_helper.dart' as locationHelper;
import 'package:uuid/uuid.dart';
import 'package:greatplaces/models/place.dart';

class PlacesRepository with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String title,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await locationHelper.getPlaceAddress(pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final newPlace = Place(
      id: Uuid().v4(),
      image: pickedImage,
      title: title,
      location: updatedLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> removePlace(String id) async {
    final index = _items.indexWhere((place) => place.id == id);
    if (_items[index].image.existsSync()) {
      _items[index].image.deleteSync();
    }
    _items.removeAt(index);
    notifyListeners();
    await db.delete('user_places', id);
  }

  Future<void> fetchPlaces() async {
    final dataList = await db.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                address: item['address'],
              ),
            ))
        .toList();
    notifyListeners();
  }
}
