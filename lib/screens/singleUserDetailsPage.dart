import 'package:codeforces_visualizer/components/error_screen.dart';
import 'package:codeforces_visualizer/screens/data/bar_chart_data.dart';
import 'package:codeforces_visualizer/screens/data/general_data.dart';
import 'package:codeforces_visualizer/screens/data/pie_data.dart';
import 'package:codeforces_visualizer/screens/widgets/bar_groups.dart';
import 'package:codeforces_visualizer/screens/widgets/line_chart_spots.dart';
import 'package:codeforces_visualizer/screens/widgets/pie_chart_sections.dart';
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
import 'package:intl/intl.dart';
import 'singleUserScreenModels/ratingChanges.dart' as Rating;
import 'singleUserScreenModels/submissions.dart' as Sub;
import 'singleUserScreenModels/userInfo.dart' as Info;

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
List<Color> PieChartColors = [
  Colors.green,
  Colors.pink,
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.indigo,
  Colors.lightGreen,
  Colors.redAccent,
  Colors.cyan,
  Colors.deepPurple,
  Colors.deepOrange,
  Colors.purple,
  Colors.brown,
  Colors.orange,
  Colors.lightBlue,
  Colors.pinkAccent,
  Colors.amber,
  Colors.teal,
  Colors.lime,
  Colors.blueGrey,
  Colors.grey
];

late Info.Result userinfo;
late List<Sub.Result> usersubmissions;
late List<Rating.Result> userratingchanges;

class SingleUserDetailsPage extends StatefulWidget {
  final String handle;

  const SingleUserDetailsPage({Key? key, required this.handle})
      : super(key: key);

  @override
  _SingleUserDetailsPageState createState() => _SingleUserDetailsPageState();
}

class _SingleUserDetailsPageState extends State<SingleUserDetailsPage> {
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

