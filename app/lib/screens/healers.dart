import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((string) {
        _mapStyle = string;
      });
    });

    _getUserLocation(context);
  }

  void _getHealerList() async {
    LatLng loc =
        Provider.of<MapProvider>(context, listen: false).currentLatLng!;
    setState(() async {
      _nearestHealers = await serviceLocator<HealerService>().getNearby(loc);
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
    return Scaffold(
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
              .updateCurrentLocation(
                  LatLng(position.target.latitude, position.target.longitude));
        },
      ),
    );
  }
}
