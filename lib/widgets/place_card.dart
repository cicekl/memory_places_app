import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memory_places_app/models/place.dart';

final formatter = DateFormat.yMd();

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    super.key,
    required this.onSelectPlace,
    required this.place,
  });

  final void Function() onSelectPlace;
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onSelectPlace();
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                place.imageUrl ??
                    'https://i.pinimg.com/736x/89/be/69/89be69d7de3f535a30266794f19028bc.jpg',
                height: 140,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              place.title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              formatter.format(place.lastVisit),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF846A37),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
