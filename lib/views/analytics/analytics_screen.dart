import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/models/tracking_models.dart';

class AnalyticsScreen extends StatefulWidget {
  final List<TrackingModel> trackingHistory;

  const AnalyticsScreen({
    super.key,
    required this.trackingHistory,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? analysisReport;
  List<CourierAnalysis> rankedCouriers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateAnalysis();
  }

  void _generateAnalysis() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 1500), () {
      analysisReport = CourierComparison.generateReport(widget.trackingHistory);
      rankedCouriers = CourierComparison.rankCouriers(widget.trackingHistory);

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard); // 🔥 Fix Back ke Dashboard
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Analisis Courier',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.indigo[600],
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.analytics), text: 'Overview'),
              Tab(icon: Icon(Icons.leaderboard), text: 'Ranking'),
              Tab(icon: Icon(Icons.insights), text: 'Insights'),
            ],
          ),
        ),
        body: isLoading
            ? _buildLoadingState()
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildRankingTab(),
                  _buildInsightsTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[600]!),
          ),
          const SizedBox(height: 20),
          Text(
            'Menganalisis performa courier...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '🔍 Menghitung kecepatan delivery\n📊 Membandingkan performa\n🏆 Menentukan ranking',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    if (analysisReport == null || analysisReport!.isEmpty) {
      return const Center(child: Text("⚠️ Data analisis belum tersedia!"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 16),
          _buildQuickStatsGrid(),
          const SizedBox(height: 16),
          _buildPerformanceChart(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.indigo[600]!, Colors.indigo[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Ringkasan Analisis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              analysisReport!['summary'] ?? "Tidak ada data",
              style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.4),
            ),
            const SizedBox(height: 12),
            Text(
              'Rata-rata pengiriman: ${analysisReport!['average_days'] ?? 0} hari',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsGrid() {
    CourierAnalysis? fastest = analysisReport!['fastest_courier'];
    CourierAnalysis? slowest = analysisReport!['slowest_courier'];

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Tercepat',
            value: fastest?.courierName ?? 'N/A',
            subtitle: fastest != null ? '${fastest.totalDays} hari' : '',
            icon: Icons.rocket_launch,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Terlambat',
            value: slowest?.courierName ?? 'N/A',
            subtitle: slowest != null ? '${slowest.totalDays} hari' : '',
            icon: Icons.schedule,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}