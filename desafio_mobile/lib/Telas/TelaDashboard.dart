import 'package:desafio_mobile/Componentes/AppDrawer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Models
import 'package:desafio_mobile/Model/ModelSqlLite/Cruds/LocalizationCrud.dart'
    as Localization;
import 'package:desafio_mobile/Model/ModelSqlLite/Cruds/LoginCrud.dart'
    as Login;

class TelaDashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TelaDashboardState();
}

class TelaDashboardState extends State<TelaDashboard> {
  GoogleMapController? mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  int _markerIdCounter = 1;

  Location location = new Location();

  _animateToUser() async {
    var pos = await location.getLocation();

    var datenow = new DateTime.now();
    String datetime = DateFormat('yyyy-MM-dd kk:mm:ss').format(datenow);

    int localizationId =
        await Localization.inserir(pos.latitude, pos.longitude, datetime);

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      print(currentUser.uid);
      int loginId = await Login.verificaSeExisteRegistro(currentUser.uid);

      Map<String, dynamic> updateRow = {
        '_id': loginId,
        'localization_id': localizationId,
      };

      Login.atualizar(updateRow);

      Localization.consultar();
      Login.consultar();
    }

    mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude!, pos.longitude!),
      zoom: 17.0,
    )));

    FirebaseAnalytics().logEvent(
        name: 'render_map_location',
        parameters: {'Latitude': pos.latitude, 'Longitude': pos.longitude});

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
          onMapCreated: _onMapCreated,
          myLocationEnabled:
              true, // Add little blue dot for device location, requires permission from user
          mapType: MapType.hybrid,
          markers: Set<Marker>.of(markers.values),
        ),
      ]),
    );
  }

  _addMarker() async {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'Localização$_markerIdCounter';
    final MarkerId markerId = MarkerId(markerIdVal);

    var pos = await location.getLocation();

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(pos.latitude!, pos.longitude!),
      infoWindow: InfoWindow(
          title: markerIdVal, snippet: 'Localização atual do dispositivo'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        //_onMarkerDragEnd(markerId, position);
      },
    );

    FirebaseAnalytics().logEvent(
        name: 'render_maker',
        parameters: {'Latitude': pos.latitude, 'Longitude': pos.longitude});

    setStateIfMounted(() {
      markers[markerId] = marker;
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    showDialog(
        routeSettings: RouteSettings(name: "teste"),
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        });
    setStateIfMounted(() {
      mapController = controller;
    });
    await _addMarker();
    _animateToUser();
  }

  setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
