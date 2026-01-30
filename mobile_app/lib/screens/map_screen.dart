import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<WeightedLatLng> heatmapData = [];
  bool isLoading = true;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadHeatmap();
  }

  Future<void> _loadHeatmap() async {
    setState(() => isLoading = true);
    heatmapData = await ApiService.fetchHeatmap();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Seamless look
      appBar: AppBar(
        title: const Text("Accessibility Map", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            onPressed: _loadHeatmap,
            icon: isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
              : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. The Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(11.01, 77.02),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", // Cleaner map style
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              if (heatmapData.isNotEmpty)
                HeatMapLayer(
                  heatMapDataSource: InMemoryHeatMapDataSource(data: heatmapData),
                  heatMapOptions: HeatMapOptions(
                    radius: 35,
                    blurFactor: 0.7,
                    minOpacity: 0.2,
                    gradient: {
                      0.4: Colors.green,
                      0.6: Colors.orange,
                      1.0: Colors.red,
                    },
                  ),
                ),
            ],
          ),

          // 2. Legend Overlay (Floating)
          Positioned(
            bottom: 30,
            left: 20,
            child: _buildMapLegend(),
          ),

          // 3. Zoom Controls
          Positioned(
            right: 20,
            bottom: 30,
            child: _buildMapControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Difficulty Level", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          _legendItem(Colors.red, "High Barriers"),
          _legendItem(Colors.orange, "Moderate Risk"),
          _legendItem(Colors.green, "Highly Accessible"),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        _mapButton(Icons.add, () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1)),
        const SizedBox(height: 8),
        _mapButton(Icons.remove, () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1)),
        const SizedBox(height: 8),
        _mapButton(Icons.my_location, () => _mapController.move(const LatLng(11.01, 77.02), 13)),
      ],
    );
  }

  Widget _mapButton(IconData icon, VoidCallback onTap) {
    return FloatingActionButton.small(
      heroTag: null,
      onPressed: onTap,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      child: Icon(icon),
    );
  }
}