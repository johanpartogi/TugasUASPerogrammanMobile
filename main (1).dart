import 'package:flutter/material.dart';
import 'package:myapp/movie_page.dart';
import 'package:myapp/movie_page_create.dart';
//import 'list_page.dart';
//import 'customcard.dart';
//import 'customdatatable.dart';
import 'customlistview.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Anggota Club',
      theme: ThemeData(primarySwatch: Colors.blue),
      //home: ListPage(),
      //home:CustomCardViewExample(),
      //home:CustomListView(),
      home: const MovieListPage(),
      //home:DataTableExample(),
);
}
}