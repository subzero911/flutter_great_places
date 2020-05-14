import 'dart:convert';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyATgvlnT7FfurXZwfb2I6hn49XxUAQz4SM';

String generateLocationPreviewImageUrl(double lat, double lng) {
  return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$GOOGLE_API_KEY';
}

Future<String> getPlaceAddress(double lat, double lng) async {
  final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&result_type=locality&key=$GOOGLE_API_KEY';
  final response = await http.get(url);
  return json.decode(response.body)['results'][0]['formatted_address'];
}
