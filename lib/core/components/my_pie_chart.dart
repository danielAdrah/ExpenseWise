// ignore_for_file: prefer_for_elements_to_map_fromiterable, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../features/dashboard/data/models/pie_chart_model.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;

    // Static PieChartData
    List<PieChartData> pieChartData = [
      PieChartData("Food", 32),
      PieChartData("Utilities", 30),
      PieChartData("Transport", 45),
      // PieChartData("Education", 35),
      // PieChartData("Other", 60),
    ];
    List<PieChartData> emptyPieChartData = [
      PieChartData("", 0),
      PieChartData("", 0),
      PieChartData("", 0),
      // PieChartData("Education", 35),
      // PieChartData("Other", 60),
    ];
    final gradientList = <List<Color>>[
      [
        Color(0xFF17a2b8),
        Color(0xFF0d9488),
        Color(0xFF0f766e),
      ],
      [
        Color(0xFFc6d8ff),
        Color(0xFFa855f7),
        Color(0xFF9333ea),
      ],
      [
        Color(0xFFf59e0b),
        Color(0xFFef4444),
        Color(0xFFfb923c),
      ]
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: PieChart(
        dataMap: Map.fromIterable(pieChartData,
            key: (data) => data.label, value: (data) => data.value),

        animationDuration: Duration(milliseconds: 800),
        chartRadius: MediaQuery.of(context).size.width / 2.5,
        chartType: ChartType.ring,
        ringStrokeWidth: 30,
        gradientList: gradientList,
        chartLegendSpacing: 40,
        // centerText:
        //     controller.pieInfo.isEmpty ? "Selecet an account\n first" : "",
        // centerTextStyle: TextStyle(
        //     color:
        //         controller.pieInfo.isEmpty ? TColor.gray50 : TColor.gray),
        legendOptions: LegendOptions(
          // showLegends: controller.pieInfo.isEmpty ? false : true,
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontFamily: 'Arvo',
              fontSize: 16),
        ),
        chartValuesOptions: ChartValuesOptions(
          chartValueStyle:
              TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
        ),
      ),
    );
  }
}
