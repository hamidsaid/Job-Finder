import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_finder/Job.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> jobList = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/jobs.json');
    final data = await json.decode(response);

    setState(() {
      jobList = data['jobs'].map((data) => Job.fromJson(data)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          //leading property adds an icon to start of appbar
          leading: IconButton(
            padding: EdgeInsets.only(top: 20.0),
            color: Colors.black54,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
          //actions widget add icon to the end
          actions: <Widget>[
            IconButton(
              iconSize: 30,
              padding: const EdgeInsets.only(top: 20.0),
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.black54,
              ),
              onPressed: () {
                // do something
              },
            )
          ],
          title: Container(
            margin: EdgeInsets.only(top: 10),
            height: 45.0,
            child: TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search job",
                hintStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: jobList.length,
          itemBuilder: (context, index) {
            return jobCard(job: jobList[index]);
          },
        ),
      ),
    );
  }

  jobCard({required Job job}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 3,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  job.companyLogo,
                  height: 60.0,
                  width: 60.0,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    job.address,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    job.isMyFav = !job.isMyFav;
                  });
                },
                child: AnimatedContainer(
                    padding: EdgeInsets.all(5),
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: job.isMyFav
                              ? Colors.red.shade100
                              : Colors.grey.shade300,
                        )),
                    child: Center(
                        child: job.isMyFav
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_outline,
                                color: Colors.grey.shade600,
                              ))),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.0),
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  job.type,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    color: Color(int.parse("0xff${job.experienceLevelColor}"))
                        .withAlpha(20),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  job.experienceLevel,
                  style: TextStyle(
                    color: Color(int.parse("0xff${job.experienceLevelColor}")),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  job.timeAgo,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
