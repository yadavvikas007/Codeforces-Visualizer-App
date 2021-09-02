class RatingChanges {
  late String status;
  late List<Result> result = [];

  RatingChanges({required this.status, required this.result});

  RatingChanges.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }
}

class Result {
  late int contestId;
  late String contestName;
  late String handle;
  late int rank;
  late int ratingUpdateTimeSeconds;
  late int oldRating;
  late int newRating;

  Result(
      {required this.contestId,
      required this.contestName,
      required this.handle,
      required this.rank,
      required this.ratingUpdateTimeSeconds,
      required this.oldRating,
      required this.newRating});

  Result.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'];
    contestName = json['contestName'];
    handle = json['handle'];
    rank = json['rank'];
    ratingUpdateTimeSeconds = json['ratingUpdateTimeSeconds'];
    oldRating = json['oldRating'];
    newRating = json['newRating'];
  }
}
