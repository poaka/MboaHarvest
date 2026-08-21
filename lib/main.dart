import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

void main() async {
  await GetStorage.init();
  runApp(const AgroLinkApp());
}
