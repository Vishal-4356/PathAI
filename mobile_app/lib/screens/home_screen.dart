import 'package:flutter/material.dart';
import 'capture_screen.dart';
import 'heatmap_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Soft off-white
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Dynamic Header with Stats Overlay
          _buildSliverAppBar(context),

          // 2. The Main Dashboard Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Main Features", null),
                  const SizedBox(height: 16),
                  
                  _buildHeroActionCard(
                    context,
                    title: "Analyze Accessibility",
                    subtitle: "Real-time AI barrier detection",
                    icon: Icons.auto_awesome,
                    colors: [const Color(0xFF6366F1), const Color(0xFF4338CA)],
                    isNew: true,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CaptureScreen())),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildSecondaryCard(
                    context,
                    title: "Explore Global Heatmap",
                    icon: Icons.map_outlined,
                    color: const Color(0xFF50C878),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HeatmapScreen())),
                  ),

                  const SizedBox(height: 32),
                  
                  _buildSectionHeader("Recent Activity", "View All"),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // 3. Simulated Activity Feed
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildActivityItem(index),
                childCount: 3,
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: const Color(0xFF1A237E),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Gradient & Pattern
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A8A), Color(0xFF312E81)],
                ),
              ),
            ),
            Positioned(
              right: -50,
              top: -20,
              child: Icon(Icons.blur_on, size: 250, color: Colors.white.withOpacity(0.05)),
            ),
            // Header Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none, color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Welcome back,",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const Text(
                      "Accessibility Scout",
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        if (actionText != null)
          TextButton(onPressed: () {}, child: Text(actionText, style: const TextStyle(color: Color(0xFF6366F1)))),
      ],
    );
  }

  Widget _buildHeroActionCard(BuildContext context, {
    required String title, required String subtitle, required IconData icon, 
    required List<Color> colors, required bool isNew, required VoidCallback onTap
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(colors: colors),
        boxShadow: [
          BoxShadow(color: colors.first.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                          child: const Text("AI POWERED", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                    ],
                  ),
                ),
                Icon(icon, color: Colors.white, size: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final titles = ["Main Entrance Scan", "Side Street Ramp", "Subway Elevator"];
    final times = ["2 hours ago", "Yesterday", "3 days ago"];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.history, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(times[index], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          const Chip(label: Text("Verified", style: TextStyle(fontSize: 10)), backgroundColor: Color(0xFFF1F5F9)),
        ],
      ),
    );
  }
}