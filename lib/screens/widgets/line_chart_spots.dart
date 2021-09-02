import 'package:codeforces_visualizer/screens/data/line_chart_data.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:codeforces_visualizer/screens/singleUserScreenModels/ratingChanges.dart'
    as rat;
import 'package:flutter/material.dart';

List<LineChartBarData> getSpotsRatingsTimeline(
    List<rat.Result> ratingData1, List<rat.Result> ratingData2) {
  List<Data> data1 = ratingTimeline2users(ratingData1);
  List<Data> data2 = ratingTimeline2users(ratingData2);

  List<LineChartBarData> lines = [];
  LineChartBarData line1 = new LineChartBarData(
    barWidth: 3,
    colors: [
      Colors.green,
    ],
    spots: getSpots(data1),
  );
  LineChartBarData line2 = new LineChartBarData(
    barWidth: 3,
    colors: [
      Colors.blue,
    ],
    spots: getSpots(data2),
  );
  lines.add(line1);
  lines.add(line2);
  return lines;
}

List<LineChartBarData> getSpotsRatingsTimelineSingleUser(
    List<rat.Result> ratingData) {
  List<Data> data1 = ratingTimeline2users(ratingData);

  List<LineChartBarData> lines = [];
  LineChartBarData line1 = new LineChartBarData(
    barWidth: 3,
    colors: [
      Colors.indigo,
    ],
    spots: getSpots(data1),
  );
  lines.add(line1);
  return lines;
}

List<FlSpot> getSpots(List<Data> data) {
  List<FlSpot> spots = [];
  data.forEach((element) {
    FlSpot spot = new FlSpot(element.name1, element.value1);
    spots.add(spot);
  });
  return spots;
}
