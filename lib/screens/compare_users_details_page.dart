import 'dart:math';
import 'package:codeforces_visualizer/components/error_screen.dart';
import 'package:codeforces_visualizer/screens/data/bar_chart_data.dart';
import 'package:codeforces_visualizer/screens/data/general_data.dart';
import 'package:codeforces_visualizer/screens/singleUserDetailsPage.dart';
import 'package:codeforces_visualizer/screens/widgets/bar_groups.dart';
import 'package:codeforces_visualizer/screens/widgets/line_chart_spots.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:codeforces_visualizer/components/appbar.dart';
import 'package:codeforces_visualizer/screens/drawer.dart';
import 'package:codeforces_visualizer/utilities/constants.dart';
import 'singleUserScreenModels/ratingChanges.dart' as Rating;
import 'singleUserScreenModels/submissions.dart' as Sub;
import 'singleUserScreenModels/userInfo.dart' as Info;
// import 'package:intl/intl.dart';

late Info.Result userinfo1;
late List<Sub.Result> usersubmissions1;
late List<Rating.Result> userratingchanges1;
late Info.Result userinfo2;
late List<Sub.Result> usersubmissions2;
late List<Rating.Result> userratingchanges2;

//colors corresponding to user rank
const Map<String, Color> COLORS = {
  "": Colors.grey,
  "newbie": Color(0xff808185),
  "pupil": Color(0xff008000),
  "specialist": Color(0xff03a89e),
  "expert": Color(0xff0303ff),
  "candidate master": Color(0xffaa00aa),
  "master": Color(0xffff8c00),
  "international master": Color(0xffffbb55),
  "grandmaster": Color(0xffff7777),
  "international grandmaster": Color(0xffff3333),
  "legendary grandmaster": Color(0xffaa0000),
};

//users rating and submission objects
late RatingChangeData user1RatingData;
late RatingChangeData user2RatingData;
late ProblemData user1ProblemData;
late ProblemData user2ProblemData;

//to get general data about user users submissions and rating changes
void getgeneraldata() {
  user1RatingData = getRatingChangeData(userratingchanges1);
  user2RatingData = getRatingChangeData(userratingchanges2);
  user1ProblemData = getProblemsData(usersubmissions1);
  user2ProblemData = getProblemsData(usersubmissions2);
}

class CompareUserDetailsPage extends StatefulWidget {
  //user-1 and user-2 handles
  final String handle1;
  final String handle2;
  const CompareUserDetailsPage(
      {Key? key, required this.handle1, required this.handle2})
      : super(key: key);

  @override
  _CompareUserDetailsPageState createState() => _CompareUserDetailsPageState();
}

class _CompareUserDetailsPageState extends State<CompareUserDetailsPage> {
  //default page body while data is loading from api calls
  Widget _child = Scaffold(
    appBar: buildAppBar(),
    backgroundColor: creamColor,
    body: Center(
      child: Container(
        height: 50,
        width: 50,
        child: SpinKitPouringHourGlassRefined(
          strokeWidth: 2,
          color: kPrimaryColor,
          size: 60,
        ),
      ),
    ),
  );

