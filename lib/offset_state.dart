import 'package:flutter/cupertino.dart';

class OffsetState extends ChangeNotifier {
  Offset offset = Offset(0, 0);

  update(Offset ofst) {
    print(ofst.toString());
    offset = ofst;
    notifyListeners();
  }
}
