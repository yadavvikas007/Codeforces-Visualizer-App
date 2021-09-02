class UserInfo {
  late String status;
  late List<Result> result = [];

  UserInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }
}

class Result {
  late String lastName;
  late String country;
  late int lastOnlineTimeSeconds;
  late String city;
  late int rating;
  late int friendOfCount;
  late String titlePhoto;
  late String handle;
  late String avatar;
  late String firstName;
  late int contribution;
  late String organization;
  late String rank;
  late int maxRating;
  late int registrationTimeSeconds;
  late String maxRank;

  Result.fromJson(Map<String, dynamic> json) {
    lastName = json['lastName'] != null ? json['lastName'] : "";
    country = json['country'] != null ? json['country'] : "";
    lastOnlineTimeSeconds = json['lastOnlineTimeSeconds'] != null
        ? json['lastOnlineTimeSeconds']
        : 0;
    city = json['city'] != null ? json['city'] : "";
    rating = json['rating'] != null ? json['rating'] : 0;
    friendOfCount = json['friendOfCount'] != null ? json['friendOfCount'] : 0;
    titlePhoto = json['titlePhoto'] != null ? json['titlePhoto'] : "";
    handle = json['handle'] != null ? json['handle'] : "";
    avatar = json['avatar'] != null ? json['avatar'] : "";
    firstName = json['firstName'] != null ? json['firstName'] : "";
    contribution = json['contribution'] != null ? json['contribution'] : 0;
    organization = json['organization'] != null ? json['organization'] : "";
    rank = json['rank'] != null ? json['rank'] : "";
    maxRating = json['maxRating'] != null ? json['maxRating'] : 0;
    registrationTimeSeconds = json['registrationTimeSeconds'] != null
        ? json['registrationTimeSeconds']
        : 0;
    maxRank = json['maxRank'] != null ? json['maxRank'] : "";
  }
}
