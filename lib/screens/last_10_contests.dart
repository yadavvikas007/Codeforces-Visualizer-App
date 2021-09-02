import 'package:codeforces_visualizer/components/error_screen.dart';
import 'package:codeforces_visualizer/screens/widgets/bar_groups.dart';
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
import 'singleUserDetailsPage.dart';
import 'singleUserScreenModels/contests.dart' as Contest;
import 'package:codeforces_visualizer/screens/singleUserScreenModels/contestProblems.dart'
    as ContestProblems;

late List<Contest.Result> last10contests = [];
late List<ContestProblems.Problems> last10contestProblems = [];

class Tag {
  final String tag;
  final int value;
  Tag(this.tag, this.value);
}

List<Tag> getTags() {
  Map<String, int> mp = {};
  last10contestProblems.forEach((element) {
    element.tags.forEach((t) {
      if (mp.containsKey(t))
        mp[t] = mp[t]! + 1;
      else
        mp[t] = 1;
    });
  });
  List<Tag> res = [];
  mp.forEach((key, value) {
    if (key != " " && value > 0) res.add(new Tag(key, value));
  });
  res.sort((a, b) => b.value.compareTo(a.value));
  return res;
}

class Bar {
  final int name;
  final int value;
  Bar(this.name, this.value);
}

List<BarChartGroupData> getRatingsBarGroups() {
  Map<int, int> mp = {};
  last10contestProblems.forEach((element) {
    if (mp.containsKey(element.rating))
      mp[element.rating] = mp[element.rating]! + 1;
    else
      mp[element.rating] = 1;
  });
  List<Bar> data = [];
  mp.forEach((key, value) {
    if (key > 0 && value > 0) data.add(new Bar(key, value));
  });

  List<BarChartGroupData> bdata = [];
  data.forEach(
    (element) {
      if (element.name > 0) {
        BarChartGroupData d = new BarChartGroupData(
          x: element.name,
          barRods: [
            BarChartRodData(
              y: element.value.toDouble(),
              colors: [Colors.indigo],
              width: 30,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
            ),
          ],
        );
        bdata.add(d);
      }
    },
  );
  return bdata;
}

class Barlvl {
  final String name;
  final int value;
  Barlvl(this.name, this.value);
}

List<BarChartGroupData> getLevelsBarGroups() {
  Map<String, int> mp = {};
  last10contestProblems.forEach((element) {
    String key = element.index[0];
    if (mp.containsKey(key))
      mp[key] = mp[key]! + 1;
    else
      mp[key] = 1;
  });
  List<Barlvl> data = [];
  mp.forEach((key, value) {
    if (key != "" && value > 0) data.add(new Barlvl(key, value));
  });

  List<BarChartGroupData> bdata = [];
  data.forEach(
    (element) {
      if (element.name != "" || element.name != " ") {
        BarChartGroupData d = new BarChartGroupData(
          x: f(element.name),
          barRods: [
            BarChartRodData(
              y: element.value.toDouble(),
              colors: [Colors.indigo],
              width: 30,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
            ),
          ],
        );
        bdata.add(d);
      }
    },
  );
  return bdata;
}

class Last10ContestsAnalysis extends StatefulWidget {
  const Last10ContestsAnalysis({Key? key}) : super(key: key);

  @override
  _Last10ContestsAnalysisState createState() => _Last10ContestsAnalysisState();
}

class _Last10ContestsAnalysisState extends State<Last10ContestsAnalysis> {
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
    //.........................................................................................
    Uri url = Uri.http(
        "www.codeforces.com", "/api/contest.list"); //to get last 10 contest ids
    //.........................................................................................

    //getting response
    http.Response contestResponse = await http.get(url);

