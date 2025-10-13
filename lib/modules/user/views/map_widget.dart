import 'package:flutter/material.dart';
import 'package:green_leaf/modules/user/views/map_full_screen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapBoxMapWidget extends StatefulWidget {
  @override
  _MapBoxMapWidgetState createState() => _MapBoxMapWidgetState();
}

class _MapBoxMapWidgetState extends State<MapBoxMapWidget> {
  MapboxMap? mapboxMap;
  bool _isMapLoading = true;
  Position? _selectedLocation;

  void _onMapCreated(MapboxMap map) {
    setState(() {
      mapboxMap = map;
      _isMapLoading = false;
    });
  }

  void _openFullScreenMap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMap(
          onLocationSelected: (position) {
            setState(() {
              _selectedLocation = position;
            });
            // Small map ko bhi update karein
            if (mapboxMap != null) {
              mapboxMap!.setCamera(
                CameraOptions(center: Point(coordinates: position), zoom: 12.0),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openFullScreenMap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0XFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF456B2E).withOpacity(0.53)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              MapWidget(
                onMapCreated: _onMapCreated,
                styleUri: MapboxStyles.MAPBOX_STREETS,
                cameraOptions: CameraOptions(
                  center: Point(
                    coordinates:
                        _selectedLocation ?? Position(77.2090, 28.6139),
                  ),
                  zoom: _selectedLocation != null ? 12.0 : 10.0,
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
                        SizedBox(height: 8),
                        Text(
                          "Loading...",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0XFF476C2F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (_selectedLocation == null && !_isMapLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Text(
                      "Tap to Select Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
