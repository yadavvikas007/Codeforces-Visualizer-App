import 'dart:collection';

import 'package:codeforces_visualizer/screens/singleUserDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:codeforces_visualizer/screens/singleUserScreenModels/submissions.dart'
    as sub;

late LinkedHashMap sortedTagsMap;

List<PieData> verdictsFromData(List<sub.Result> subData) {
  Map<String, double> mp = {};
  subData.forEach((v) {
    (mp.containsKey('${v.verdict}'))
        ? mp["${v.verdict}"] = mp["${v.verdict}"]! + 1.0
        : mp['${v.verdict}'] = 1.0;
  });
  var sortedKeys = mp.keys.toList(growable: false)
    ..sort((k1, k2) => mp[k2]!.compareTo(mp[k1]!));
  LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
      key: (k) => k, value: (k) => mp[k]);

  List<PieData> data = [];
  int i = 0;
  sortedMap.forEach((k, v) {
    if (v > 0) {
      data.add(new PieData(
          name: k,
          value: v,
          color: PieChartColors[((i++) % PieChartColors.length)]));
    }
  });
  return data;
}

List<PieData> tagsFromData(List<sub.Result> subData) {
  Map<String, double> mp = {};
  Set<String> st = {};
  subData.forEach((v) {
    String key = "${v.problem.contestId} ${v.problem.name} ${v.problem.index}";
    if ((v.verdict == "OK" || v.verdict == "PARTIAL") && !st.contains(key)) {
      v.problem.tags.forEach((ele) {
        (mp.containsKey('$ele'))
            ? mp["$ele"] = mp["$ele"]! + 1.0
            : mp['$ele'] = 1.0;
      });
      st.add(key);
    }
  });
  var sortedTagsKeys = mp.keys.toList(growable: false)
    ..sort((k1, k2) => mp[k2]!.compareTo(mp[k1]!));
  sortedTagsMap = new LinkedHashMap.fromIterable(sortedTagsKeys,
      key: (k) => k, value: (k) => mp[k]);

  List<PieData> data = [];
  int i = 0;
  sortedTagsMap.forEach((k, v) {
    if (v > 0) {
      data.add(new PieData(
          name: k,
          value: v,
          color: PieChartColors[((i++) % PieChartColors.length)]));
    }
  });
  return data;
}

class PieData {
  late final String name;
  final double value;
  final Color color;
  PieData({required this.name, required this.value, required this.color});
}
