import 'package:flutter/material.dart';
import '../models/barrier_model.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({super.key, required this.result});

  // Helper for ML Risk Badge Color
  Color mlRiskColor(int level) {
    if (level == 0) return Colors.green.shade700;
    if (level == 1) return Colors.orange.shade700;
    if (level == 2) return Colors.red.shade700;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (result.containsKey("error")) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text(result["error"], style: const TextStyle(color: Colors.red))),
      );
    }

    final String status = result["accessibility_status"];
    final int score = result["accessibility_score"];
    final int mlRisk = result["ml_risk_level"];
    final List<BarrierModel> barriers = (result["detected_barriers"] as List)
        .map((e) => BarrierModel.fromJson(e))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light grey background for depth
      appBar: AppBar(
        title: const Text("Analysis Results"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreOverview(status, score, mlRisk),
            const SizedBox(height: 24),
            const Text(
              "Detected Barriers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildBarriersList(barriers),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreOverview(String status, int score, int mlRisk) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Status", style: TextStyle(color: Colors.grey)),
                    Text(
                      status,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                _ScoreCircle(score: score),
              ],
            ),
            const Divider(height: 32),
            _buildMLBadge(mlRisk),
          ],
        ),
      ),
    );
  }

  Widget _buildMLBadge(int level) {
    String text = level == 0 ? "Low Risk" : level == 1 ? "Medium Risk" : "High Risk";
    Color color = mlRiskColor(level);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.psychology, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            "AI Prediction: $text",
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBarriersList(List<BarrierModel> barriers) {
    if (barriers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.green.shade200),
              const SizedBox(height: 12),
              const Text("No barriers detected! Your UI is accessible."),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: barriers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFEBEE),
              child: Icon(Icons.warning_amber_rounded, color: Colors.red),
            ),
            title: Text(
              barriers[index].barrier,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        );
      },
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  final int score;
  const _ScoreCircle({required this.score});

  @override
  Widget build(BuildContext context) {
    Color scoreColor = score > 80 ? Colors.green : score > 50 ? Colors.orange : Colors.red;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 70,
          width: 70,
          child: CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 8,
            backgroundColor: Colors.grey[200],
            color: scoreColor,
          ),
        ),
        Text(
          "$score",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}