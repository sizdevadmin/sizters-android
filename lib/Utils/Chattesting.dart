import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:siz/Utils/Colors.dart';

class BarChartSample2 extends StatefulWidget {
  const BarChartSample2({super.key});
  final Color leftBarColor = Colors.black;
  final Color rightBarColor = Colors.black;
  final Color avgColor = MyColors.themecolor;

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

final titles = <String>['Aug', 'Sept', 'Oct', 'Nov', 'Nov', 'St', 'Su'];

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 5);
    final barGroup2 = makeGroupData(1, 7,);
    final barGroup3 = makeGroupData(2, 18,);
    final barGroup4 = makeGroupData(3, 20);
    final barGroup5 = makeGroupData(4, 17);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 300,
            width: 200,
            child: BarChart(
              BarChartData(
                maxY: 20,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey,
                    getTooltipItem: (a, b, c, d) => null,
                  ),
                  touchCallback: (FlTouchEvent event, response) {
                    if (response == null || response.spot == null) {
                      setState(() {
                        touchedGroupIndex = -1;
                        showingBarGroups = List.of(rawBarGroups);
                      });
                      return;
                    }

                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                    setState(() {
                      if (!event.isInterestedForInteractions) {
                        touchedGroupIndex = -1;
                        showingBarGroups = List.of(rawBarGroups);
                        return;
                      }
                      showingBarGroups = List.of(rawBarGroups);
                      if (touchedGroupIndex != -1) {
                        var sum = 0.0;
                        for (final rod
                            in showingBarGroups[touchedGroupIndex].barRods) {
                          sum += rod.toY;
                        }
                        final avg = sum /
                            showingBarGroups[touchedGroupIndex].barRods.length;

                        showingBarGroups[touchedGroupIndex] =
                            showingBarGroups[touchedGroupIndex].copyWith(
                          barRods: showingBarGroups[touchedGroupIndex]
                              .barRods
                              .map((rod) {
                            return rod.copyWith(
                                toY: avg, color: widget.avgColor);
                          }).toList(),
                        );
                      }
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 100,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: showingBarGroups,
                gridData: const FlGridData(show: true),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: MyColors.themecolor,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    if (value == 0) {
      text = 'AED 0';
    } else if (value == 5) {
      text = 'AED 500';
    } else if (value == 10) {
      text = 'AED 1000';
    } else if (value == 15) {
      text = 'AED 1500';
    } else if (value == 20) {
      text = 'AED 2000';
    } else if (value == 25) {
      text = 'AED 2500';
    } else if (value == 30) {
      text = 'AED 3000';
    } else if (value == 35) {
      text = 'AED 3500';
    } else if (value == 40) {
      text = 'AED 4000';
    } else if (value == 45) {
      text = 'AED 4500';
    } else if (value == 50) {
      text = 'AED 5000';
    } else if (value == 55) {
      text = 'AED 5500';
    } else if (value == 60) {
      text = 'AED 6000';
    } else if (value == 65) {
      text = 'AED 6500';
    } else if (value == 70) {
      text = 'AED 7000';
    } else if (value == 75) {
      text = 'AED 7500';
    } else if (value == 80) {
      text = 'AED 8000';
    } else if (value == 85) {
      text = 'AED 8500';
    } else if (value == 90) {
      text = 'AED 9000';
    } else if (value == 95) {
      text = 'AED 9500';
    } else if (value == 100) {
      text = 'AED 10000';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.black,
          width: 20,
        ),
      ],
    );
  }
}
