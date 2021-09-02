import 'package:codeforces_visualizer/screens/singleUserScreenModels/ratingChanges.dart'
    as rat;

class Data {
  final double name1;
  final double value1;
  Data(this.name1, this.value1);
}

List<Data> ratingTimeline2users(List<rat.Result> ratingData) {
  List<Data> data = [];
  ratingData.forEach((r) {
    data.add(new Data(r.ratingUpdateTimeSeconds * 1.0, r.newRating.toDouble()));
  });
  return data;
}
