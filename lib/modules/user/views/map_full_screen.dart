import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:location/location.dart';

class FullScreenMap extends StatefulWidget {
  final Function(Position)? onLocationSelected;

  const FullScreenMap({Key? key, this.onLocationSelected}) : super(key: key);

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMap? mapboxMap;
  Location location = Location();
  bool _isMapLoading = true;
  Position? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() async {
    try {
      // Location permission check karein
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) return;
      }

      PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) return;
      }

      // Current location get karein
      LocationData currentLocation = await location.getLocation();

      setState(() {
        _selectedPosition = Position(
          currentLocation.longitude!,
          currentLocation.latitude!,
        );
        _isMapLoading = false;
      });
    } catch (e) {
      print("Location error: $e");
      setState(() {
        _isMapLoading = false;
      });
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    setState(() {
      this.mapboxMap = mapboxMap;
      _isMapLoading = false;
    });

    // Agar current location available hai to map ko wahan move karein
    if (_selectedPosition != null) {
      _moveToCurrentLocation();
    }
  }

  void _moveToCurrentLocation() {
    if (_selectedPosition != null && mapboxMap != null) {
      mapboxMap?.setCamera(
        CameraOptions(
          center: Point(coordinates: _selectedPosition!),
          zoom: 14.0,
        ),
      );
    }
  }

  void _saveLocation() {
    if (_selectedPosition != null && widget.onLocationSelected != null) {
      widget.onLocationSelected!(_selectedPosition!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
        backgroundColor: Color(0xFF456B2E),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _moveToCurrentLocation,
            tooltip: "Current Location",
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveLocation,
            tooltip: "Save Location",
          ),
        ],
      ),
      body: Stack(
        children: [
          MapWidget(
            onMapCreated: _onMapCreated,
            styleUri: MapboxStyles.MAPBOX_STREETS,
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: _selectedPosition ?? Position(77.2090, 28.6139),
              ),
              zoom: _selectedPosition != null ? 14.0 : 10.0,
            ),
          ),
          if (_isMapLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0XFF476C2F)),
                    SizedBox(height: 16),
                    Text(
                      "Loading Map and Location...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0XFF476C2F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveToCurrentLocation,
        backgroundColor: Color(0xFF456B2E),
        child: Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
