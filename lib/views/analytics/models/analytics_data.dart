class AnalyticsData {
  final String month;
  final double value;

  AnalyticsData({required this.month, required this.value});
}

final List<AnalyticsData> dummyData = [
  AnalyticsData(month: "Jan", value: 40),
  AnalyticsData(month: "Feb", value: 80),
  AnalyticsData(month: "Mar", value: 120),
  AnalyticsData(month: "Apr", value: 60),
  AnalyticsData(month: "May", value: 90),
];