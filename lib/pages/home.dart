import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photoshare/pages/activity_feed.dart';
import 'package:photoshare/pages/profile.dart';
import 'package:photoshare/pages/search.dart';
import 'package:photoshare/pages/timeline.dart';
import 'package:photoshare/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';

//create a googleSignIn instance
final GoogleSignIn googleSignIn = GoogleSignIn();

//Home Page
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//Home page's state
class _HomeState extends State<Home> {
  //a boolean indicates if the user is authenticated
  bool isAuth = false;
  //a controller to indicate what page to display
  PageController pageController;
  //page number
  int pageIndex = 0;

  //constructor
  @override
  void initState() {
    super.initState(); //call super
    pageController = PageController(); //initializer pageController

    // Listener to detect when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });

    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  //check if account passed in is not null
  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      //is user exists, set isAuth to true
      print('User signed in!: $account');
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  //dispose pages when transit to other pages
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //signin user using google
  login() {
    googleSignIn.signIn();
  }

  //signout user
  logout() {
    googleSignIn.signOut();
  }

  //updates page number upon transition
  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  //handles icon tap for page transition
  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //build main widget
  Scaffold buildAuthScreen() {
    return Scaffold(
      //body widget
      body: PageView(
        //list of all pages
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        //page controller
        controller: pageController,
        //pageChanged
        onPageChanged: onPageChanged,
        //disable page scrolling
        physics: NeverScrollableScrollPhysics(),
      ),
      //bottome nav bar
      bottomNavigationBar: CupertinoTabBar(
          //current page
          currentIndex: pageIndex,
          //handle tap event
          onTap: onTap,
          //active icon's color
          activeColor: Theme.of(context).primaryColor,
          //all icons
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
                size: 35.0,
              ),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search)),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
          ]),
    );
    // return RaisedButton(
    //   child: Text('Logout'),
    //   onPressed: logout,
    // );
  }

  //build signin widget
  Scaffold buildUnAuthScreen() {
    return Scaffold(
      //body widget
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'FlutterShare',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/google_signin_button.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    //no bottom nav bar
  }

  //build the whole page
  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
