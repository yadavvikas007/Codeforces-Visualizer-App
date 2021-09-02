class Contests {
  late String status;
  late List<Result> result = [];

  Contests({required this.status, required this.result});

  Contests.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      int count = 0;
      json['result'].forEach((v) {
        Result r = new Result.fromJson(v);
        if (r.phase == "FINISHED" && count < 10) {
          result.add(r);
          count++;
        }
      });
    }
  }
}

class Result {
  late int id;
  late String name;
  late String type;
  late String phase;
  late bool frozen;
  late int durationSeconds;
  late int startTimeSeconds;
  late int relativeTimeSeconds;

  Result(
      {required this.id,
      required this.name,
      required this.type,
      required this.phase,
      required this.frozen,
      required this.durationSeconds,
      required this.startTimeSeconds,
      required this.relativeTimeSeconds});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    phase = json['phase'];
    frozen = json['frozen'];
    durationSeconds = json['durationSeconds'];
    startTimeSeconds = json['startTimeSeconds'];
    relativeTimeSeconds = json['relativeTimeSeconds'];
  }
}
