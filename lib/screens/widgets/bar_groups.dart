import 'package:codeforces_visualizer/screens/data/bar_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:codeforces_visualizer/screens/singleUserScreenModels/submissions.dart'
    as sub;
import 'package:fl_chart/fl_chart.dart';

List<BarChartGroupData> get_ratings_bars(
    int touchedIndex, List<sub.Result> subData) {
  List<Data> data = ratingsBarsFromData(subData);
  List<BarChartGroupData> bdata = [];
  data.forEach(
    (element) {
      if (element.name > 0) {
        BarChartGroupData d = new BarChartGroupData(
          x: element.name,
          barRods: [
            BarChartRodData(
              y: element.value,
              colors: [Colors.indigo],
              width: 30,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
            ),
          ],
        );
        bdata.add(d);
      }
    },
  );
  return bdata;
}

int f(String s) {
  if (s == "A") return 1;
  if (s == "B") return 2;
  if (s == "C") return 3;
  if (s == "D") return 4;
  if (s == "E") return 5;
  if (s == "F") return 6;
  if (s == "G") return 7;
  if (s == "H") return 8;
  if (s == "I") return 9;
  if (s == "J") return 10;
  if (s == "K") return 11;
  if (s == "L") return 12;
  if (s == "M") return 13;
  if (s == "N") return 14;
  if (s == "O") return 15;
  if (s == "P") return 16;
  if (s == "Q") return 17;
  if (s == "R") return 18;
  if (s == "S") return 19;
  if (s == "T") return 20;
  if (s == "U") return 21;
  if (s == "V") return 22;
  if (s == "W") return 23;
  if (s == "X") return 24;
  if (s == "Y") return 25;
  if (s == "Z") return 26;
  return 0;
}

String f1(int s) {
  if (s == 1) return "A";
  if (s == 2) return "B";
  if (s == 3) return "C";
  if (s == 4) return "D";
  if (s == 5) return "E";
  if (s == 6) return "F";
  if (s == 7) return "G";
  if (s == 8) return "H";
  if (s == 9) return "I";
  if (s == 10) return "J";
  if (s == 11) return "K";
  if (s == 12) return "L";
  if (s == 13) return "M";
  if (s == 14) return "N";
  if (s == 15) return "O";
  if (s == 16) return "P";
  if (s == 17) return "Q";
  if (s == 18) return "R";
  if (s == 19) return "S";
  if (s == 20) return "T";
  if (s == 21) return "U";
  if (s == 22) return "V";
  if (s == 23) return "W";
  if (s == 24) return "X";
  if (s == 25) return "Y";
  if (s == 26) return "Z";
  return " ";
}

List<BarChartGroupData> get_indexes_bars(
    int touchedIndex, List<sub.Result> subData) {
  List<Data1> data = levelsBarsFromData(subData);
  List<BarChartGroupData> bdata = [];
  data.forEach(
    (element) {
      if (f(element.name) != 0) {
        BarChartGroupData d = new BarChartGroupData(
          x: f(element.name),
          barRods: [
            BarChartRodData(
              y: element.value,
              colors: [Colors.indigo],
              width: 30,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
            ),
          ],
        );
        bdata.add(d);
      }
    },
  );
  return bdata;
}

List<BarChartGroupData> getLevelsCompare(
    List<sub.Result> subData1, List<sub.Result> subData2) {
  List<Data2> data = levelsFor2Users(subData1, subData2);
  List<BarChartGroupData> bdata = [];
  data.forEach(
    (element) {
      if (f(element.name1) != 0) {
        BarChartGroupData d = new BarChartGroupData(
          x: f(element.name1),
          barRods: [
            BarChartRodData(
              y: element.value1,
              colors: [Colors.green],
              width: 30,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
            ),
            BarChartRodData(
              y: element.value2,
              colors: [Colors.blue],
              width: 30,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
            ),
          ],
        );
        bdata.add(d);
      }
    },
  );
  return bdata;
}

List<BarChartGroupData> getRatingsCompare(
    List<sub.Result> subData1, List<sub.Result> subData2) {
  List<Data3> data = ratingsFor2Users(subData1, subData2);
  List<BarChartGroupData> bdata = [];
  data.forEach(
    (element) {
      if (element.name1 > 0) {
        BarChartGroupData d = new BarChartGroupData(
          x: element.name1,
          barRods: [
            BarChartRodData(
              y: element.value1,
              colors: [Colors.green],
              width: 30,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
            ),
            BarChartRodData(
              y: element.value2,
              colors: [Colors.blue],
              width: 30,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
            ),
          ],
        );
        bdata.add(d);
      }
    },
  );
  return bdata;
}
