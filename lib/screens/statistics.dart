import 'package:flutter/material.dart';
import 'package:memory_places_app/widgets/progress_card.dart';
import 'package:memory_places_app/widgets/statistic_card.dart';

class StatisticsScreen extends StatefulWidget{

const StatisticsScreen ({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
 void _close() {
    Navigator.of(context).pop();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      toolbarHeight: 130,
      automaticallyImplyLeading: false,
      title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statistics',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 32,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,),
                ),
              Text('Your memory places insights',
              maxLines: 2,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF728B25),),),
            ],), 
        actions: [
        IconButton(
          onPressed: () {
            _close();
        }, 
        icon: Icon(Icons.close))
      ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                         shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children:[ 
                          StatisticCard(
                          statisticNumber: '24', 
                          title: 'Total Places', 
                          icon: Icons.pin_drop_outlined),
                          StatisticCard(
                          statisticNumber: '12', 
                          title: 'Total Photos', 
                          icon: Icons.camera_alt_outlined),
                          StatisticCard(
                          statisticNumber: '120', 
                          title: 'Total Visits', 
                          icon: Icons.trending_up),
                          StatisticCard(
                          statisticNumber: '3', 
                          title: 'This Week', 
                          icon: Icons.calendar_today_outlined),
                      ],
                  ),
                const SizedBox(height: 20,),
                Text('Places by Category',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Color(0xFF728B25),
                  fontSize: 16,
                ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView(
                      children: [
                        ProgressCard(
                          categoryName: 'Coffee',
                          number: '12',
                          color: Color(0xFF4A3728),
                        ),
                        const SizedBox(height: 15),
                        ProgressCard(
                          categoryName: 'Parks',
                          number: '9',
                          color: Color(0xFF728B25),),
                          const SizedBox(height: 15),
                        ProgressCard(
                          categoryName: 'Date',
                          number: '15',
                          color: Color(0xFFC96A4A),),
                          const SizedBox(height: 15),
                        ProgressCard(
                          categoryName: 'Restaurants',
                          number: '6',
                          color: Color(0xFFE8B84D),),
                        ],
                      ),
                ),
                ),
              const SizedBox(height: 20,),
              Text('Most Popular',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Color(0xFF728B25),
                  fontSize: 16,
                ),
                ),
              const SizedBox(height: 10,),
              Container(
                height: 130,
                width: double.infinity,
               decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF4A3728),
                  Color.fromARGB(255, 128, 96, 72),
                ]),
                borderRadius: BorderRadius.circular(20),
               ),
               child: Padding(
                 padding: const EdgeInsets.all(10),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Text('Your favorite category',
                     style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                      color: Colors.white,
                     ),),
                     Text('Coffee',
                     style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                     ),),
                     Text('15 places • 63% of collection',
                     style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                      color: Colors.white,
                     ),),
                   ],
                 ),
               ), 
              )  
              ], 
          ),
        ),
      ),
   );
  }
}