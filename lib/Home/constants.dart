import 'package:flutter/material.dart';
import  'package:intl/intl.dart';

var mydefaultbackgroundColor = Colors.grey[30];

var myAppBar = AppBar(backgroundColor: Colors.blue);

class DateTimeManager{
  String get_date_in_days(){
    String cdate1 = DateFormat("EEEEE, dd, yyyy").format(DateTime.now());
    return cdate1;
  }
  String get_date_in_digits(){
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    return cdate;
  }
}