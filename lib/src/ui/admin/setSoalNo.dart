import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../model/banksoall_quicktype.dart';
import '../../provider/buatsoalprov.dart';
import '../../service/realdb_api.dart';
import '../../service/systemcall.dart';

class SetSoalNo extends StatelessWidget {
  final String nosoal;
  final String idsoal;
  final String tingkat;

  SetSoalNo({this.nosoal, this.idsoal, this.tingkat});

  final RealdbApi api = RealdbApi();

  @override
  Widget build(BuildContext context) {
    //final bsoal = Provider.of<BuatSoalProv>(context,listen: false);
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          return showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Soal Belum disimpan ?'),
                    //content: Text(''),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          'batal',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          return Navigator.pop(_, false);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Exit Ok',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          return Navigator.pop(_, true);
                        },
                      ),
                    ],
                  )).then((onValue) => onValue ?? false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Soal No: $nosoal"),
            bottom: TabBar(
              onTap: (i) =>
                  SystemChannels.textInput.invokeMethod('TextInput.hide'),
              tabs: <Widget>[
                Tab(
                  text: "Edit",
                ),
                Tab(
                  text: "Preview",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              TabEditCoeg(
                nosoal: nosoal,
                idsoal: idsoal,
                tingkat: tingkat,
              ),
              TabPreviewCoeg(
                tingkat:tingkat,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TabEditCoeg extends StatelessWidget {
  final String nosoal;
  final String idsoal;
  final String tingkat;

  TabEditCoeg({this.nosoal, this.idsoal, this.tingkat});

  // final _formkeys = GlobalKey<FormState>();
  final RealdbApi api = RealdbApi();

  @override
  Widget build(BuildContext context) {
    final bsoal = Provider.of<BuatSoalProv>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            TextField(
              controller: bsoal.tsoal,
              decoration: InputDecoration(labelText: 'isi soal'),
              //validator: (i)=>i.length>=1?null:"tak bolehkosong",
              minLines: 4,
              maxLines: 5,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: bsoal.tjawabanA,
              //validator: (i)=>i.length>=1?null:"tak bolehkosong",
              decoration: InputDecoration(labelText: 'Pilihan A:'),
            ),
            TextField(
              //validator: (i)=>i.length>=1?null:"tak bolehkosong",
              controller: bsoal.tjawabanB,
              decoration: InputDecoration(labelText: 'Pilihan B:'),
            ),
            TextField(
              //validator: (i)=>i.length>=1?null:"tak bolehkosong",
              controller: bsoal.tjawabanC,
              decoration: InputDecoration(labelText: 'Pilihan C:'),
            ),
            TextField(
              //validator: (i)=>i.length>=1?null:"tak bolehkosong",
              controller: bsoal.tjawabanD,
              decoration: InputDecoration(labelText: 'Pilihan D:'),
            ),
            tingkat == "SMA-IPS"
                ? TextField(
                    //validator: (i)=>i.length>=1?null:"tak bolehkosong",
                    controller: bsoal.tjawabanE,
                    decoration: InputDecoration(labelText: 'Pilihan E:'),
                  )
                : tingkat == "SMA-IPA"
                    ? TextField(
                        //validator: (i)=>i.length>=1?null:"tak bolehkosong",
                        controller: bsoal.tjawabanE,
                        decoration: InputDecoration(labelText: 'Pilihan E:'),
                      )
                    : Container(),
            Divider(),
            Text('jawaban benar:'),
            DropdownButton<String>(
              //validator: (i)=>i.length>=1?null:"tak bolehkosong",
              hint: Text('pilih Jawaban benar'),
              value: bsoal.jawabanBenar,
              onChanged: (val) {
                bsoal.jawabanBenar = val;
              },
              items: [
                "A",
                "B",
                "C",
                "D",
                tingkat == "SMA-IPS" ? "E" : tingkat == "SMA-IPA" ? "E" : ""
              ].map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
            ),
            TextField(
              //validator: (i)=>i.length>=1?null:"tak bolehkosong",
              controller: bsoal.tPembahasan,
              decoration: InputDecoration(labelText: 'Pembahasan :'),
            ),
            RaisedButton(
              child: Text('submit'),
              onPressed: () async {
                if (true) {
                  return api
                      .setSoal(
                          idsoal,
                          nosoal,
                          Soalnye(
                              pertanyaan:
                                  SystemCall.encodetoBase64(bsoal.tsoal.text),
                              jawaban: {
                                "A": SystemCall.encodetoBase64(
                                    bsoal.tjawabanA.text),
                                "B": SystemCall.encodetoBase64(
                                    bsoal.tjawabanB.text),
                                "C": SystemCall.encodetoBase64(
                                    bsoal.tjawabanC.text),
                                "D": SystemCall.encodetoBase64(
                                    bsoal.tjawabanD.text),
                                "E": SystemCall.encodetoBase64(
                                    bsoal.tjawabanE.text)
                              },
                              jawabanbenar: bsoal.jawabanBenar,
                              pembahasan: SystemCall.encodetoBase64(
                                  bsoal.tPembahasan.text)))
                      .then((_) {
                    bsoal.clear();
                    Navigator.pop(context);
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class TabPreviewCoeg extends StatelessWidget {
  final String tingkat;

  const TabPreviewCoeg({Key key, this.tingkat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bsoal = Provider.of<BuatSoalProv>(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Html(
            data: bsoal.tsoal.text,
          ),
          Card(
              child: ListTile(
            leading: Text('A'),
            title: Html(
              data: bsoal.tjawabanA.text,
            ),
          )),
          Card(
              child: ListTile(
            leading: Text('B'),
            title: Html(
              data: bsoal.tjawabanB.text,
            ),
          )),
          Card(
              child: ListTile(
            leading: Text('C'),
            title: Html(
              data: bsoal.tjawabanC.text,
            ),
          )),
          Card(
              child: ListTile(
            leading: Text('D'),
            title: Html(
              data: bsoal.tjawabanD.text,
            ),
          )),
          tingkat == "SMA-IPS"
              ? Card(
                  child: ListTile(
                  leading: Text('E'),
                  title: Html(
                    data: bsoal.tjawabanE.text,
                  ),
                ))
              : tingkat == "SMA-IPA"
                  ? Card(
                      child: ListTile(
                      leading: Text('E'),
                      title: Html(
                        data: bsoal.tjawabanE.text,
                      ),
                    ))
                  : Container(),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Text('Jawaban Benar: ${bsoal.jawabanBenar}'),
          Divider(),
          Card(
              child: ListTile(
            leading: Text(''),
            title: Html(
              data: bsoal.tPembahasan.text,
            ),
          )),
        ],
      ),
    );
  }
}
