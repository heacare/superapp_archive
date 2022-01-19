import 'dart:ui' as ui;
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hea/providers/map.dart';
import 'package:hea/utils/permission.dart';
import 'package:hea/utils/reusable_methods.dart';
import 'package:hea/services/location_service.dart';
import 'package:hea/models/healer.dart';
import 'package:hea/widgets/avatar_icon.dart';
import 'package:hea/widgets/healer_card.dart';
import 'package:hea/screens/booking.dart';

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
  Set<Marker> _markers = {};
  late BitmapDescriptor _markerIcon;
  Healer? selectedHealer;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((string) {
        _mapStyle = string;
      });
    });

    _getUserLocation(context);
    _bitmapDescriptorFromSvgAsset(context, "assets/svg/marker.svg", 100)
        .then((value) => _markerIcon = value);
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
      _markers.clear();
      _nearestHealers.forEach((healer) {
        // Add in the markers
        _markers.add(Marker(
            markerId: MarkerId(healer.id.toString()),
            icon: _markerIcon,
            zIndex: 10.0,
            position: healer.location!,
            onTap: () {
              setState(() {
                selectedHealer = healer;
              });
            }));
      });
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
          markers: _markers,
          myLocationEnabled: true,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          initialCameraPosition: _getLocationTarget(),
          onTap: (_) {
            setState(() {
              selectedHealer = null;
            });
          },
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            _mapController.setMapStyle(_mapStyle);
          },
          onCameraMove: (CameraPosition position) {
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
              decoration: const BoxDecoration(
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
                    AvatarIcon(),
                  ])))),
      Positioned.fill(
          child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 40.0, left: 20.0, right: 20.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        MapIconButton(
                          icon:
                              const FaIcon(FontAwesomeIcons.search, size: 24.0),
                          onPressed: () {},
                        ),
                        SizedBox(height: 8.0),
                        MapIconButton(
                          icon: const FaIcon(FontAwesomeIcons.locationArrow,
                              size: 24.0),
                          onPressed: () => _getUserLocation(context),
                        ),
                        SizedBox(height: 8.0),
                        (selectedHealer == null)
                            ? Container()
                            : HealerCard(
                                healer: selectedHealer!,
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute<DateTime>(
                                          builder: (BuildContext context) {
                                    return BookingScreen(
                                        name: 'Sleep Clinic',
                                        healer: selectedHealer!);
                                  }));
                                })
                      ])))),
    ]);
  }
}

class MapIconButton extends StatelessWidget {
  FaIcon icon;
  void Function() onPressed;

  MapIconButton({Key? key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), //color of shadow
            blurRadius: 5, // blur radius
            offset: const Offset(0, 2), // changes position of shadow
          )
        ],
      ),
      child: IconButton(
        icon: icon,
        color: Color(0xFF414141),
        onPressed: onPressed,
      ),
    );
  }
}
