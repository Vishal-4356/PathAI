import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:latlong2/latlong.dart';


class ApiService {
  // Backend URL (Android Emulator)
  static const String baseUrl = "http://10.111.117.34:8000";

  /// Fetch heatmap data from backend
  static Future<List<WeightedLatLng>> fetchHeatmap() async {
    final response = await http.get(
      Uri.parse("$baseUrl/heatmap"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load heatmap data");
    }

    final decoded = jsonDecode(response.body);
    final List points = decoded["heatmap_points"];

    return points.map<WeightedLatLng>((p) {
      return WeightedLatLng(
        LatLng(
          p["lat"].toDouble(),
          p["lon"].toDouble(),
        ),
        p["intensity"].toDouble(),
      );
    }).toList();
  }
}
