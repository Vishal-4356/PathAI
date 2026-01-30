import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  static const String baseUrl = "http://10.111.117.34:8000";

  bool loading = true;
  String? error;
  List points = [];

  @override
  void initState() {
    super.initState();
    loadHeatmap();
  }

  Color getColor(int intensity) {
    if (intensity <= 1) return const Color(0xFF4CAF50);
    if (intensity <= 3) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String getLabel(int intensity) {
    if (intensity <= 1) return "Accessible";
    if (intensity <= 3) return "Difficult";
    return "Inaccessible";
  }

  Future<void> loadHeatmap() async {
    setState(() => loading = true);
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/heatmap"))
          .timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body);

      setState(() {
        points = data["heatmap"] ?? [];
        error = null;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e is TimeoutException ? "Connection timed out" : "Server unavailable";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Accessibility Map", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: loadHeatmap, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return _buildErrorState();
    if (points.isEmpty) return _buildEmptyState();

    return RefreshIndicator(
      onRefresh: loadHeatmap,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSummaryHeader()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildLocationCard(points[index]),
                childCount: points.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    int accessible = points.where((p) => p['intensity'] <= 1).length;
    int difficult = points.where((p) => p['intensity'] > 1 && p['intensity'] <= 3).length;
    int restricted = points.where((p) => p['intensity'] > 3).length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("Accessible", accessible, Colors.green),
          _summaryItem("Difficult", difficult, Colors.orange),
          _summaryItem("Blocked", restricted, Colors.red),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text("$count", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildLocationCard(Map p) {
    final int intensity = p["intensity"];
    final Color color = getColor(intensity);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(Icons.location_on, color: color),
        ),
        title: Text(
          "Point #${points.indexOf(p) + 1}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("${p['lat'].toStringAsFixed(4)}, ${p['lon'].toStringAsFixed(4)}",
                style: TextStyle(fontFamily: 'monospace', color: Colors.grey[700])),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                getLabel(intensity),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(error!, style: const TextStyle(fontSize: 16)),
          TextButton(onPressed: loadHeatmap, child: const Text("Try Again")),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text("No accessibility data recorded yet."),
        ],
      ),
    );
  }
}