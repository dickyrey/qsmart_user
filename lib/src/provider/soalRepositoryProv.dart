import 'package:flutter/foundation.dart';

import '../model/banksoall_quicktype.dart';
import '../model/listbanksoal_model.dart';
import '../service/realdb_api.dart';

class SoalRepositoryProv with ChangeNotifier {
  RealdbApi api = RealdbApi();

  Listbanksoal _banksoal;
  List<Soalnye> _soalnye;

  Listbanksoal get banksoal => _banksoal;
  List<Soalnye> get soalnye => _soalnye;

  set banksoal(Listbanksoal val) {
    _banksoal = val;
    notifyListeners();
  }

  set soalnye(List<Soalnye> val) {
    _soalnye = val;
    notifyListeners();
  }

  void clear() {
    _banksoal = null;
    notifyListeners();
  }

  Future<List<Soalnye>> getsetBankSoalnye(String idsoal) async {
    var res = await api.getSoalnye(idsoal);
    _soalnye = res;
    return soalnye;
  }
  // Future<List<Soalnye>> getsetListSoalnye(String id)async{
  //   var res = await api.get
  // }
}
