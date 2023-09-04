// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({Key? key, this.index, this.menuItem}) : super(key: key);

  final index;
  final menuItem;

  _deslogar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', 'null');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: index == 0
          ? EdgeInsets.symmetric(horizontal: .05.sw)
          : EdgeInsets.only(right: .05.sw),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Stack(
            children: [
              SizedBox(
                width: 1.sw,
                child: Image.asset("assets/img/carro-azul.png"),
              ),
              Container(
                height: 1.sh,
                width: 1.sw,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                ),
              ),
              Center(
                child: Padding(
                  // padding: EdgeInsets.symmetric(
                  //   // vertical: .04.sh,
                  //   horizontal: .05.sw,
                  // ),
                  padding: const EdgeInsets.only(left: 0, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        // alignment: Alignment.bottomRight,
                        child: Icon(
                          menuItem[index]["icon"],
                          color: menuItem[index]["color"],
                        ),
                      ),
                      Text(
                        menuItem[index]['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (menuItem[index]["route"] == "/login") {
                      _deslogar();
                    }
                    Navigator.pushReplacementNamed(
                      context,
                      menuItem[index]["route"],
                    );
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SizedBox(
                    height: 1.sh,
                    width: 1.sw,
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
