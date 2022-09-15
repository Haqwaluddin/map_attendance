import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_attendance/maps/controller/map_contoller.dart';

class MapAttendance extends StatefulWidget {
  const MapAttendance({Key? key}) : super(key: key);

  @override
  State<MapAttendance> createState() => _MapAttendanceState();
}

class _MapAttendanceState extends State<MapAttendance> {

  final _getdata = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return _getdata.isLoading.value?const Center(child: CircularProgressIndicator(),):GoogleMap(
              mapType: MapType.normal,
              markers: _getdata.markers.value,
              circles: _getdata.circle,
              initialCameraPosition: _getdata.kGooglePlex,
              onMapCreated: (controller) { //method called when map is created
                setState(() {
                  _getdata.mapController = controller;
                });
              },
            );
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _getdata.getCurrentPosition(context);
                  },
                  child: const SizedBox(
                      height: 50,
                      width: 70,
                      child: Center(child: Text("Lokasi Saat ini",
                      style: TextStyle(
                        fontSize: 13
                      ),))),
                ),
                ElevatedButton(
                    onPressed: () {
                      _getdata.attendance(context);
                    },
                    child: const SizedBox(
                        height: 50,
                        width: 70,
                        child: Center(child: Text('Absen')))),
              ],
            ),
          )
        ],
      ),
    );
  }


}
