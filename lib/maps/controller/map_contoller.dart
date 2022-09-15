import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController{

  Position? currentPosition;
  LatLng posisiawal = const LatLng(-6.520001960145166, 106.85272784213245);
  late double distance;
  var markers = Set<Marker>().obs;
  Set<Circle> circle = Set();
  GoogleMapController? mapController;
  late final CameraPosition kGooglePlex;
  var isLoading = true.obs;


  @override
  void onInit() {
    super.onInit();
    mapCreate();
  }

  //membuat titik awal untuk perbandingan jarak
  void mapCreate(){
    kGooglePlex = CameraPosition(
      target: posisiawal,
      zoom: 20,
    );
    super.onInit();
    markers.add(Marker(
        markerId: const MarkerId('1'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position:posisiawal,
        infoWindow: const InfoWindow(title: '')));

    circle.add(Circle(
      circleId: const CircleId(''),
      center:posisiawal,
      radius: 50,
      strokeWidth: 5,
      strokeColor: Colors.green,
      fillColor: Colors.green.withOpacity(0.5),
    ));
    isLoading(false);
  }

  //button untuk absen
  void attendance(BuildContext context){
    distance = Geolocator.distanceBetween(posisiawal.latitude,posisiawal.longitude,
        currentPosition!.latitude, currentPosition!.longitude);
    if(distance <= 50){
      showAlertDialogDone(context);
    }else{
      showAlertDialogRejected(context);
    }
  }

  //button cek lokasi saat ini
  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
      markers.add(Marker(
          markerId: const MarkerId('2'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(
              currentPosition!.latitude, currentPosition!.longitude),
          infoWindow: const InfoWindow(title: '')));
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(
              currentPosition!.latitude, currentPosition!.longitude),
              zoom: 17)
      ));
    }).catchError((e) {
      debugPrint(e);
    });
  }

  //meminta persetujuan aktifkan lokasi(location permission)
  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  //alert atau popup saat gagal absen
  showAlertDialogRejected(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alertGagal = AlertDialog(
      title: const Text('Attendance Rejected'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.highlight_remove_outlined,
              color: Colors.red,
              size: 100),
          SizedBox(height: 10),
          Text('Karena jarak anda belum terpenuhi'),
        ],
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go Back'))
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertGagal;
      },
    );
  }

  //alert atau popup saat berhasil absen
  showAlertDialogDone(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alertGagal = AlertDialog(
      title: const Text('Attendance Accepted'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.done_outline_outlined,
              color: Colors.green,
              size: 100),
          SizedBox(height: 10),
          Text('Absen anda berhasil'),
        ],
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go Back'))
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertGagal;
      },
    );
  }

}