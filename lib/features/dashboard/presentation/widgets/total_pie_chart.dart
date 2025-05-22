import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InteractivePieChart extends StatefulWidget {
  const InteractivePieChart({super.key});

  @override
  State<InteractivePieChart> createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<InteractivePieChart> {
  int touchedIndex = -1;

  final Map<String, double> categoryData = {
    'Transportation': 350,
    'Food': 200,
    'Utilities': 120,
    'Housing': 180,
    'Shopping': 100,
    'HealthCare': 150,
    'Education': 90,
  };

  final List<Color> categoryColors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.greenAccent,
    Colors.redAccent
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 180,
              width: 180,
              child: FadeInDown(
                delay: const Duration(milliseconds: 400),
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          touchedIndex =
                              response?.touchedSection?.touchedSectionIndex ??
                                  -1;
                        });
                      },
                    ),
                    startDegreeOffset: 100,
                    centerSpaceRadius: 75,
                    sectionsSpace: 6,
                    sections: List.generate(categoryData.length, (i) {
                      final isTouched = i == touchedIndex;
                      final double fontSize = isTouched ? 15 : 14;
                      final double radius = isTouched ? 40 : 35;
                      final entry = categoryData.entries.elementAt(i);

                      return PieChartSectionData(
                        color: categoryColors[i],
                        // borderSide: ,

                        value: entry.value,
                        title: isTouched
                            ? '${entry.key}\n${entry.value.toStringAsFixed(0)}'
                            : entry.value.toStringAsFixed(0),
                        // showTitle: isTouched,
                        titleStyle: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontFamily: "Poppins",
                        ),
                        radius: radius,
                        titlePositionPercentageOffset: 0.5,
                      );
                    }),
                  ),
                ),
              ),
            ),
            ZoomInDown(
              delay: const Duration(milliseconds: 500),
              child: Text(
                "Expenses",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: 'Arvo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        // Optional: Legend
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: List.generate(categoryData.length, (i) {
            return ZoomIn(
              delay: const Duration(milliseconds: 800),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: categoryColors[i],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    categoryData.keys.elementAt(i),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontFamily: 'Poppins',
                    ),
                  )
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
