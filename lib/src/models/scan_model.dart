import 'package:latlong/latlong.dart';

class Scan {

  int id;
  String type;
  String value;

  Scan({ this.id, this.type, this.value }) {
    if (this.value.contains('http')) {
      this.type = 'http';
    } else {
      this.type = 'geo';
    }
  }

  factory Scan.fromJson(Map<String, dynamic> json) => new Scan(
    id: json['id'],
    type: json['type'],
    value: json['value']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "value": value
  };

  LatLng getLatLng() {
    final latLong = value.substring(4).split(',');
    final lat = double.parse(latLong[0]);
    final lng = double.parse(latLong[1]);

    return LatLng(lat, lng);
  }
}