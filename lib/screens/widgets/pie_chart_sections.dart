import 'package:codeforces_visualizer/screens/data/pie_data.dart';
import 'package:codeforces_visualizer/screens/singleUserScreenModels/submissions.dart'
    as sub;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<PieChartSectionData> getSectionsVerdicts(
        int touchedIndex, List<sub.Result> subData) =>
    verdictsFromData(subData)
        .asMap()
        .map<int, PieChartSectionData>((int index, PieData data) {
          final isTouched = index == touchedIndex;
          final double radius = isTouched ? 90 : 80;

          final value = PieChartSectionData(
            color: data.color,
            showTitle: false,
            value: data.value,
            badgeWidget: isTouched
                ? Text(
                    data.name == "OK"
                        ? "ACCEPTED\n${data.value.toInt()}"
                        : "${data.name}\n${data.value.toInt()}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  )
                : null,
            badgePositionPercentageOffset: 1.0,
            radius: radius,
          );
          return MapEntry(index, value);
        })
        .values
        .toList();

List<PieChartSectionData> getSectionsTags(
        int touchedIndex, List<sub.Result> subData) =>
    tagsFromData(subData)
        .asMap()
        .map<int, PieChartSectionData>((int index, PieData data) {
          final isTouched = index == touchedIndex;
          final double radius = 80;
          final value = PieChartSectionData(
            color: data.color,
            value: data.value,
            showTitle: false,
            badgeWidget: isTouched
                ? Text(
                    "${data.name}\n${data.value.toInt()}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  )
                : null,
            badgePositionPercentageOffset: 1.0,
            radius: radius,
          );
          return MapEntry(index, value);
        })
        .values
        .toList();
