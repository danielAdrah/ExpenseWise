// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryPieChart extends StatefulWidget {
  final List<MapEntry<String, double>> subcategoryData;
  final double total;
  final List<List<Color>> gradientList;

  const CategoryPieChart({
    Key? key,
    required this.subcategoryData,
    required this.total,
    required this.gradientList,
  }) : super(key: key);

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse
                        .touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _buildPieSections(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _buildLegendItems(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    return List.generate(widget.subcategoryData.length, (i) {
      final isSelected = i == touchedIndex;
      final subcategory = widget.subcategoryData[i].key;
      final value = widget.subcategoryData[i].value;
      final percentage = widget.total > 0 ? (value / widget.total * 100) : 0;

      final gradientColors = i < widget.gradientList.length
          ? widget.gradientList[i]
          : [Colors.grey, Colors.grey.shade700];

      return PieChartSectionData(
        color: gradientColors[0],
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: isSelected ? 80 : 70,
        titleStyle: TextStyle(
          fontSize: isSelected ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isSelected
            ? _Badge(
                subcategory,
                size: 40,
                borderColor: gradientColors[1],
              )
            : null,
        badgePositionPercentageOffset: .98,
      );
    });
  }

  List<Widget> _buildLegendItems() {
    return widget.subcategoryData.asMap().entries.map((entry) {
      final index = entry.key;
      final subcategory = entry.value.key;
      final value = entry.value.value;
      final percentage = widget.total > 0 ? (value / widget.total * 100) : 0;

      final gradientColors = index < widget.gradientList.length
          ? widget.gradientList[index]
          : [Colors.grey, Colors.grey.shade700];

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: gradientColors[0].withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: gradientColors[0],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$subcategory: \$${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _Badge extends StatelessWidget {
  final String category;
  final double size;
  final Color borderColor;

  const _Badge(
    this.category, {
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text(
          category.substring(0, category.length > 2 ? 2 : category.length),
          style: TextStyle(
            fontSize: size * .3,
            fontWeight: FontWeight.bold,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}