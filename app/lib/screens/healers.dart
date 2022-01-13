import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:hea/providers/map.dart';
import 'package:hea/utils/permission.dart';
import 'package:hea/utils/reusable_methods.dart';
import 'package:hea/services/location_service.dart';
import 'package:hea/models/healer.dart';

import 'package:hea/services/healer_service.dart';
import 'package:hea/services/service_locator.dart';

class HealersScreen extends StatefulWidget {
  HealersScreen({Key? key}) : super(key: key);

  @override
  State<HealersScreen> createState() => _HealersScreenState();
}

class _HealersScreenState extends State<HealersScreen> {
  late GoogleMapController _mapController;
  String _mapStyle = "";
  GlobalKey? _keyGoogleMap = GlobalKey();
  List<Healer> _nearestHealers = [];
  late BitmapDescriptor _marker;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((string) {
        _mapStyle = string;
      });
    });

    _getUserLocation(context);
    _bitmapDescriptorFromSvgAsset(context, "assets/svg/marker.svg", 65)
        .then((value) => _marker = value);
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName, int width) async {
    var svgString = await DefaultAssetBundle.of(context).loadString(assetName);
    var svgDrawableRoot = await svg.fromSvgString(svgString, "");
    var picture = svgDrawableRoot.toPicture(
        size: Size(width.toDouble(), width.toDouble()));
    var image = await picture.toImage(width, width);
    var bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void _getHealerList() async {
    LatLng loc =
        Provider.of<MapProvider>(context, listen: false).currentLatLng!;
    List<Healer> healers = await serviceLocator<HealerService>().getNearby(loc);
    setState(() {
      _nearestHealers = healers;
    });
  }

  Future<void> _getUserLocation(BuildContext context) async {
    PermissionUtils?.requestPermission(Permission.location, context,
        isOpenSettings: true, permissionGrant: () async {
      await LocationService().fetchCurrentLocation(context, _getHealerList,
          updatePosition: updateCameraPosition);
    }, permissionDenied: () {
      // Sad
      debugPrint("Not allowed location permissions");
    });
  }

  void updateCameraPosition(CameraPosition cameraPosition) {
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  CameraPosition _getLocationTarget() {
    var initialCameraPosition;
    if (Provider.of<MapProvider>(context, listen: false).currentLatLng !=
        null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(
            Provider.of<MapProvider>(context, listen: false)
                .currentLatLng!
                .latitude,
            Provider.of<MapProvider>(context, listen: false)
                .currentLatLng!
                .longitude),
        zoom: 0,
      );
    } else {
      initialCameraPosition = CameraPosition(zoom: 0, target: LatLng(0, 0));
    }
    return initialCameraPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        body: GoogleMap(
          myLocationEnabled: true,
          mapToolbarEnabled: true,
          initialCameraPosition: _getLocationTarget(),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            _mapController.setMapStyle(_mapStyle);
          },
          onCameraMove: (CameraPosition position) {
            debugPrint(position.toString());
            Provider.of<MapProvider>(context, listen: false)
                .updateCurrentLocation(LatLng(
                    position.target.latitude, position.target.longitude));
          },
        ),
      ),
      PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xB4FFFFFF), Color(0x00FFFFFF)])),
              child: SafeArea(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                          Text("Check-ins",
                              style: Theme.of(context).textTheme.headline1),
                          Text(
                              "Feel indestructible by checking in with our experts",
                              style: Theme.of(context).textTheme.headline4),
                        ])),
                    Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
                                fit: BoxFit.cover))),
                  ])))),
    ]);
  }
}