  //API calling, json decoding, data parsing and storing in the user rating change and submision class objects
  void getdata() async {
    //.....................................................................
    //user1 links generating
    var url11 = Uri.https(
        "www.codeforces.com", "/api/user.info?handles=${widget.handle1}");
    var url21 = Uri.https(
        "www.codeforces.com", "/api/user.status?handle=${widget.handle1}");
    var url31 = Uri.https(
        "www.codeforces.com", "/api/user.rating?handle=${widget.handle1}");
    //user1 links generating
    var url12 = Uri.https(
        "www.codeforces.com", "/api/user.info?handles=${widget.handle2}");
    var url22 = Uri.https(
        "www.codeforces.com", "/api/user.status?handle=${widget.handle2}");
    var url32 = Uri.https(
        "www.codeforces.com", "/api/user.rating?handle=${widget.handle2}");
    //.....................................................................

    //.....................................................
    //user1 getting response
    var userInfoResponse1 = await http.get(url11);
    var userSubmissionResponse1 = await http.get(url21);
    var userRatingChangesResponse1 = await http.get(url31);
    //user2 getting response
    var userInfoResponse2 = await http.get(url12);
    var userSubmissionResponse2 = await http.get(url22);
    var userRatingChangesResponse2 = await http.get(url32);
    //.....................................................

    if ( //user1 && user2 response validating
        userInfoResponse1.statusCode == 200 &&
            userRatingChangesResponse1.statusCode == 200 &&
            userSubmissionResponse1.statusCode == 200 &&
            userInfoResponse2.statusCode == 200 &&
            userRatingChangesResponse2.statusCode == 200 &&
            userSubmissionResponse2.statusCode == 200) {
      //user1 data decoding into Map< string, dynamic >
      var userInfoJsonMap1 =
          convert.jsonDecode(userInfoResponse1.body) as Map<String, dynamic>;
      var userSubmissionJsonMap1 = convert
          .jsonDecode(userSubmissionResponse1.body) as Map<String, dynamic>;
      var userRatingChangesJsonMap1 = convert
          .jsonDecode(userRatingChangesResponse1.body) as Map<String, dynamic>;

      //user2 data decoding into Map< string, dynamic >
      var userInfoJsonMap2 =
          convert.jsonDecode(userInfoResponse2.body) as Map<String, dynamic>;
      var userSubmissionJsonMap2 = convert
          .jsonDecode(userSubmissionResponse2.body) as Map<String, dynamic>;
      var userRatingChangesJsonMap2 = convert
          .jsonDecode(userRatingChangesResponse2.body) as Map<String, dynamic>;

      //........................................................................
      //User1 data objects <= jsonMaps
      Info.UserInfo userInfo1 = new Info.UserInfo.fromJson(userInfoJsonMap1);
      Sub.Submissions userSubmission1 =
          new Sub.Submissions.fromJson(userSubmissionJsonMap1);
      Rating.RatingChanges userRatingChanges1 =
          new Rating.RatingChanges.fromJson(userRatingChangesJsonMap1);

      //user2 data objects <= jsonMaps
      Info.UserInfo userInfo2 = new Info.UserInfo.fromJson(userInfoJsonMap2);
      Sub.Submissions userSubmission2 =
          new Sub.Submissions.fromJson(userSubmissionJsonMap2);
      Rating.RatingChanges userRatingChanges2 =
          new Rating.RatingChanges.fromJson(userRatingChangesJsonMap2);
      //........................................................................

      if ( //checking for any server errors in receiving data
          userInfo1.status == "FAILED" ||
              userInfo2.status == "FAILED" ||
              userSubmission1.status == "FAILED" ||
              userSubmission2.status == "FAILED" ||
              userRatingChanges1.status == "FAILED" ||
              userRatingChanges2.status == "FAILED") {
        //if yes display error page
        setState(() {
          _child = Error2Screen();
        });
      } else {
        //if data is valid pass the data in global objects
        userratingchanges1 = userRatingChanges1.result;
        usersubmissions1 = userSubmission1.result;
        userinfo1 = userInfo1.result[0];
        userratingchanges2 = userRatingChanges2.result;
        usersubmissions2 = userSubmission2.result;
        userinfo2 = userInfo2.result[0];
        getgeneraldata(); //getting general data

        //now after all the data is ready, build beautiful widgets using it
        setState(() {
          _child = CompareDetails();
        });
      }
      //........................................................................
    } else {
      //in case of any other error in API calling => display error page
      setState(() {
        _child = Error2Screen();
      });
    }
  }

  //initstate calling the getdata function
  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}

class CompareDetails extends StatefulWidget {
  const CompareDetails({Key? key}) : super(key: key);

  @override
  _CompareDetailsState createState() => _CompareDetailsState();
}