  void getdata() async {
    //.....................................................................
    var url1 = Uri.https(
        "www.codeforces.com", "/api/user.info?handles=${widget.handle}");
    var url2 = Uri.https(
        "www.codeforces.com", "/api/user.status?handle=${widget.handle}");
    var url3 = Uri.https(
        "www.codeforces.com", "/api/user.rating?handle=${widget.handle}");
    //.....................................................................

    //.....................................................
    var userInfoResponse = await http.get(url1);
    var userSubmissionResponse = await http.get(url2);
    var userRatingChangesResponse = await http.get(url3);
    //.....................................................

    if (userInfoResponse.statusCode == 200 &&
        userRatingChangesResponse.statusCode == 200 &&
        userSubmissionResponse.statusCode == 200) {
      var userInfoJsonMap =
          convert.jsonDecode(userInfoResponse.body) as Map<String, dynamic>;
      var userSubmissionJsonMap = convert
          .jsonDecode(userSubmissionResponse.body) as Map<String, dynamic>;
      var userRatingChangesJsonMap = convert
          .jsonDecode(userRatingChangesResponse.body) as Map<String, dynamic>;
      //........................................................................

      Info.UserInfo userInfo = new Info.UserInfo.fromJson(userInfoJsonMap);
      Sub.Submissions userSubmission =
          new Sub.Submissions.fromJson(userSubmissionJsonMap);
      Rating.RatingChanges userRatingChanges =
          new Rating.RatingChanges.fromJson(userRatingChangesJsonMap);
      //........................................................................
      if (userInfo.status == "FAILED" ||
          userSubmission.status == "FAILED" ||
          userRatingChanges.status == "FAILED") {
        setState(() {
          _child = Error2Screen();
        });
      } else {
        userratingchanges = userRatingChanges.result;
        usersubmissions = userSubmission.result;
        userinfo = userInfo.result[0];
        //........................................................................
        setState(() {
          _child = Details();
        });
      }
    } else {
      setState(() {
        _child = Error2Screen();
      });
    }
  }

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

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        // backgroundColor: COLORS["${userinfo.rank}"],
        title: Text(
          "${userinfo.handle}",
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
              UserDetailCard(size: size),
              PieChartVerdicts(size: size),
              PieChartTags(size: size),
              TagsList(size: size, tags: tagsFromData(usersubmissions)),
              ProblemsRatings(size: size),
              ProblemLevels(size: size),
              NumberOfQues(size: size),
              NumOfContests(size: size),
              RatingsChart(size: size),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetailCard extends StatelessWidget {
  const UserDetailCard({
    Key? key,
    required this.size,
  }) : super(key: key);
  final Size size;

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
            blurRadius: 20,
            color: kPrimaryColor.withOpacity(0.30),
            // color: COLORS["${userinfo.rank}"]!.withOpacity(0.30),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      height: size.height * 0.2,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Card(
                elevation: 0.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userinfo.rank,
                      style: TextStyle(
                        color: COLORS["${userinfo.rank}"],
                        fontSize: 18,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    Text(
                      "${userinfo.handle}", //${userinfo.handle}
                      style: TextStyle(
                        color: COLORS["${userinfo.rank}"],
                        fontSize: 22,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.add_chart_sharp,
                          color: Colors.blue[800],
                        ),
                        Text(
                          " Contest Rating: ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "${userinfo.rating}",
                          style: TextStyle(
                            color: COLORS["${userinfo.rank}"],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "( Max Rating: ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "${userinfo.maxRating}",
                          style: TextStyle(
                            color: COLORS["${userinfo.maxRank}"],
                          ),
                        ),
                        Text(
                          " )",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: Image(
              fit: BoxFit.contain,
              image: NetworkImage(userinfo.titlePhoto),
            ),
          )
        ],
      ),
    );
  }
}

class PieChartVerdicts extends StatefulWidget {
  final Size size;
  const PieChartVerdicts({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  _PieChartVerdictsState createState() => _PieChartVerdictsState();
}

class _PieChartVerdictsState extends State<PieChartVerdicts> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections =
        getSectionsVerdicts(touchedIndex, usersubmissions);
    if (sections.isEmpty) {
      return noData(widget.size);
    }
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
      //height: widget.size.height * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Verdicts  of  ${userinfo.handle}",
            style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(height: 30),
          Container(
            height: widget.size.height * 0.3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (pieTouchResponse) {
                    setState(() {
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 30,
                sections: getSectionsVerdicts(touchedIndex, usersubmissions),
                startDegreeOffset: -90,
              ),
              swapAnimationDuration: Duration(milliseconds: 50),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class PieChartTags extends StatefulWidget {
  final Size size;

  const PieChartTags({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  _PieChartTagsState createState() => _PieChartTagsState();
}

class _PieChartTagsState extends State<PieChartTags> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections =
        getSectionsTags(touchedIndex, usersubmissions);
    if (sections.isEmpty) return noData(widget.size);
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
            "Tags  of  ${userinfo.handle}",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: widget.size.height * 0.3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (pieTouchResponse) {
                    setState(() {
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 30,
                sections: sections,
                startDegreeOffset: -90,
              ),
              swapAnimationDuration: Duration(milliseconds: 50),
            ),
          ),
          SizedBox(height: 30),
          // TagsList(size: widget.size, tags: tagsFromData(usersubmissions)),
        ],
      ),
    );
  }
}

class TagsList extends StatelessWidget {
  final Size size;
  final List<PieData> tags;
  const TagsList({Key? key, required this.size, required this.tags})
      : super(key: key);

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
          Text(
            "TagsList  of  ${userinfo.handle}",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: size.height * 0.4,
            child: ListView.builder(
              // scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: PieChartColors[index % PieChartColors.length],
                          size: 20,
                        ),
                        Text(
                          "  " + tags[index].name,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Text(
                      tags[index].value.toInt().toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProblemsRatings extends StatefulWidget {
  final Size size;
  const ProblemsRatings({Key? key, required this.size}) : super(key: key);

  @override
  _ProblemsRatingsState createState() => _ProblemsRatingsState();
}

class _ProblemsRatingsState extends State<ProblemsRatings> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups =
        get_ratings_bars(touchedIndex, usersubmissions);
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
            "Problem Ratings of ${userinfo.handle}",
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
                width: widget.size.width * 4.0,
                padding: EdgeInsets.only(right: 10, bottom: 10),
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                        touchTooltipData:
                            BarTouchTooltipData(tooltipBgColor: Colors.white)),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(
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
                          return TextStyle(color: Colors.black);
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
                    maxY: maxRatingCount * 1.5,
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

class ProblemLevels extends StatefulWidget {
  final Size size;
  const ProblemLevels({Key? key, required this.size}) : super(key: key);

  @override
  _ProblemLevelsState createState() => _ProblemLevelsState();
}

class _ProblemLevelsState extends State<ProblemLevels> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups =
        get_indexes_bars(touchedIndex, usersubmissions);
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
            "Problem Levels of ${userinfo.handle}",
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
                width: widget.size.width * 3.0,
                padding: EdgeInsets.only(right: 10, bottom: 10),
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                        touchTooltipData:
                            BarTouchTooltipData(tooltipBgColor: Colors.white)),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      // Build X axis.
                      bottomTitles: SideTitles(
                        getTextStyles: (context, value) {
                          return TextStyle(color: Colors.black);
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
                          return TextStyle(color: Colors.black);
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
                    maxY: maxLevelCount * 1.5,
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

class NumberOfQues extends StatelessWidget {
  final ProblemData problemsData = getProblemsData(usersubmissions);
  final Size size;
  NumberOfQues({Key? key, required this.size}) : super(key: key);

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
          Text(
            "Problem Submissions of ${userinfo.handle}",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          listTileProblems(
              "${problemsData.solvedQuestions}", "Problems Solved of all Time"),
          listTileProblems(
              "${problemsData.triedQuestions}", "Problems Tried of all Time"),
          listTileProblems("${problemsData.solvedInOneAttempt}",
              "Problems Solved in 1 attempt"),
          listTileProblems("${problemsData.avgAttempt.toStringAsFixed(2)}",
              "Average Attempt"),
          listTileProblems("${problemsData.maxAttempt}", "Maximum Attempts"),
          listTileProblems(
              "${problemsData.maxAcceptedForSameQues}", "Maximum Acc Sol"),
        ],
      ),
    );
  }
}

class NumOfContests extends StatelessWidget {
  final RatingChangeData ratingsData = getRatingChangeData(userratingchanges);
  final Size size;
  NumOfContests({Key? key, required this.size}) : super(key: key);

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
          Text(
            "Contest Participation of ${userinfo.handle}",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          listTileContests(
              "${ratingsData.numOfContests}", "Number Of Contests"),
          listTileContests("${ratingsData.bestRank}", "Best Rank"),
          listTileContests("${ratingsData.worstRank}", "Worst Rank"),
          listTileContests("${ratingsData.maxUp}", "Max Up"),
          listTileContests("${ratingsData.maxDown}", "Max Down"),
        ],
      ),
    );
  }
}

class RatingsChart extends StatefulWidget {
  final Size size;
  const RatingsChart({Key? key, required this.size}) : super(key: key);

