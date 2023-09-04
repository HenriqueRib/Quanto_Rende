// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class GuillotineMenu extends StatefulWidget {
  const GuillotineMenu({Key? key}) : super(key: key);

  @override
  _GuillotineMenuState createState() => _GuillotineMenuState();
}

class _GuillotineMenuState extends State<GuillotineMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController animationControllerMenu;
  late Animation<double> animationMenu;
  late Animation<double> animationTitleFadeInOut;
  late _GuillotineAnimationStatus menuAnimationStatus;
  // ignore: non_constant_identifier_names, prefer_final_fields
  String _menu_title = 'Ola';
  final List<Map> _menus = <Map>[
    {
      "icon": Icons.home,
      "title": "Home",
      "color": Colors.teal,
      'route': "/tela_principal"
    },
    {
      "icon": Icons.view_agenda,
      "title": "Visualizar",
      "color": Colors.teal,
      'route': "/visualizar"
    },
    {
      "icon": Icons.calculate,
      "title": "Calcular",
      "color": Colors.teal,
      'route': "/aplicacao"
    },
    {
      "icon": Icons.edit,
      "title": "Marcar",
      "color": Colors.teal,
      'route': "/marcar"
    },
    // {
    //   "icon": Icons.settings,
    //   "title": "Configuração",
    //   "color": Colors.teal,
    //   'route': "/configuracao"
    // },
    {
      "icon": Icons.person,
      "title": "Perfil",
      "color": Colors.teal,
      'route': "/perfil"
    },
    {
      "icon": Icons.login,
      "title": "Sair",
      "color": Colors.teal,
      'route': "/login"
    },
  ];

  @override
  void initState() {
    super.initState();
    _getTitle();
    menuAnimationStatus = _GuillotineAnimationStatus.closed;

    ///
    /// Initialization of the animation controller
    ///
    animationControllerMenu = AnimationController(
        duration: const Duration(
          milliseconds: 1000,
        ),
        vsync: this)
      ..addListener(() {});

    ///
    /// Initialization of the menu appearance animation
    ///
    animationMenu = Tween(begin: -pi / 2.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationControllerMenu,
        curve: Curves.bounceOut,
        reverseCurve: Curves.bounceIn,
      ),
    )
      ..addListener(() {
        setState(() {
          // force refresh
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          menuAnimationStatus = _GuillotineAnimationStatus.open;
        } else if (status == AnimationStatus.dismissed) {
          menuAnimationStatus = _GuillotineAnimationStatus.closed;
        } else {
          menuAnimationStatus = _GuillotineAnimationStatus.animating;
        }
      });

    ///
    /// Initialization of the menu title fade out/in animation
    ///
    animationTitleFadeInOut =
        Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationControllerMenu,
      // ignore: prefer_const_constructors
      curve: Interval(
        0.0,
        0.5,
        curve: Curves.ease,
      ),
    ));
  }

  @override
  void dispose() {
    animationControllerMenu.dispose();
    super.dispose();
  }

  _deslogar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', 'null');
  }

  _getTitle() async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: non_constant_identifier_names, unused_local_variable
    setState(() {
      _menu_title = prefs.getString('menu_title')!;
    });
  }

  ///
  /// Play the animation in the direction that depends on the current menu status
  ///
  void _playAnimation() {
    try {
      if (menuAnimationStatus == _GuillotineAnimationStatus.animating) {
        // During the animation, do not do anything
      } else if (menuAnimationStatus == _GuillotineAnimationStatus.closed) {
        animationControllerMenu.forward().orCancel;
      } else {
        animationControllerMenu.reverse().orCancel;
      }
    } on TickerCanceled {
      // the animation go cancelled, probably because disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    double angle = animationMenu.value;

    return Transform.rotate(
      angle: angle,
      origin: const Offset(24.0, 56.0),
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: const Color(0xFF333333),
          child: Stack(
            children: <Widget>[
              ///
              /// Menu title
              ///
              Positioned(
                top: 32.0,
                left: 40.0,
                width: screenWidth,
                height: 24.0,
                child: Transform.rotate(
                  alignment: Alignment.topLeft,
                  origin: Offset.zero,
                  angle: pi / 2.0,
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Opacity(
                        opacity: animationTitleFadeInOut.value,
                        // ignore: prefer_const_constructors
                        child: Text(
                          _menu_title,
                          textAlign: TextAlign.center,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              ///
              /// Hamburger icon
              ///
              Positioned(
                top: 32.0,
                // left: 4.0,
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: _playAnimation,
                ),
              ),

              ///
              /// Menu content
              ///
              Padding(
                padding: const EdgeInsets.only(left: 61, top: 96.0),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _menus.map(
                      (menuItem) {
                        return ListTile(
                          leading: Icon(
                            menuItem["icon"],
                            color: menuItem["color"],
                          ),
                          title: RaisedButton(
                            onPressed: () {
                              if (menuItem["route"] == "/login") {
                                _deslogar();
                              }
                              Navigator.pushReplacementNamed(
                                context,
                                menuItem["route"],
                              );
                            },
                            child: Text(
                              menuItem["title"],
                              style: TextStyle(
                                  color: menuItem["color"], fontSize: 24.0),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// Menu animation status
///
enum _GuillotineAnimationStatus { closed, open, animating }
