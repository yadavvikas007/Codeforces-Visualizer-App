class Submissions {
  late String status;
  late List<Result> result = [];

  Submissions({required this.status, required this.result});

  Submissions.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }
}

//smaller names for verdicts
const Map<String, String> alternate_names = {
  "COMPILATION_ERROR": "COMP_ERR",
  "RUNTIME_ERROR": "RUN_ERR",
  "WRONG_ANSWER": "WRG_ANS",
  "PRESENTATION_ERROR": "PST_ERR",
  "TIME_LIMIT_EXCEEDED": "TLE",
  "MEMORY_LIMIT_EXCEEDED": "MLE",
  "IDLENESS_LIMIT_EXCEEDED": "ILE",
  "SECURITY_VIOLATED": "SEC_VIOL",
  "INPUT_PREPARATION_CRASHED": "IPC"
};

class Result {
  late int id;
  late int contestId;
  late int creationTimeSeconds;
  late int relativeTimeSeconds;
  late Problem problem;
  late Author author;
  late String programmingLanguage;
  late String verdict;
  late String testset;
  late int passedTestCount;
  late int timeConsumedMillis;
  late int memoryConsumedBytes;

  Result(
      {required this.id,
      required this.contestId,
      required this.creationTimeSeconds,
      required this.relativeTimeSeconds,
      required this.problem,
      required this.author,
      required this.programmingLanguage,
      required this.verdict,
      required this.testset,
      required this.passedTestCount,
      required this.timeConsumedMillis,
      required this.memoryConsumedBytes});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contestId = json['contestId'] != null ? json['contestId'] : -1;
    creationTimeSeconds =
        json['creationTimeSeconds'] != null ? json['creationTimeSeconds'] : -1;
    relativeTimeSeconds =
        json['relativeTimeSeconds'] != null ? json['relativeTimeSeconds'] : -1;
    problem = (json['problem'] != null
        ? new Problem.fromJson(json['problem'])
        : null)!;
    author =
        (json['author'] != null ? new Author.fromJson(json['author']) : null)!;
    programmingLanguage =
        json['programmingLanguage'] != null ? json['programmingLanguage'] : "";
    verdict = json['verdict'] != null ? json['verdict'] : "";
    if (alternate_names.containsKey(verdict))
      verdict = alternate_names[verdict]!;
    testset = json['testset'] != null ? json['testset'] : "";
    passedTestCount =
        json['passedTestCount'] != null ? json['passedTestCount'] : -1;
    timeConsumedMillis =
        json['timeConsumedMillis'] != null ? json['timeConsumedMillis'] : -1;
    memoryConsumedBytes =
        json['memoryConsumedBytes'] != null ? json['memoryConsumedBytes'] : -1;
  }
}

class Problem {
  late int contestId;
  late String index;
  late String name;
  late String type;
  late double points;
  late List<String> tags;
  late int rating;

  Problem({
    required this.contestId,
    required this.index,
    required this.name,
    required this.type,
    required this.points,
    required this.tags,
    required this.rating,
  });

  Problem.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'] != null ? json['contestId'] : -1;
    index = json['index'] != null ? json['index'] : "";
    name = json['name'] != null ? json['name'] : "";
    type = json['type'] != null ? json['type'] : "";
    points = json['points'] != null ? json['points'] : -1.0;
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    rating = json['rating'] != null ? json['rating'] : -1;
  }
}

class Author {
  late int contestId;
  late List<Members> members = [];
  late String participantType;
  late bool ghost;
  late int room;
  late int startTimeSeconds;

  Author(
      {required this.contestId,
      required this.members,
      required this.participantType,
      required this.ghost,
      required this.room,
      required this.startTimeSeconds});

  Author.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'] != null ? json['contestId'] : 0;
    if (json['members'] != null) {
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    participantType =
        json['participantType'] != null ? json['participantType'] : "";
    ghost = json['ghost'] != null ? json['ghost'] : false;
    room = json['room'] != null ? json['room'] : -1;
    startTimeSeconds = json['startTimeSeconds'] != null
        ? startTimeSeconds = json['startTimeSeconds']
        : -1;
  }
}

class Members {
  late String handle;

  Members({required this.handle});

  Members.fromJson(Map<String, dynamic> json) {
    handle = json['handle'] != null ? handle = json['handle'] : "";
  }
}