class _CompareDetailsState extends State<CompareDetails> {
  @override
  Widget build(BuildContext context) {
    //screen size
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "User Comparision",
          style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset("assets/images/menu.svg"),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: MyDrawer(),
      body: Scrollbar(
        interactive: true,
        thickness: 15,
        radius: Radius.circular(10),
        showTrackOnHover: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ColorInfo(),
              RatingComparision(size: size),
              MaxUpMaxDownRating(size: size),
              ContestsCount(size: size),
              RatingTimeline(size: size),
              BestRankWorstRank(size: size),
              SolvedTriedProblems(size: size),
              AverageSubmission(size: size),
              SolvedInOneAttempt(size: size),
              ProblemLevelsCompare(size: size),
              ProblemRatings(size: size),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorInfo extends StatelessWidget {
  const ColorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.circle, color: Colors.green),
            title: Text(
              "${userinfo1.handle}",
              style: TextStyle(
                color: Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              "${userinfo1.rating}",
              style: TextStyle(
                color: COLORS["${userinfo1.rank}"],
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.circle, color: Colors.blue),
            title: Text(
              "${userinfo2.handle}",
              style: TextStyle(
                color: Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              "${userinfo2.rating}",
              style: TextStyle(
                color: COLORS["${userinfo2.rank}"],
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RatingComparision extends StatefulWidget {
  final Size size;
  const RatingComparision({Key? key, required this.size}) : super(key: key);

  @override
  _RatingComparisionState createState() => _RatingComparisionState();
}

class _RatingComparisionState extends State<RatingComparision> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ratings Comparison",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            child: Container(
              height: widget.size.height * 0.3,
              width: widget.size.width,
              padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                      touchTooltipData:
                          BarTouchTooltipData(tooltipBgColor: Colors.white)),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                    // Build X axis.
                    bottomTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      margin: 16,
                      getTitles: (double value) {
                        return (value == 1.0) ? "Current Rating" : "Max Rating";
                      },
                    ),
                    // Build Y axis.
                    leftTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 10);
                      },
                      showTitles: true,
                      getTitles: (double value) {
                        if (value.toInt() % 1000 != 0) return "";
                        return (value / 1000).toStringAsFixed(1) + "k";
                      },
                    ),
                  ),
                  maxY:
                      max(userinfo1.maxRating, userinfo2.maxRating).toDouble() *
                          1.5,
                  groupsSpace: 50,
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        bar(userinfo1.rating.toDouble(), Colors.green),
                        bar(userinfo2.rating.toDouble(), Colors.blue),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        bar(userinfo1.maxRating.toDouble(), Colors.green),
                        bar(userinfo2.maxRating.toDouble(), Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MaxUpMaxDownRating extends StatefulWidget {
  final Size size;
  const MaxUpMaxDownRating({Key? key, required this.size}) : super(key: key);

  @override
  _MaxUpMaxDownRatingState createState() => _MaxUpMaxDownRatingState();
}

class _MaxUpMaxDownRatingState extends State<MaxUpMaxDownRating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Max Up / Max Down",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            child: Container(
              height: widget.size.height * 0.3,
              width: widget.size.width,
              padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                      touchTooltipData:
                          BarTouchTooltipData(tooltipBgColor: Colors.white)),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                    // Build X axis.
                    bottomTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      margin: 16,
                      getTitles: (double value) {
                        return (value == 1.0) ? "Max Up" : "Max Down";
                      },
                    ),
                    // Build Y axis.
                    leftTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      getTitles: (double value) {
                        return "";
                      },
                    ),
                  ),
                  maxY: max(user1RatingData.maxUp, user2RatingData.maxUp)
                          .toDouble() *
                      1.5,
                  minY: min(user1RatingData.maxDown, user2RatingData.maxDown)
                          .toDouble() *
                      1.5,
                  groupsSpace: 50,
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        bar(user1RatingData.maxUp.toDouble(), Colors.green),
                        bar(user2RatingData.maxUp.toDouble(), Colors.blue),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        bar(user1RatingData.maxDown.toDouble(), Colors.green),
                        bar(user2RatingData.maxDown.toDouble(), Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ContestsCount extends StatefulWidget {
  final Size size;
  const ContestsCount({Key? key, required this.size}) : super(key: key);

  @override
  _ContestsCountState createState() => _ContestsCountState();
}

class _ContestsCountState extends State<ContestsCount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contests Participated",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            child: Container(
              height: widget.size.height * 0.3,
              width: widget.size.width,
              padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                      touchTooltipData:
                          BarTouchTooltipData(tooltipBgColor: Colors.white)),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                    // Build X axis.
                    bottomTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      margin: 16,
                      getTitles: (double value) {
                        return (value == 1.0)
                            ? "${userinfo1.handle}"
                            : "${userinfo2.handle}";
                      },
                    ),
                    // Build Y axis.
                    leftTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      getTitles: (double value) {
                        if (value.toInt() % 50 != 0) return "";
                        return value.toInt().toString();
                      },
                    ),
                  ),
                  maxY: max(user1RatingData.numOfContests,
                              user2RatingData.numOfContests)
                          .toDouble() *
                      1.5,
                  groupsSpace: 50,
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        bar(user1RatingData.numOfContests.toDouble(),
                            Colors.green)
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        bar(user2RatingData.numOfContests.toDouble(),
                            Colors.blue)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BestRankWorstRank extends StatelessWidget {
  final Size size;
  const BestRankWorstRank({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Best Rank / Worst Rank",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 30),
          Table(
            border: TableBorder.all(color: Colors.transparent),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  tableRow("Best Rank", Colors.black, 14),
                  tableRow("${user1RatingData.bestRank}", Colors.green, 20),
                  tableRow("${user2RatingData.bestRank}", Colors.blue, 20),
                ],
              ),
              TableRow(
                children: <Widget>[
                  tableRow("Worst Rank", Colors.black, 14),
                  tableRow("${user1RatingData.worstRank}", Colors.green, 20),
                  tableRow("${user2RatingData.worstRank}", Colors.blue, 20),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SolvedTriedProblems extends StatefulWidget {
  final Size size;
  const SolvedTriedProblems({Key? key, required this.size}) : super(key: key);

  @override
  _SolvedTriedProblemsState createState() => _SolvedTriedProblemsState();
}

class _SolvedTriedProblemsState extends State<SolvedTriedProblems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tried / Solved Problems",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            child: Container(
              height: widget.size.height * 0.3,
              width: widget.size.width,
              padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                      touchTooltipData:
                          BarTouchTooltipData(tooltipBgColor: Colors.white)),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                    // Build X axis.
                    bottomTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      margin: 16,
                      getTitles: (double value) {
                        return (value == 1.0) ? "Tried" : "Solved";
                      },
                    ),
                    // Build Y axis.
                    leftTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 10);
                      },
                      showTitles: true,
                      interval: calculateNumber(max(
                              user1ProblemData.triedQuestions,
                              user2ProblemData.triedQuestions)) /
                          5,
                      getTitles: (double value) {
                        if (value.toInt() % 1 != 0) return "";
                        return (value / 1000).toStringAsFixed(1) + "k";
                      },
                    ),
                  ),
                  maxY: max(user1ProblemData.triedQuestions,
                              user2ProblemData.triedQuestions)
                          .toDouble() *
                      1.5,
                  groupsSpace: 50,
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        bar(user1ProblemData.triedQuestions.toDouble(),
                            Colors.green),
                        bar(user2ProblemData.triedQuestions.toDouble(),
                            Colors.blue),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        bar(user1ProblemData.solvedQuestions.toDouble(),
                            Colors.green),
                        bar(user2ProblemData.solvedQuestions.toDouble(),
                            Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AverageSubmission extends StatefulWidget {
  final Size size;
  const AverageSubmission({Key? key, required this.size}) : super(key: key);

  @override
  _AverageSubmissionState createState() => _AverageSubmissionState();
}

class _AverageSubmissionState extends State<AverageSubmission> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Average Submission",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            child: Container(
              height: widget.size.height * 0.3,
              width: widget.size.width,
              padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                      touchTooltipData:
                          BarTouchTooltipData(tooltipBgColor: Colors.white)),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                    // Build X axis.
                    bottomTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      margin: 16,
                      getTitles: (double value) {
                        return (value == 1.0)
                            ? "${userinfo1.handle}"
                            : "${userinfo2.handle}";
                      },
                    ),
                    // Build Y axis.
                    leftTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      getTitles: (double value) {
                        return value.toInt().toString();
                      },
                    ),
                  ),
                  maxY: max(user1ProblemData.avgAttempt,
                              user2ProblemData.avgAttempt)
                          .toDouble() *
                      1.5,
                  groupsSpace: 50,
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        bar(dp(user1ProblemData.avgAttempt, 2), Colors.green)
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        bar(dp(user2ProblemData.avgAttempt, 2), Colors.blue)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SolvedInOneAttempt extends StatefulWidget {
  final Size size;
  const SolvedInOneAttempt({Key? key, required this.size}) : super(key: key);

  @override
  _SolvedInOneAttemptState createState() => _SolvedInOneAttemptState();
}

