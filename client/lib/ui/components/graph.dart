import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:strawberry/ui/straw_theme.dart';
import 'package:strawberry/ui/tools/dimensions.dart';

class HomePageGraph extends StatefulWidget {
  final List<FlSpot> data;
  final Dimensions dimensions;

  const HomePageGraph({Key? key, required this.data, required this.dimensions})
      : super(key: key);

  @override
  _HomePageGraphState createState() => _HomePageGraphState();
}

class _HomePageGraphState extends State<HomePageGraph> {
  List<Color> gradientColors = [
    StrawTheme.c1,
    StrawTheme.c3,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(
        mainData(),
        swapAnimationDuration: Duration(milliseconds: 1000), // Optional
        swapAnimationCurve: Curves.linear,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: false,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: null,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
            show: false,
            border: Border.all(color: const Color(0xff37434d), width: 1)),
        minY: 0,
        maxY: 100,
        minX: widget.data.last.x - 30,
        maxX: widget.data.last.x,
        clipData: FlClipData.all(),
        lineBarsData: [
          LineChartBarData(
            spots: widget.data,
            isCurved: true,
            gradient: null,
            barWidth: 3,
            color: StrawTheme.c2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: false,
        ));
  }
}
