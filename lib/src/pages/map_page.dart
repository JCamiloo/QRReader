import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreader/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final mapCtrl = MapController();
  String mapType = 'streets';

  @override
  Widget build(BuildContext context) {

    final Scan scan = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Coordinates'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              mapCtrl.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: Center(
        child: _createFlutterMap(scan),
      ),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }

  Widget _createFlutterMap(Scan scan) {
    return FlutterMap(
      mapController: mapCtrl,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _createMap(),
        _createMarkers(scan)
      ],
    );
  }

  _createMap() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiamNhbWlsb28iLCJhIjoiY2s2NDZiaDdxMGM3aTNqbXBtMnk3ZmQ5biJ9.bLy1nepm5WTdN8sqWiNd0w',
        'id': 'mapbox.$mapType'
      }
    );
  }

  _createMarkers(Scan scan) {
    return MarkerLayerOptions(
      markers: <Marker> [
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on, 
              size: 70,
              color: Theme.of(context).primaryColor,
            ),
          )
        )
      ]
    );
  }

  Widget _createFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        switch (mapType) {
          case 'streets': { mapType = 'dark'; }
          break;
          case 'dark': { mapType = 'light'; }
          break;
          case 'light': { mapType = 'outdoors'; }
          break;
          case 'outdoors': { mapType = 'satellite'; }
          break;
          default: { mapType = 'streets'; }
          break;
        }
        setState(() {});
      },
    );
  }
}