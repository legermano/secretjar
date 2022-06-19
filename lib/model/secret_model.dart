import 'package:hive/hive.dart';

String boxName = "secrets";

class SecretModel {
  Box box = Hive.box(boxName);

  Iterable<dynamic> getAll() {
    return box.values;
  }

  dynamic get(int index) {
    return box.getAt(index);
  }

  Future<void> delete(int index) async {
    await box.deleteAt(index);
  }

  Future<void> save(dynamic values, {int? index}) async {
    if (index == null) {
      await box.add(values);
    } else {
      await box.putAt(index, values);
    }
  }
}