    if (contestResponse.statusCode == 200) {
      //decoding
      var contestInfoJsonMap =
          convert.jsonDecode(contestResponse.body) as Map<String, dynamic>;
      //parsing
      Contest.Contests contestData =
          new Contest.Contests.fromJson(contestInfoJsonMap);
      //.........................................................................................

      //.....to get contest problem details of last 10 contests...............
      if (contestData.status == "FAILED") {
        setState(() {
          _child = Error2Screen();
        });
      } else {
        last10contests = contestData.result;
        //.........................................................................................

        //creating urls for 10 contests
        List<Uri> urls = [];
        last10contests.forEach(
          (element) {
            Uri url = Uri.http("www.codeforces.com",
                "/api/contest.standings?contestId=${element.id}&from=1&count=1&showUnofficial=false");
            urls.add(url);
          },
        );
        //.........................................................................................
        int m = urls.length;
        bool flag = true;
        //.........................................................................................
        //.......to get response of every contest url .........................
        for (int i = 0; i < m; i++) {
          //getting response
          http.Response contestResponse = await http.get(urls[i]);
          if (contestResponse.statusCode == 200) {
            //decoding
            var contestInfoJsonMap = convert.jsonDecode(contestResponse.body)
                as Map<String, dynamic>;
            //parsing
            ContestProblems.ContestProblems problemData =
                new ContestProblems.ContestProblems.fromJson(
                    contestInfoJsonMap);
            if (problemData.status == "FAILED") {
              //error handling
              setState(() {
                _child = Error2Screen();
              });
              flag = false;
              break;
            } else {
              //adding problems to the problems list
              List<ContestProblems.Problems> problems =
                  problemData.result.problems;
              problems.forEach(
                (problem) {
                  last10contestProblems.add(problem);
                },
              );
            }
          }
        }
        //.........................................................................................
        //if everything went right build the page
        if (flag)
          setState(() {
            _child = Details();
          });
      }
    } else {
      //error handling
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
        title: Text(
          "Last 10 Contests",
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Frequency(size: size),
              Tags(size: size, tags: getTags()),
              Ratings(size: size),
              Levels(size: size),
            ],
          ),
        ),
      ),
    );
  }
}

class Frequency extends StatefulWidget {
  final Size size;
  const Frequency({Key? key, required this.size}) : super(key: key);
  @override
  _FrequencyState createState() => _FrequencyState();
}

class _FrequencyState extends State<Frequency> {
  @override
  Widget build(BuildContext context) {
    int m = last10contests.length;
    double frequency = ((last10contests[0].startTimeSeconds -
            last10contests[m - 1].startTimeSeconds) /
        86400);
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
            "Contest Frequency",
            style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Text(
              "${frequency.toStringAsFixed(1)}",
              style: TextStyle(
                color: Colors.indigo,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: Text(
              "  Days/10 contests",
              style: TextStyle(
                color: Colors.indigo,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tags extends StatelessWidget {
  final Size size;
  final List<Tag> tags;
  const Tags({Key? key, required this.size, required this.tags})
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
            "Problem Tags",
            style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(height: 30),
          Container(
            height: size.height * 0.5,
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
                          "  " + tags[index].tag,
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

class Ratings extends StatefulWidget {
  final Size size;
  const Ratings({Key? key, required this.size}) : super(key: key);

  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = getRatingsBarGroups();
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
                height: widget.size.height * 0.4,
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
                          return TextStyle(color: Colors.black, fontSize: 12);
                        },
                        showTitles: true,
                        getTitles: (double value) {
                          if (value.toInt() % 5 != 0) return "";
                          return value.toInt().toString();
                        },
                      ),
                    ),
                    barGroups: barGroups,
                    groupsSpace: 50,
                    maxY: 13.0,
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

class Levels extends StatefulWidget {
  final Size size;
  const Levels({Key? key, required this.size}) : super(key: key);

  @override
  _LevelsState createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = getLevelsBarGroups();
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
                height: widget.size.height * 0.4,
                width: widget.size.width * 2.0,
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
                          if (value.toInt() % 5 != 0) return "";
                          return value.toInt().toString();
                        },
                      ),
                    ),
                    barGroups: barGroups,
                    groupsSpace: 50,
                    maxY: 23.0,
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
