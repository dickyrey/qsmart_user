import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../model/banksoall_quicktype.dart';
import '../../model/listbanksoal_model.dart';
import '../../provider/jawabanprov.dart';
import '../../provider/newloginprov.dart';
import '../../provider/soalRepositoryProv.dart';
import '../../service/realdb_api.dart';
import 'resultnilai_page.dart';

class NewSoalnyaPage extends StatelessWidget {
  final String idSoalnya;
  final Listbanksoal detilsoal;
  NewSoalnyaPage({this.idSoalnya, this.detilsoal});

  final RealdbApi db = RealdbApi();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('yakin keluar ?'),
                  content: Text(
                      'jawaban anda akan dihapus dan tidak akan disimpan...'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Tidak'),
                      onPressed: () {
                        return Navigator.pop(_, false);
                      },
                    ),
                    FlatButton(
                      child: Text('Ya'),
                      onPressed: () {
                        Provider.of<JawabanProv>(context).listJawaban.clear();
                        return Navigator.pop(_, true);
                      },
                    ),
                  ],
                )).then((onValue) => onValue ?? false);
      },
      child: FutureBuilder<List<Soalnye>>(
        future: Provider.of<SoalRepositoryProv>(context)
            .getsetBankSoalnye(idSoalnya),
        builder: (context, snapsut) {
          print(snapsut.data);
          if ((snapsut.connectionState == ConnectionState.done)) {
            return (snapsut.hasData)
                ? DefaultTabController(
                    // key: GlobalKey(),
                    key: UniqueKey(),
                    initialIndex: 0,
                    length: snapsut.data.length - 1,
                    child: Scaffold(
                      key: UniqueKey(),
                      appBar: AppBar(
                        // title: Text(detilsoal.mapel + detilsoal.kelas),
                        actions: <Widget>[
                          TombolSudahdiUjungKananAppbar(
                            idsoal: idSoalnya,
                            jumlahsoal: snapsut.data.length - 1,
                          )
                        ],
                        bottom: TabBar(
                          isScrollable: true,
                          tabs: List<int>.generate(
                                  snapsut.data.length - 1,
                                  //(i)=>i+1).map((f)=>
                                  (i) => i + 1)
                              .map((f) => TabItemWiget(
                                    f: f,
                                  ))
                              .toList(),
                        ),
                      ),
                      body: TabBarView(
                          key: UniqueKey(),
                          children: List<Widget>.generate(
                              snapsut.data.length - 1, (int index) {
                            //  if (snapsut.data.soalnye[index+1]!=null){
                            return TabSoalBody(
                              key: UniqueKey(),
                              soalnye: snapsut.data,
                              index: index + 1,
                            );
                            // }else{
                            //    return Container(child: Text('data null: be intro, '),);
                            //  }
                          })),
                    ),
                  )
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.blue,
                    child: Center(
                      child: Text('something wrong :('),
                    ),
                  );
          } else {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class TombolSudahdiUjungKananAppbar extends StatelessWidget {
  final int jumlahsoal;
  final String idsoal;
  TombolSudahdiUjungKananAppbar({this.jumlahsoal, this.idsoal});
  final RealdbApi api = RealdbApi();

  // void _submitJawaban(idsoal,n,uid,nilai,context)async{
  //   api.simpanJawaban(idsoal,n, uid, nilai).then((_){
  //     Provider.of<JawabanProv>(context).clear();
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (__)=>ResultNilaiPage(nilai:nilai)));
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final jawabanProv = Provider.of<JawabanProv>(context);
    final user = Provider.of<NewLoginProv>(context);
    var data = jawabanProv.listJawaban;
    var nilai = jawabanProv.nilai;
    return Container(
      child: FlatButton(
        child: Text(
          'Selesai',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: (data.length == jumlahsoal)
            ? () async {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('kumpulkan jawaban ?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('batal'),
                              onPressed: () => Navigator.pop(_),
                            ),
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () async {
                                Navigator.pop(_);
                                api
                                    .simpanJawaban(
                                        idsoal,
                                        data,
                                        user.userNew.id,
                                        nilai,
                                        user.userNew.nama)
                                    .then((_) {
                                  //jawabanProv.clear();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (__) => ResultNilaiPage(
                                              nilai: nilai,
                                              idsoalcoeg: idsoal)));
                                });
                              },
                            ),
                          ],
                        ));
              }
            : null,
      ),
    );
  }
}

class TabItemWiget extends StatelessWidget {
  final int f;
  TabItemWiget({this.f});
  @override
  Widget build(BuildContext context) {
    final jawabanProv = Provider.of<JawabanProv>(context);
    return Tab(
      child: Text(
        f.toString(),
        style: TextStyle(
            color: (jawabanProv.listJawaban[f.toString()] == null)
                ? Colors.white
                : Colors.orangeAccent),
      ),
    );
  }
}

class TabSoalBody extends StatefulWidget {
  final List<Soalnye> soalnye;
  final int index;
  TabSoalBody({Key key, this.soalnye, this.index}) : super(key: key);

  @override
  _TabSoalBodyState createState() => _TabSoalBodyState();
}

class _TabSoalBodyState extends State<TabSoalBody>
    with AutomaticKeepAliveClientMixin<TabSoalBody> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final jawabanProv = Provider.of<JawabanProv>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        key: widget.key,
        child: Column(
          children: <Widget>[
            //Text("$index. ${soalnye[index].pertanyaan}"),
            Html(data: widget.soalnye[widget.index].pertanyaan),
            // PertanyaaRenderSekali(soalnye[index].pertanyaan),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                children: ["A", "B", "C", "D"]
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(),
                          child: Card(
                            elevation: 10.0,
                            child: ListTile(
                                leading: PilihanJwaban(f, widget.index),
                                title: Html(
                                    data: widget
                                        .soalnye[widget.index].jawaban[f]),
                                onTap: () => jawabanProv.addListJawabanAndPoint(
                                    (widget.index).toString(),
                                    f,
                                    widget.soalnye[widget.index].jawabanbenar)),
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PilihanJwaban extends StatelessWidget {
  final String f;
  final int index;
  PilihanJwaban(this.f, this.index);
  @override
  Widget build(BuildContext context) {
    final jawabanProv = Provider.of<JawabanProv>(context);
    return Card(
      color: jawabanProv.listJawaban[(index).toString()] == f
          ? Colors.orangeAccent
          : Colors.white,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('$f.'),
        ),
      ),
    );
  }
}
