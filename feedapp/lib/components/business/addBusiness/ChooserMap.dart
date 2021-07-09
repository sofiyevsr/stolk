import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooseResult {
  final LatLng loc;
  final String? address;
  const ChooseResult({required this.loc, this.address});
}

class ChooserMap extends StatefulWidget {
  final ChooseResult? data;
  const ChooserMap(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  _ChooserMapState createState() => _ChooserMapState();
}

class _ChooserMapState extends State<ChooserMap> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _location;
  String? _place;
  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      print(widget.data);
      setState(() {
        _place = widget.data?.address;
        _location = widget.data?.loc;
      });
      final loc = widget.data?.loc;
      if (loc != null)
        _controller.future.then((value) {
          value.moveCamera(
            CameraUpdate.newLatLng(loc),
          );
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                markers: {
                  if (_location != null)
                    Marker(markerId: MarkerId("loc"), position: _location!),
                },
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(40.409264, 49.867092),
                  zoom: 15,
                ),
                onTap: (l) async {
                  setState(() {
                    _location = l;
                  });
                  final place =
                      await placemarkFromCoordinates(l.latitude, l.longitude);
                  if (place[0].street != null)
                    setState(() {
                      _place = place[0].street;
                    });
                },
              ),
            ),
            if (_place != null) Text(_place!),
            ElevatedButton(
              onPressed: () {
                if (_location != null)
                  Navigator.of(context).pop<ChooseResult>(
                    ChooseResult(
                      loc: _location!,
                      address: _place,
                    ),
                  );
              },
              child: Text("confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
