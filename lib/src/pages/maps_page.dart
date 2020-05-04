import 'package:flutter/material.dart';
import 'package:qrreader/src/providers/db_provider.dart';

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Scan>>(
      future: DBProvider.db.getScans(),
      builder: (BuildContext context, AsyncSnapshot<List<Scan>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.length == 0) {
          return Center(child: Text('No data'));
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, i) => ListTile(
            leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor),
            title: Text(snapshot.data[i].value),
            trailing: Icon(Icons.arrow_forward, color: Colors.grey),
          )
        );
      }
    );
  }
}