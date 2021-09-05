class ContestProblems {
  late String status;
  late Result result;

  ContestProblems({required this.status, required this.result});

  ContestProblems.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    result =
        (json['result'] != null ? new Result.fromJson(json['result']) : null)!;
  }
}

class Result {
  late Contest contest;
  late List<Problems> problems = [];
  late List<Rows> rows = [];

  Result({required this.contest, required this.problems, required this.rows});

  Result.fromJson(Map<String, dynamic> json) {
    contest = (json['contest'] != null
        ? new Contest.fromJson(json['contest'])
        : null)!;
    if (json['problems'] != null) {
      json['problems'].forEach((v) {
        problems.add(new Problems.fromJson(v));
      });
    }
    if (json['rows'] != null) {
      json['rows'].forEach((v) {
        rows.add(new Rows.fromJson(v));
      });
    }
  }
}

class Contest {
  late int id;
  late String name;
  late String type;
  late String phase;
  late bool frozen;
  late int durationSeconds;
  late int startTimeSeconds;
  late int relativeTimeSeconds;

  Contest(
      {required this.id,
      required this.name,
      required this.type,
      required this.phase,
      required this.frozen,
      required this.durationSeconds,
      required this.startTimeSeconds,
      required this.relativeTimeSeconds});

  Contest.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'] : 0;
    name = json['name'] != null ? json['name'] : "";
    type = json['type'] != null ? json['type'] : "";
    phase = json['phase'] != null ? json['phase'] : "";
    frozen = json['frozen'] != null ? json['frozen'] : false;
    durationSeconds =
        json['durationSeconds'] != null ? json['durationSeconds'] : 0;
    startTimeSeconds =
        json['startTimeSeconds'] != null ? json['startTimeSeconds'] : 0;
    relativeTimeSeconds =
        json['relativeTimeSeconds'] != null ? json['relativeTimeSeconds'] : 0;
  }
}

class Problems {
  late int contestId;
  late String index;
  late String name;
  late String type;
  late int rating;
  late List<String> tags = [];

  Problems(
      {required this.contestId,
      required this.index,
      required this.name,
      required this.type,
      required this.rating,
      required this.tags});

  Problems.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'] != null ? json['contestId'] : -1;
    index = json['index'] != null ? json['index'] : "";
    name = json['name'] != null ? json['name'] : "";
    type = json['type'] != null ? json['type'] : "";
    rating = json['rating'] != null ? json['rating'] : 0;
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
  }
}

class Rows {
  late Party party;
  late int rank;
  late double points;
  late int penalty;
  late int successfulHackCount;
  late int unsuccessfulHackCount;
  late List<ProblemResults> problemResults = [];

  Rows(
      {required this.party,
      required this.rank,
      required this.points,
      required this.penalty,
      required this.successfulHackCount,
      required this.unsuccessfulHackCount,
      required this.problemResults});

  Rows.fromJson(Map<String, dynamic> json) {
    party = (json['party'] != null ? new Party.fromJson(json['party']) : null)!;
    rank = json['rank'] != null ? json['rank'] : 0;
    points = json['points'] != null ? json['points'] : 0.0;
    penalty = json['penalty'] != null ? json['penalty'] : 0;
    successfulHackCount =
        json['successfulHackCount'] != null ? json['successfulHackCount'] : 0;
    unsuccessfulHackCount = json['unsuccessfulHackCount'] != null
        ? json['unsuccessfulHackCount']
        : 0;
    if (json['problemResults'] != null) {
      json['problemResults'].forEach((v) {
        problemResults.add(new ProblemResults.fromJson(v));
      });
    }
  }
}

class Party {
  late int contestId;
  late List<Members> members = [];
  late String participantType;
  late bool ghost;
  late int startTimeSeconds;

  Party(
      {required this.contestId,
      required this.members,
      required this.participantType,
      required this.ghost,
      required this.startTimeSeconds});

  Party.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'];
    if (json['members'] != null) {
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    participantType =
        json['participantType'] != null ? json['participantType'] : "";
    ghost = json['ghost'] != null ? json['ghost'] : 0;
    startTimeSeconds =
        json['startTimeSeconds'] != null ? json['startTimeSeconds'] : 0;
  }
}

class Members {
  late String handle;

  Members({required this.handle});

  Members.fromJson(Map<String, dynamic> json) {
    handle = json['handle'] != null ? json['handle'] : "";
  }
}

class ProblemResults {
  late double points;
  late int rejectedAttemptCount;
  late String type;
  late int bestSubmissionTimeSeconds;

  ProblemResults(
      {required this.points,
      required this.rejectedAttemptCount,
      required this.type,
      required this.bestSubmissionTimeSeconds});

  ProblemResults.fromJson(Map<String, dynamic> json) {
    points = json['points'] != null ? json['points'] : 0;
    rejectedAttemptCount =
        json['rejectedAttemptCount'] != null ? json['rejectedAttemptCount'] : 0;
    type = json['type'] != null ? json['type'] : "";
    bestSubmissionTimeSeconds = json['bestSubmissionTimeSeconds'] != null
        ? json['bestSubmissionTimeSeconds']
        : 0;
  }
}
