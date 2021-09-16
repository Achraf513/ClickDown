import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget smartphone;
  final Widget desktop;
  const ResponsiveLayout({ Key? key, required this.smartphone,required this.desktop }) : super(key: key);
  
  static int smartphoneLimit = 480;

  bool isSmarthPhone(BuildContext context)=>MediaQuery.of(context).size.width<=smartphoneLimit;
  bool isDesktop(BuildContext context)=>MediaQuery.of(context).size.width>smartphoneLimit;
  @override
  Widget build(BuildContext context) {
    return isDesktop(context)?desktop:smartphone;
  }
}