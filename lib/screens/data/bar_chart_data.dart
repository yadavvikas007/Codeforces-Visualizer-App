import 'dart:math';
import 'package:codeforces_visualizer/screens/singleUserScreenModels/submissions.dart'
    as sub;

double maxRatingCount = 0.0;
double maxLevelCount = 0.0;
double maxlevel2 = 0.0;
double maxRating2 = 0.0;

List<Data> ratingsBarsFromData(List<sub.Result> subData) {
  maxRatingCount = 0.0;
  Map<int, double> mp = {};
  Set<String> st = {};
  subData.forEach((v) {
    String key = "${v.problem.contestId}+${v.problem.index}+${v.problem.name}";
    if ((v.verdict == "OK" || v.verdict == "PARTIAL") && !st.contains(key)) {
      (mp.containsKey(v.problem.rating))
          ? mp[v.problem.rating] = mp[v.problem.rating]! + 1.0
          : mp[v.problem.rating] = 1.0;
      st.add(key);
    }
  });

  List<Data> data = [];
  mp.forEach((k, v) {
    if (v > 0 && k > 0) {
      maxRatingCount = max(maxRatingCount, v);
      data.add(new Data(
        name: k,
        value: v,
      ));
    }
  });
  data.sort((a, b) => a.name.compareTo(b.name));
  return data;
}

List<Data1> levelsBarsFromData(List<sub.Result> subData) {
  maxLevelCount = 0.0;
  Map<String, double> mp = {};
  Set<String> st = {};
  subData.forEach((v) {
    String key = "${v.problem.contestId}+${v.problem.index}+${v.problem.name}";
    String t = v.problem.index;
    String char = '${t[0]}';
    if ((v.verdict == "OK" || v.verdict == "PARTIAL") && !st.contains(key)) {
      (mp.containsKey(char)) ? mp[char] = mp[char]! + 1.0 : mp[char] = 1.0;
      st.add(key);
    }
  });

  List<Data1> data = [];
  mp.forEach((k, v) {
    if (v > 0 && k != " ") {
      maxLevelCount = max(maxLevelCount, v);
      data.add(new Data1(
        name: k,
        value: v,
      ));
    }
  });
  data.sort((a, b) => a.name.compareTo(b.name));
  return data;
}

class Data1 {
  final String name;
  final double value;
  Data1({required this.name, required this.value});
}

class Data {
  final int name;
  final double value;
  Data({required this.name, required this.value});
}

class Data2 {
  final String name1;
  final double value1;
  final double value2;
  Data2(this.name1, this.value1, this.value2);
}

class Data3 {
  final int name1;
  final double value1;
  final double value2;
  Data3(this.name1, this.value1, this.value2);
}

List<Data2> levelsFor2Users(
    List<sub.Result> subData1, List<sub.Result> subData2) {
  maxlevel2 = 0.0;
  Map<String, List<double>> mp = {};
  Set<String> st = {};
  subData1.forEach((v) {
    String key = "${v.problem.contestId}+${v.problem.index}+${v.problem.name}";
    String t = v.problem.index;
    String char = '${t[0]}';
    if ((v.verdict == "OK" || v.verdict == "PARTIAL") && !st.contains(key)) {
      if (mp.containsKey(char)) {
        mp[char]![0]++;
      } else {
        List<double> l = [0.0, 0.0];
        l[0]++;
        mp[char] = l;
      }
      st.add(key);
    }
  });
  st.clear();
  subData2.forEach((v) {
    String key = "${v.problem.contestId}+${v.problem.index}+${v.problem.name}";
    String t = v.problem.index;
    String char = '${t[0]}';
    if ((v.verdict == "OK" || v.verdict == "PARTIAL") && !st.contains(key)) {
      if (mp.containsKey(char)) {
        mp[char]![1]++;
      } else {
        List<double> l = [0.0, 0.0];
        l[1]++;
        mp[char] = l;
      }
      st.add(key);
    }
  });

  List<Data2> data = [];
  mp.forEach((k, v) {
    if ((v[0] > 0 || v[1] > 0) && k != " ") {
      maxlevel2 = max(maxlevel2, max(v[0], v[1]));
      data.add(new Data2(k, v[0], v[1]));
    }
  });
  data.sort((a, b) => a.name1.compareTo(b.name1));
  return data;
}

List<Data3> ratingsFor2Users(
    List<sub.Result> subData1, List<sub.Result> subData2) {
  maxRating2 = 0.0;
  Map<int, List<double>> mp = {};
  Set<String> st = {};
  subData1.forEach((v) {
    String key = "${v.problem.contestId}+${v.problem.index}+${v.problem.name}";
    int t = v.problem.rating;
    if ((v.verdict == "OK" || v.verdict == "PARTIAL") && !st.contains(key)) {
      if (mp.containsKey(t)) {
        mp[t]![0]++;
      } else {
        List<double> l = [0.0, 0.0];
        l[0]++;
        mp[t] = l;
      }
      st.add(key);
    }
  });
  st.clear();
  subData2.forEach((v) {
    String key = "${v.problem.contestId}+${v.problem.index}+${v.problem.name}";
    int t = v.problem.rating;
    if ((v.verdict == "OK" || v.verdict == "PARTIAL") && !st.contains(key)) {
      if (mp.containsKey(t)) {
        mp[t]![1]++;
      } else {
        List<double> l = [0.0, 0.0];
        l[1]++;
        mp[t] = l;
      }
      st.add(key);
    }
  });

  List<Data3> data = [];
  mp.forEach((k, v) {
    if ((v[0] > 0 || v[1] > 0) && k != 0) {
      maxRating2 = max(maxRating2, max(v[0], v[1]));
      data.add(new Data3(k, v[0], v[1]));
    }
  });
  data.sort((a, b) => a.name1.compareTo(b.name1));
  return data;
}
