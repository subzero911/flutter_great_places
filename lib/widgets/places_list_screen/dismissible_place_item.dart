import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:greatplaces/providers/places_repository.dart';

class DismissiblePlaceItem extends StatelessWidget {
  final i;
  final Function onTap;

  DismissiblePlaceItem(this.i, this.onTap);

  @override
  Widget build(BuildContext context) {
    final greatPlaces = Provider.of<PlacesRepository>(context);

    return Dismissible(
      key: ValueKey(greatPlaces.items[i].id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (dir) {
        greatPlaces.removePlace(greatPlaces.items[i].id);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: FileImage(greatPlaces.items[i].image),
        ),
        title: Text(greatPlaces.items[i].title),
        subtitle: Text(greatPlaces.items[i].location.address),
        onTap: onTap,
      ),
    );
  }
}
