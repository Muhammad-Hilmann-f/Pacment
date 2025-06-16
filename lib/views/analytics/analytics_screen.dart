import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../../../core/models/tracking_models.dart';
import '../../../core/controllers/tracking_controller.dart'; // Import TrackingController
import '../dashboard/dashboard_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  // Hapus baris ini: final List<TrackingModel> trackingHistory;
  const AnalyticsScreen({
    super.key,
    // Hapus juga 'required this.trackingHistory,' dari sini
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
    // Panggil _generateAnalysis() setelah widget di-render dan controller siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAnalysis();
    });
  }

  void _generateAnalysis() {
    setState(() => isLoading = true);

    // Ambil trackingHistory dari TrackingController
    final trackingController = Provider.of<TrackingController>(context, listen: false);
    final List<TrackingModel> currentTrackingHistory = trackingController.trackingHistory;

    print('🔍 ANALYTICS: Starting analysis...');
    print('📦 ANALYTICS: Total tracking history from Controller: ${currentTrackingHistory.length}');

    // Tambahkan debug log untuk setiap tracking di history
    for (int i = 0; i < currentTrackingHistory.length; i++) {
      TrackingModel t = currentTrackingHistory[i];
      print('📦 TRACKING[$i]: AWB=${t.awb}, Courier=${t.courier}, Analysis=${t.analysis != null ? "EXISTS" : "NULL"}');
      
      if (t.analysis == null) {
        print('❌ TRACKING[$i]: Analysis is null, history count=${t.history.length}');
        for (int j = 0; j < t.history.length; j++) {
          var h = t.history[j];
          print('   📅 HISTORY[$j]: Date="${h.date}", Parsed=${h.parsedDate}');
        }
      } else {
        print('✅ TRACKING[$i]: Analysis details: totalDays=${t.analysis!.totalDays}, perfLevel=${t.analysis!.performanceLevel}');
      }
    }

    // Gunakan currentTrackingHistory untuk mendapatkan validTrackings
    final validTrackings = currentTrackingHistory.where((t) => t.analysis != null && t.analysis!.totalDays > 0).toList();
    
    print('✅ ANALYTICS: Valid trackings for report: ${validTrackings.length}/${currentTrackingHistory.length}');

    if (validTrackings.isEmpty) {
      print('❌ ANALYTICS: No valid analysis data found for reporting.');
      analysisReport = {
        'summary': 'Tidak ada data untuk analisis',
        'fastest_courier': null,
        'slowest_courier': null,
        'average_days': 0,
        'recommendations': ['Tidak ada data pengiriman yang cukup untuk dianalisis.'],
      };
      rankedCouriers = [];
    } else {
      analysisReport = CourierComparison.generateReport(validTrackings);
      rankedCouriers = CourierComparison.rankCouriers(validTrackings);
    }

    print('🧪 ANALYTICS: Final Analysis Report: $analysisReport');
    print('🧪 ANALYTICS: Final Ranked Couriers count: ${rankedCouriers.length}');

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardScreen()),
        );
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
            textAlign: TextAlign.center, // Fix: This is already a valid constant
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
    if (analysisReport == null || analysisReport!['summary'] == 'Tidak ada data untuk analisis') {
      return Center(
        child: Text(
          analysisReport!['summary'],
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      );
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
          const SizedBox(height: 16),
          _buildRecentAnalysisCard(),
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Ringkasan Analisis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              analysisReport!['summary'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Rata-rata pengiriman: ${analysisReport!['average_days']} hari',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
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
            emoji: '🚀',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Terlambat',
            value: slowest?.courierName ?? 'N/A',
            subtitle: slowest != null ? '${slowest.totalDays} hari' : '',
            icon: Icons.schedule,
            color: Colors.orange,
            emoji: '🐌',
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
    required String emoji,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    if (rankedCouriers.isEmpty) return SizedBox.shrink();

    Map<CourierPerformanceLevel, int> levelCounts = {};
    for (var courier in rankedCouriers) {
      levelCounts[courier.performanceLevel] = 
          (levelCounts[courier.performanceLevel] ?? 0) + 1;
    }

    List<PieChartSectionData> sections = [];
    List<Color> colors = [Colors.green, Colors.blue, Colors.orange, Colors.red, Colors.grey];
    List<String> labels = ['Excellent', 'Good', 'Average', 'Slow', 'Very Slow'];
    
    int colorIndex = 0;
    levelCounts.forEach((level, count) {
      if (count > 0) {
        sections.add(
          PieChartSectionData(
            value: count.toDouble(),
            title: '${((count / rankedCouriers.length) * 100).toInt()}%',
            color: colors[colorIndex % colors.length],
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
        colorIndex++;
      }
    });

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribusi Performa Courier',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildChartLegend(levelCounts, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend(Map<CourierPerformanceLevel, int> levelCounts, List<Color> colors) {
    List<Widget> legendItems = [];
    int colorIndex = 0;
    
    levelCounts.forEach((level, count) {
      if (count > 0) {
        String label = _getPerformanceLevelLabel(level);
        legendItems.add(
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[colorIndex % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '$label ($count)',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
        colorIndex++;
      }
    });

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: legendItems,
    );
  }

  String _getPerformanceLevelLabel(CourierPerformanceLevel level) {
    switch (level) {
      case CourierPerformanceLevel.excellent: return 'Excellent';
      case CourierPerformanceLevel.good: return 'Good';
      case CourierPerformanceLevel.average: return 'Average';
      case CourierPerformanceLevel.slow: return 'Slow';
      case CourierPerformanceLevel.verySlow: return 'Very Slow';
      default: return 'Unknown';
    }
  }

  Widget _buildRecentAnalysisCard() {
    List<String> recommendations = List<String>.from(analysisReport!['recommendations']);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber[600]),
                SizedBox(width: 8),
                Text(
                  'Rekomendasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...recommendations.map((rec) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: Colors.indigo[600], fontSize: 16)),
                  Expanded(
                    child: Text(
                      rec,
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: rankedCouriers.length,
      itemBuilder: (context, index) {
        CourierAnalysis courier = rankedCouriers[index];
        return _buildCourierRankCard(courier, index + 1);
      },
    );
  }

  Widget _buildCourierRankCard(CourierAnalysis courier, int rank) {
    Color rankColor = rank <= 3 
        ? [Colors.amber, Colors.grey, Colors.brown][rank - 1]
        : Colors.grey;
    
    String rankEmoji = rank == 1 ? '🥇' : rank == 2 ? '🥈' : rank == 3 ? '🥉' : '🔢';

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  rankEmoji,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#$rank ${courier.courierName}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            courier.getPerformanceEmoji(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Text(
                        courier.getEstimatedDeliveryTime(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildStatItem('Hari', '${courier.totalDays}'),
                      SizedBox(width: 20),
                      _buildStatItem('Kecepatan', '${courier.averageSpeedKmPerDay.toInt()} km/hari'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    courier.recommendation,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInsightCard(
            title: 'Analisis Mendalam',
            icon: Icons.psychology,
            color: Colors.purple,
            children: [
              _buildInsightItem('Total Courier Dianalisis', '${rankedCouriers.length}'),
              _buildInsightItem('Performa Terbaik', _getBestPerformanceInsight()),
              _buildInsightItem('Trend Pengiriman', _getTrendInsight()),
            ],
          ),
          SizedBox(height: 16),
          _buildInsightCard(
            title: 'Rekomendasi Strategis',
            icon: Icons.campaign,
            color: Colors.blue,
            children: [
              Text(
                'Untuk pengiriman urgent (< 2 hari):',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(_getUrgentRecommendation()),
              SizedBox(height: 12),
              Text(
                'Untuk pengiriman ekonomis:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(_getEconomicalRecommendation()),
            ],
          ),
          SizedBox(height: 16),
          _buildInsightCard(
            title: 'Tips Optimasi',
            icon: Icons.tips_and_updates,
            color: Colors.green,
            children: [
              _buildTipItem('🎯', 'Pilih courier berdasarkan jarak dan tujuan'),
              _buildTipItem('⏰', 'Hindari pengiriman di akhir pekan untuk hasil optimal'),
              _buildTipItem('📍', 'Courier lokal biasanya lebih cepat untuk area terdekat'),
              _buildTipItem('💰', 'Bandingkan harga vs kecepatan sebelum memilih'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  String _getBestPerformanceInsight() {
    if (rankedCouriers.isEmpty) return 'Tidak ada data';
    
    Map<CourierPerformanceLevel, int> counts = {};
    for (var courier in rankedCouriers) {
      counts[courier.performanceLevel] = (counts[courier.performanceLevel] ?? 0) + 1;
    }
    
    int excellent = counts[CourierPerformanceLevel.excellent] ?? 0;
    int total = rankedCouriers.length;
    
    if (excellent > total * 0.6) {
      return 'Mayoritas courier (${((excellent/total)*100).toInt()}%) menunjukkan performa excellent';
    } else if (excellent == 0) {
      return 'Tidak ada courier yang mencapai level excellent, evaluasi diperlukan';
    } else {
      return '${((excellent/total)*100).toInt()}% courier mencapai level excellent';
    }
  }

  String _getTrendInsight() {
    if (rankedCouriers.isEmpty) return 'Tidak ada data';
    
    double avgDays = rankedCouriers.map((c) => c.totalDays).reduce((a, b) => a + b) / rankedCouriers.length;
    
    if (avgDays <= 3) {
      return 'Trend positif - rata-rata pengiriman cepat (${avgDays.toStringAsFixed(1)} hari)';
    } else if (avgDays <= 5) {
      return 'Trend stabil - rata-rata pengiriman normal (${avgDays.toStringAsFixed(1)} hari)';
    } else {
      return 'Trend negatif - rata-rata pengiriman lambat (${avgDays.toStringAsFixed(1)} hari)';
    }
  }

  String _getUrgentRecommendation() {
    List<CourierAnalysis> urgent = rankedCouriers
        .where((c) => c.performanceLevel == CourierPerformanceLevel.excellent)
        .toList();
    
    if (urgent.isEmpty) {
      return 'Tidak ada courier dengan performa excellent dalam data ini';
    }
    
    return urgent.map((c) => c.courierName).take(3).join(', ');
  }

  String _getEconomicalRecommendation() {
    List<CourierAnalysis> economical = rankedCouriers
        .where((c) => c.performanceLevel == CourierPerformanceLevel.average || 
                      c.performanceLevel == CourierPerformanceLevel.good)
        .toList();
    
    if (economical.isEmpty) {
      return 'Pilih courier dengan rating Good atau Average untuk keseimbangan harga-kecepatan';
    }
    
    return economical.map((c) => c.courierName).take(3).join(', ');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
