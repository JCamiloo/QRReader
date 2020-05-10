import 'package:flutter/material.dart';
import 'package:qrreader/src/bloc/scans_bloc.dart';
import 'package:qrreader/src/models/scan_model.dart';
import 'package:qrreader/src/utils/utils.dart' as utils;

class MapsPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Scan>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<Scan>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.length == 0) {
          return Center(child: Text('No data'));
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direction) => scansBloc.deleteScan(snapshot.data[i].id),
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor),
              title: Text(snapshot.data[i].value),
              subtitle: Text('id: ${snapshot.data[i].id}'),
              trailing: Icon(Icons.arrow_forward, color: Colors.grey),
              onTap: () => utils.openScan(snapshot.data[i]),
            ),
          )
        );
      }
    );
  }
}