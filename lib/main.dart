import 'package:bikesecure/sharedpref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  starttimer() {
    Future.delayed(Duration(seconds: 1)).then((value) => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => SetPass()))
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starttimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        alignment: Alignment.center,
        child: Text(
          "Bike Security",
          style: TextStyle(
              fontSize: 28.0,
              color: Colors.orangeAccent,
              fontWeight: FontWeight.w600),
        ),
      )),
    );
  }
}

class SetPass extends StatefulWidget {
  const SetPass({super.key});

  @override
  State<SetPass> createState() => _SetPassState();
}

class _SetPassState extends State<SetPass> {
  TextEditingController tpass = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    var passwords = await SharedPrefManagerNative.getpass();
    if (passwords != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Dashboard()));
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*.30,),
              Text(
                "Set your Security Code",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: tpass,
                maxLength: 8,
                decoration: InputDecoration(
                    labelText: "Code",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    labelStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.orangeAccent))),
              ),
              GestureDetector(
                onTap: () async {
                  await SharedPrefManagerNative.setPass(tpass.text.toString());
                  tpass.clear();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => Dashboard()));
                },
                child: Container(
                  color: Colors.orangeAccent,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                    child: Text(
                      "Save it".toUpperCase(),
                      style: TextStyle(color: Colors.white,fontSize: 16.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isBikeon = false;
  bool isSecurity = false;
  var passwords;
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    passwords = await SharedPrefManagerNative.getpass();
    setState(() {});
    
  }

  securityon() {
    try{
      var res = http.get(Uri.parse('http://192.168.4.1/SecurityOn'));
    print("security on" + res.toString());
   
    }catch(e){
      print(e);
    }
    
  }

  bikeon() {
  try{
     var res = http.get(Uri.parse('http://192.168.4.1/$passwords'));
    print("bike on" + res.toString());
  }catch(e){
    print(e);
  }
   
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text("Welcome"),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(.5, .5),
                          spreadRadius: .2,
                          blurRadius: 3,
                          color: Colors.grey.shade100)
                    ],
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 120,
                  child: ListView(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(.5, .5),
                                  spreadRadius: .2,
                                  blurRadius: 3,
                                  color: Colors.grey.shade100)
                            ],
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            trailing: CupertinoSwitch(
                                value: isBikeon,
                                onChanged: (v) {
                                  isBikeon = v;
                                  if (v == true) {
                                    isSecurity = false;

                                    // securityon();

                                     bikeon();
                                  } else {
                                    isBikeon = false;
                                    //isSecurity=false;
                                  }
                                  setState(() {});
                                }),
                            title: Text(
                              "Bike start",
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w600),
                            ),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(.5, .5),
                                spreadRadius: .2,
                                blurRadius: 3,
                                color: Colors.grey.shade100)
                          ],
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          trailing: CupertinoSwitch(
                              value: isSecurity,
                              onChanged: (v) {
                                isSecurity = v;
                                if (v == true) {
                                  isBikeon = false;

                                  securityon();

                                } else {
                                  // isBikeon=false;
                                  isSecurity = false;
                                }
                                setState(() {});
                              }),
                          title: Text(
                            "Security On",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          child: IconButton(
              onPressed: () {
                shodia();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ),
      ),
    );
  }

  shodia() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              actions: [
                
                Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Do you want Logout ?",style: TextStyle(fontSize: 18.0),),
                ))
             , Row(mainAxisAlignment: MainAxisAlignment.end,children: [ElevatedButton(onPressed: (){
SharedPrefManagerNative.paasclear();
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SetPass()));

             }, child:  Text("Yes",style: TextStyle(fontSize: 15.0),)
              )],)
              ],
              actionsPadding: EdgeInsets.all(8.0),

            ));
  }
}
