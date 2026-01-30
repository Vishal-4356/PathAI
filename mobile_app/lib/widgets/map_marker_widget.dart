import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/barrier_model.dart';

class MapMarkerWidget {
  /// Convert BarrierModel to a map marker
  static Marker buildMarker(BarrierModel barrier) {
    return Marker(
      width: 40,
      height: 40,
      point: LatLng(barrier.latitude, barrier.longitude),
      builder: (context) => Icon(
        Icons.location_on,
        color: _getColor(barrier),
        size: 36,
      ),
    );
  }

  static Color _getColor(BarrierModel barrier) {
    if (barrier.confidence >= 0.8) {
      return Colors.red; // High severity
    } else if (barrier.confidence >= 0.5) {
      return Colors.orange; // Medium
    } else {
      return Colors.green; // Low
    }
  }
}