class _SolvedInOneAttemptState extends State<SolvedInOneAttempt> {
  @override
  Widget build(BuildContext context) {
    double s1 = dp(
        user1ProblemData.solvedInOneAttempt *
            100.0 /
            (user1ProblemData.solvedQuestions != 0
                ? user1ProblemData.solvedQuestions
                : 1),
        3);
    double s2 = dp(
        user2ProblemData.solvedInOneAttempt *
            100.0 /
            (user2ProblemData.solvedQuestions != 0
                ? user2ProblemData.solvedQuestions
                : 1),
        3);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Solved with one submission(%)",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            child: Container(
              height: widget.size.height * 0.3,
              width: widget.size.width,
              padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                      touchTooltipData:
                          BarTouchTooltipData(tooltipBgColor: Colors.white)),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                    // Build X axis.
                    bottomTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      margin: 16,
                      getTitles: (double value) {
                        return (value == 1.0)
                            ? "${userinfo1.handle}"
                            : "${userinfo2.handle}";
                      },
                    ),
                    // Build Y axis.
                    leftTitles: SideTitles(
                      getTextStyles: (context, value) {
                        return TextStyle(color: Colors.black, fontSize: 12);
                      },
                      showTitles: true,
                      getTitles: (double value) {
                        if (value % 20 != 0) return "";
                        return value.toInt().toString();
                      },
                    ),
                  ),
                  maxY: max(s1, s2) * 1.5,
                  groupsSpace: 50,
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [bar(s1, Colors.green)],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [bar(s2, Colors.blue)],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProblemLevelsCompare extends StatefulWidget {
  final Size size;
  const ProblemLevelsCompare({Key? key, required this.size}) : super(key: key);

  @override
  _ProblemLevelsCompareState createState() => _ProblemLevelsCompareState();
}

