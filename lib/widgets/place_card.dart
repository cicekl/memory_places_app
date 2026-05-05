import 'package:flutter/material.dart';

class PlaceCard extends StatefulWidget{

  const PlaceCard ({super.key});


@override
  State<PlaceCard> createState() {
   return _PlaceCardState();
  }


}

class _PlaceCardState extends State<PlaceCard> {


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => {},
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network('https://i.pinimg.com/736x/89/be/69/89be69d7de3f535a30266794f19028bc.jpg',
              height: 140,
              width: 180,
              fit: BoxFit.cover,),
            ),
            const SizedBox(height: 10,),
            Text('Campus Caffe',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
            ),
            const SizedBox(height: 8,),
            Text('2 days ago',
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