import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../model/materi_model.dart';

class DetilMateri extends StatelessWidget {
  final MateriModel materi;
  DetilMateri({this.materi});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(materi.mapel + " - " + materi.tingkat),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                materi.titel,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            Html(
              data: materi.isimateri,
            ),
          ],
        ),
      ),
    );
  }
}