  @override
  _RatingsChartState createState() => _RatingsChartState();
}

class _RatingsChartState extends State<RatingsChart> {
  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> spots =
        getSpotsRatingsTimelineSingleUser(userratingchanges);
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
                width: widget.size.width * 5.0,
                padding:
                    EdgeInsets.only(right: 20, bottom: 10, top: 10, left: 10),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                        touchTooltipData:
                            LineTouchTooltipData(tooltipBgColor: Colors.white)),
                    borderData: FlBorderData(show: false),
                    maxY: 4500.0,
                    minY: 0.0,
                    gridData: FlGridData(
                      drawHorizontalLine: false,
                    ),
                    titlesData: FlTitlesData(
                      // Build X axis.
                      bottomTitles: _bottomTitles(),
                      // Build Y axis.
                      leftTitles: SideTitles(
                        getTextStyles: (context, value) {
                          return TextStyle(color: Colors.black, fontSize: 12);
                        },
                        showTitles: true,
                        interval: 500,
                        getTitles: (value) {
                          if (value == 0.0) return "";
                          return value.toInt().toString();
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

Widget listTileProblems(String leading, String title) {
  return ListTile(
    leading: Text(
      leading,
      style: TextStyle(
        color: Colors.indigo,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget listTileContests(String trailing, String title) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
    trailing: Text(
      trailing,
      style: TextStyle(
        color: Colors.indigo,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

SideTitles _bottomTitles() {
  int m1 = userratingchanges.length;
  int _minX = 0;
  int _maxX = 0;

  if (m1 >= 1) _minX = userratingchanges[0].ratingUpdateTimeSeconds;
  if (m1 >= 1) _maxX = userratingchanges[m1 - 1].ratingUpdateTimeSeconds;
  _maxX += 100000;
  return SideTitles(
    getTextStyles: (context, value) {
      return TextStyle(color: Colors.black, fontSize: 12);
    },
    showTitles: true,
    getTitles: (value) {
      final DateTime date =
          DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000);
      return DateFormat.yMMM().format(date);
    },
    margin: 8,
    interval: (_maxX - _minX) / 10,
  );
}

Widget noData(Size size) {
  return Container(
    width: size.width,
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
    child: Center(
      child: Text(
        "No Data",
        style: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
      ),
    ),
  );
}
