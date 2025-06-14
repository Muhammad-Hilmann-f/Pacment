class TrackingModel {
  final String awb;
  final String courier;
  final String status;
  final String date;
  final WaybillDetail detail;
  final List<WaybillHistory> history;

  TrackingModel({
    required this.awb,
    required this.courier,
    required this.status,
    required this.date,
    required this.detail,
    required this.history,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    return TrackingModel(
      awb: json['data']['summary']['awb'] ?? '',
      courier: json['data']['summary']['courier'] ?? '',
      status: json['data']['summary']['status'] ?? '',
      date: json['data']['summary']['date'] ?? '',
      detail: WaybillDetail.fromJson(json['data']['detail'] ?? {}),
      history: (json['data']['history'] as List<dynamic>?)
          ?.map((item) => WaybillHistory.fromJson(item))
          .toList() ?? [],
    );
  }
}

class WaybillDetail {
  final String origin;
  final String destination;
  final String shipper;
  final String receiver;

  WaybillDetail({
    required this.origin,
    required this.destination,
    required this.shipper,
    required this.receiver,
  });

  factory WaybillDetail.fromJson(Map<String, dynamic> json) {
    return WaybillDetail(
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      shipper: json['shipper'] ?? '',
      receiver: json['receiver'] ?? '',
    );
  }
}

class WaybillHistory {
  final String date;
  final String desc;
  final String location;

  WaybillHistory({
    required this.date,
    required this.desc,
    required this.location,
  });

  factory WaybillHistory.fromJson(Map<String, dynamic> json) {
    return WaybillHistory(
      date: json['date'] ?? '',
      desc: json['desc'] ?? '',
      location: json['location'] ?? '',
    );
  }
}