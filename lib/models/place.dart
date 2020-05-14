import 'dart:io';

import 'package:flutter/foundation.dart';

class PlaceLocation {
  final double latitude, longitude;
  final String address; // human-readable

  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place({
    @required this.id,
    this.title,
    this.location,
    this.image,
  });
}
