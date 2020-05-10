import 'package:url_launcher/url_launcher.dart';
import 'package:qrreader/src/models/scan_model.dart';

openScan(Scan scan) async {
  if (scan.type == 'http') {
    if (await canLaunch(scan.value)) {
      await launch(scan.value);
    } else {
      throw 'Could not launch ${scan.value}';
    }
  } else {
    print('GEO...');
  }
}