class _ProblemLevelsCompareState extends State<ProblemLevelsCompare> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups =
        getLevelsCompare(usersubmissions1, usersubmissions2);
    if (barGroups.isEmpty) return noData(widget.size);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Problem Levels",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: widget.size.height * 0.5,
                width: widget.size.width * 5.0,
                padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                        touchTooltipData:
                            BarTouchTooltipData(tooltipBgColor: Colors.white)),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: SideTitles(showTitles: false),
                      rightTitles: SideTitles(showTitles: false),
                      // Build X axis.
                      bottomTitles: SideTitles(
                        getTextStyles: (context, value) {
                          return TextStyle(color: Colors.black, fontSize: 12);
                        },
                        showTitles: true,
                        margin: 16,
                        getTitles: (double value) {
                          return f1(value.toInt());
                        },
                      ),
                      // Build Y axis.
                      leftTitles: SideTitles(
                        getTextStyles: (context, value) {
                          return TextStyle(color: Colors.black, fontSize: 12);
                        },
                        showTitles: true,
                        getTitles: (double value) {
                          if (value.toInt() % 50 != 0) return "";
                          return value.toInt().toString();
                        },
                      ),
                    ),
                    barGroups: barGroups,
                    groupsSpace: 50,
                    maxY: maxlevel2 * 1.5,
                    axisTitleData: FlAxisTitleData(
                      bottomTitle: AxisTitle(
                        titleText: "Problem Levels",
                        textAlign: TextAlign.center,
                        showTitle: true,
                        margin: 10,
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily),
                      ),
                      show: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProblemRatings extends StatefulWidget {
  final Size size;
  const ProblemRatings({Key? key, required this.size}) : super(key: key);

  @override
  _ProblemRatingsState createState() => _ProblemRatingsState();
}

class _ProblemRatingsState extends State<ProblemRatings> {
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups =
        getRatingsCompare(usersubmissions1, usersubmissions2);
    if (barGroups.isEmpty) return noData(widget.size);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Problem Ratings",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: widget.size.height * 0.5,
                width: widget.size.width * 7.0,
                padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                        touchTooltipData:
                            BarTouchTooltipData(tooltipBgColor: Colors.white)),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: SideTitles(showTitles: false),
                      rightTitles: SideTitles(showTitles: false),
                      // Build X axis.
                      bottomTitles: SideTitles(
                        getTextStyles: (context, value) {
                          return TextStyle(color: Colors.black, fontSize: 12);
                        },
                        showTitles: true,
                        margin: 16,
                        getTitles: (double value) {
                          return value.toInt().toString();
                        },
                      ),
                      // Build Y axis.
                      leftTitles: SideTitles(
                        getTextStyles: (context, value) {
                          return TextStyle(color: Colors.black, fontSize: 12);
                        },
                        showTitles: true,
                        getTitles: (double value) {
                          if (value.toInt() % 50 != 0) return "";
                          return value.toInt().toString();
                        },
                      ),
                    ),
                    barGroups: barGroups,
                    groupsSpace: 50,
                    maxY: min(maxRating2 * 1.5, 550),
                    axisTitleData: FlAxisTitleData(
                      bottomTitle: AxisTitle(
                        titleText: "Problem Ratings",
                        textAlign: TextAlign.center,
                        showTitle: true,
                        margin: 10,
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily),
                      ),
                      show: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingTimeline extends StatefulWidget {
  final Size size;
  const RatingTimeline({Key? key, required this.size}) : super(key: key);

  @override
  _RatingTimelineState createState() => _RatingTimelineState();
}

