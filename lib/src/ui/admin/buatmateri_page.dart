import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/staticdata.dart';
import '../../model/materi_model.dart';
import '../../provider/materiprov.dart';
import '../../service/realdb_api.dart';

class BuatMateriPage extends StatelessWidget {
  final MateriModel materi;
  BuatMateriPage({this.materi});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(materi == null ? "Buat Materi" : "Edit Materi"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Tabeditmateri(materi),
    );
  }
}

class Tabeditmateri extends StatefulWidget {
  final MateriModel materi;
  Tabeditmateri(this.materi);
  @override
  _TabeditmateriState createState() => _TabeditmateriState();
}

class _TabeditmateriState extends State<Tabeditmateri> {
  RealdbApi api = RealdbApi();
  @override
  Widget build(BuildContext context) {
    final materiProv = Provider.of<MateriProv>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              hint: Text('Pilih Tingkat'),
              value: materiProv.tingkat,
              onChanged: (val) {
                materiProv.tingkat = val;
              },
              items: ["SD", "SMP", "SMA-IPS", "SMA-IPA"].map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                (materiProv.tingkat == null)
                    ? Container()
                    : DropdownButton<String>(
                        hint: Text('Pilih Mapel'),
                        value: materiProv.mapel,
                        onChanged: (val) {
                          materiProv.mapel = val;
                        },
                        items:
                            StaticData().mapelV2[materiProv.tingkat].map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                      ),
                (materiProv.tingkat == null)
                    ? Container()
                    : DropdownButton<String>(
                        hint: Text('pilih kelas'),
                        value: materiProv.kelas,
                        onChanged: (val) {
                          materiProv.kelas = val;
                        },
                        items:
                            StaticData().kelasV2[materiProv.tingkat].map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                      ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: 14.0, left: 14.0),
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                decoration: InputDecoration(labelText: 'Judul'),
                controller: materiProv.ttitel,
                minLines: 2,
                maxLines: 3,
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(right: 14.0, left: 14.0),
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                decoration: InputDecoration(labelText: "isi materi"),
                controller: materiProv.tisi,
                minLines: 5,
                maxLines: 10,
                maxLengthEnforced: true,
              ),
            ),
            (widget.materi) == null
                ? FlatButton(
                    color: Colors.green,
                    child: Text('Simpan'),
                    onPressed: (materiProv.tingkat == null ||
                            materiProv.kelas == null ||
                            materiProv.kelas == null)
                        ? null
                        : () {
                            api
                                .buatmateri(MateriModel(
                                  tingkat: materiProv.tingkat,
                                  mapel: materiProv.mapel,
                                  kelas: materiProv.kelas,
                                  titel: materiProv.ttitel.text,
                                  isimateri: materiProv.tisi.text,
                                ))
                                .then((_) => Navigator.pop(context));
                          },
                  )
                : FlatButton(
                    color: Colors.green,
                    child: Text('Edit'),
                    onPressed: (materiProv.tingkat == null ||
                            materiProv.kelas == null ||
                            materiProv.kelas == null)
                        ? null
                        : () {
                            api
                                .editmateri(MateriModel(
                                  id: widget.materi.id,
                                  tingkat: materiProv.tingkat,
                                  mapel: materiProv.mapel,
                                  kelas: materiProv.kelas,
                                  titel: materiProv.ttitel.text,
                                  isimateri: materiProv.tisi.text,
                                ))
                                .then((_) => Navigator.pop(context));
                          },
                  )
          ],
        ),
      ),
    );
  }
}
