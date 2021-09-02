import 'dart:math';
import 'package:codeforces_visualizer/screens/singleUserScreenModels/submissions.dart'
    as sub;
import 'package:codeforces_visualizer/screens/singleUserScreenModels/ratingChanges.dart'
    as Rating;

class ProblemData {
  final int solvedQuestions;
  final int triedQuestions;
  final double avgAttempt;
  final int maxAttempt;
  final int solvedInOneAttempt;
  final int maxAcceptedForSameQues;
  ProblemData(this.solvedQuestions, this.triedQuestions, this.avgAttempt,
      this.maxAttempt, this.solvedInOneAttempt, this.maxAcceptedForSameQues);
}

ProblemData getProblemsData(List<sub.Result> usersubmissions) {
  int solvedQuestions = 0;
  int triedQuestions = 0;
  double avgAttempt = 0.0;
  int maxAttempt = 0;
  int solvedInOneAttempt = 0;
  int maxAcceptedForSameQues = 0;
  Map<String, List<int>> problems = {};
  usersubmissions.forEach((submission) {
    String key =
        "${submission.problem.contestId}+${submission.problem.index}+${submission.problem.name}";
    if (problems.containsKey(key)) {
      if (submission.verdict == "OK" || submission.verdict == "PARTIAL")
        problems[key]![0]++;
      else
        problems[key]![1]++;
    } else {
      List<int> v = [0, 0];
      if (submission.verdict == "OK" || submission.verdict == "PARTIAL")
        v[0]++;
      else
        v[1]++;
      problems[key] = v;
    }
  });
  triedQuestions = problems.length;
  int sumOfUnsuccessfulAttempts = 0;
  problems.forEach((k, v) {
    if (v[0] >= 1) {
      solvedQuestions++;
      maxAttempt = max(maxAttempt, v[1]);
      if (v[0] == 1 && v[1] == 0) solvedInOneAttempt++;
      maxAcceptedForSameQues = max(maxAcceptedForSameQues, v[0]);
      sumOfUnsuccessfulAttempts += v[1] + 1;
    }
  });
  if (solvedQuestions > 0)
    avgAttempt = sumOfUnsuccessfulAttempts / solvedQuestions;
  return new ProblemData(solvedQuestions, triedQuestions, avgAttempt,
      maxAttempt, solvedInOneAttempt, maxAcceptedForSameQues);
}

class RatingChangeData {
  final int numOfContests;
  final int maxUp;
  final int maxDown;
  final int worstRank;
  final int bestRank;
  RatingChangeData(this.numOfContests, this.maxUp, this.maxDown, this.worstRank,
      this.bestRank);
}

RatingChangeData getRatingChangeData(List<Rating.Result> userratingchanges) {
  int numOfContests = 0;
  int maxUp = userratingchanges.isNotEmpty ? userratingchanges[0].newRating : 0;
  int maxDown = 0;
  int worstRank = userratingchanges.isNotEmpty ? userratingchanges[0].rank : 0;
  int bestRank = userratingchanges.isNotEmpty ? userratingchanges[0].rank : 0;
  userratingchanges.forEach((element) {
    bestRank = min(bestRank, element.rank);
    worstRank = max(worstRank, element.rank);
    maxUp = max(maxUp, element.newRating - element.oldRating);
    maxDown = min(maxDown, element.newRating - element.oldRating);
  });
  numOfContests = userratingchanges.length;
  return new RatingChangeData(
      numOfContests, maxUp, maxDown, worstRank, bestRank);
}