class _RatingTimelineState extends State<RatingTimeline> {
  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> spots =
        getSpotsRatingsTimeline(userratingchanges1, userratingchanges2);
    if (spots.isEmpty) return noData(widget.size);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(0.20),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ratings Timeline",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: widget.size.height * 0.5,
                width: widget.size.width * 6.0,
                padding:
                    EdgeInsets.only(right: 20, bottom: 10, top: 10, left: 10),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                        touchTooltipData:
                            LineTouchTooltipData(tooltipBgColor: Colors.white)),
                    borderData: FlBorderData(show: false),
                    maxY: max(userinfo1.maxRating.toDouble(),
                            userinfo2.maxRating.toDouble()) +
                        1500,
                    minY: 0.0,
                    gridData: FlGridData(
                      drawHorizontalLine: true,
                    ),
                    axisTitleData: FlAxisTitleData(
                      bottomTitle: AxisTitle(
                        titleText: "Timeline",
                        textAlign: TextAlign.center,
                        showTitle: true,
                        margin: 10,
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily),
                      ),
                      show: true,
                    ),
                    titlesData: FlTitlesData(
                      topTitles: SideTitles(showTitles: false),
                      rightTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(showTitles: false),
                      leftTitles: SideTitles(
                        getTextStyles: (context, value) {
                          return TextStyle(color: Colors.black, fontSize: 10);
                        },
                        showTitles: true,
                        interval: 500,
                        getTitles: (value) {
                          if (value == 0.0) return "";
                          return (value / 1000).toStringAsFixed(1) + "k";
                        },
                      ),
                    ),
                    lineBarsData: spots,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//bottomtiles for line chart..........................
// SideTitles _bottomTitles() {
//   int m1 = userratingchanges1.length;
//   int m2 = userratingchanges2.length;
//   int _minX = 0;
//   int _maxX = 0;
//   if (m1 >= 1 && m2 >= 1)
//     _minX = min(userratingchanges1[0].ratingUpdateTimeSeconds,
//         userratingchanges2[0].ratingUpdateTimeSeconds);
//   else if (m1 >= 1)
//     _minX = userratingchanges1[0].ratingUpdateTimeSeconds;
//   else if (m2 >= 1) _minX = userratingchanges2[0].ratingUpdateTimeSeconds;
//   if (m1 >= 1 && m2 >= 1)
//     _maxX = min(userratingchanges1[m1 - 1].ratingUpdateTimeSeconds,
//         userratingchanges2[m2 - 1].ratingUpdateTimeSeconds);
//   else if (m1 >= 1)
//     _maxX = userratingchanges1[m1 - 1].ratingUpdateTimeSeconds;
//   else if (m2 >= 1) _maxX = userratingchanges2[m2 - 1].ratingUpdateTimeSeconds;
//   // _maxX += 10000;
//   return SideTitles(
//     getTextStyles: (context, value) {
//       return TextStyle(color: Colors.black, fontSize: 12);
//     },
//     showTitles: (_maxX != 0 && _minX != 0),
//     getTitles: (value) {
//       final DateTime date =
//           DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000);
//       return DateFormat.yMMM().format(date);
//     },
//     margin: 8,
//     interval: (_maxX - _minX) / 10,
//   );
// }

//to reduce precision of a double to x decimal places
double dp(double val, int places) {
  double mod = pow(10.0, places).toDouble();
  return ((val * mod).round().toDouble() / mod);
}

//a table row (used in best rank worst rank widget)
Widget tableRow(String data, Color color, double size) {
  return Center(
    child: Text(
      data,
      style: TextStyle(
        color: color,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: size,
      ),
    ),
  );
}

//bar chart rod
BarChartRodData bar(double y, Color color) {
  return BarChartRodData(
    y: y,
    borderRadius: BorderRadius.circular(0),
    width: 40,
    colors: [color],
  );
}

//rounding of the num to nearest 100
int calculateNumber(int number) {
  int a = number % 100;
  if (a > 0) {
    return (number ~/ 100) * 100 + 100;
  }
  return number;
}
