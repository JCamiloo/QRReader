import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qrreader/src/bloc/scans_bloc.dart';
import 'package:qrreader/src/models/scan_model.dart';
import 'package:qrreader/src/pages/adresses_page.dart';
import 'package:qrreader/src/pages/maps_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreader/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          ),
          
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _createBottomNavigationBar(),
      floatingActionButton: _createFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _callPage(int currentPage) {
    switch (currentPage) {
      case 0: return MapsPage();
      case 1: return AdressesPage();
      default: return MapsPage();
    }
  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Adresses')
        )
      ],
    );
  }

  Widget _createFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: _scanQR,
      backgroundColor: Theme.of(context).primaryColor
    );
  }

  _scanQR() async {
    // https://pub.dev/packages/barcode_scan/versions
    // geo:40.62737197776518,-73.92354383906253
    String result = 'https://pub.dev/packages/barcode_scan/versions';
    String result2 = 'geo:40.62737197776518,-73.92354383906253';
    // try {
    //   result = await BarcodeScanner.scan();
    //   print(result);
    // } catch(e) {
    //   result = e.toString();
    //   print(result);
    // }

    if (result != null) {
      final scan = Scan(value: result);
      final scan2 = Scan(value: result2);
      scansBloc.addScan(scan);
      scansBloc.addScan(scan2);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () => utils.openScan(scan));
      } else {
        utils.openScan(scan);
      }
    }
  }
}