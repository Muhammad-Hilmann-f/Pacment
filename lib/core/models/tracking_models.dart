class TrackingResponse {
  final TrackingMeta meta;
  final TrackingData data;

  TrackingResponse({
    required this.meta,
    required this.data,
  });

  factory TrackingResponse.fromJson(Map<String, dynamic> json) {
    return TrackingResponse(
      meta: TrackingMeta.fromJson(json['meta']),
      data: TrackingData.fromJson(json['data']),
    );
  }
}

class TrackingMeta {
  final int code;
  final String message;
  final String type;

  TrackingMeta({
    required this.code,
    required this.message,
    required this.type,
  });

  factory TrackingMeta.fromJson(Map<String, dynamic> json) {
    return TrackingMeta(
      code: json['code'],
      message: json['message'],
      type: json['type'],
    );
  }
}

class TrackingData {
  final TrackingInfo tracking;

  TrackingData({required this.tracking});

  factory TrackingData.fromJson(Map<String, dynamic> json) {
    return TrackingData(
      tracking: TrackingInfo.fromJson(json['tracking']),
    );
  }
}

class TrackingInfo {
  final String id;
  final String trackingNumber;
  final String slug;
  final String tag;
  final String subtag;
  final String subtagMessage;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expectedDelivery;
  final String originCountryIso3;
  final String destinationCountryIso3;
  final List<Checkpoint> checkpoints;
  final String courierName;

  TrackingInfo({
    required this.id,
    required this.trackingNumber,
    required this.slug,
    required this.tag,
    required this.subtag,
    required this.subtagMessage,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.expectedDelivery,
    required this.originCountryIso3,
    required this.destinationCountryIso3,
    required this.checkpoints,
    required this.courierName,
  });

  factory TrackingInfo.fromJson(Map<String, dynamic> json) {
    return TrackingInfo(
      id: json['id'] ?? '',
      trackingNumber: json['tracking_number'] ?? '',
      slug: json['slug'] ?? '',
      tag: json['tag'] ?? '',
      subtag: json['subtag'] ?? '',
      subtagMessage: json['subtag_message'] ?? '',
      title: json['title'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      expectedDelivery: json['expected_delivery'] != null 
          ? DateTime.parse(json['expected_delivery']) 
          : null,
      originCountryIso3: json['origin_country_iso3'] ?? '',
      destinationCountryIso3: json['destination_country_iso3'] ?? '',
      checkpoints: (json['checkpoints'] as List<dynamic>?)
          ?.map((checkpoint) => Checkpoint.fromJson(checkpoint))
          .toList() ?? [],
      courierName: json['courier_name'] ?? json['slug'] ?? '',
    );
  }

  // Helper methods
  String get statusText {
    switch (tag.toLowerCase()) {
      case 'pending':
        return 'Label Created';
      case 'intransit':
        return 'In Transit';
      case 'outfordelivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'availableforpickup':
        return 'Available for Pickup';
      case 'exception':
        return 'Exception';
      case 'expired':
        return 'Expired';
      default:
        return tag;
    }
  }

  bool get isDelivered => tag.toLowerCase() == 'delivered';
  
  bool get hasException => tag.toLowerCase() == 'exception';
  
  Checkpoint? get latestCheckpoint => 
      checkpoints.isNotEmpty ? checkpoints.first : null;
}

class Checkpoint {
  final String slug;
  final String message;
  final String tag;
  final String subtag;
  final String subtagMessage;
  final DateTime checkpointTime;
  final String countryIso3;
  final String countryName;
  final String state;
  final String city;
  final String location;

  Checkpoint({
    required this.slug,
    required this.message,
    required this.tag,
    required this.subtag,
    required this.subtagMessage,
    required this.checkpointTime,
    required this.countryIso3,
    required this.countryName,
    required this.state,
    required this.city,
    required this.location,
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      slug: json['slug'] ?? '',
      message: json['message'] ?? '',
      tag: json['tag'] ?? '',
      subtag: json['subtag'] ?? '',
      subtagMessage: json['subtag_message'] ?? '',
      checkpointTime: DateTime.parse(json['checkpoint_time']),
      countryIso3: json['country_iso3'] ?? '',
      countryName: json['country_name'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      location: json['location'] ?? '',
    );
  }

  String get fullLocation {
    final parts = [city, state, countryName].where((s) => s.isNotEmpty);
    return parts.join(', ');
  }
}

class Courier {
  final String slug;
  final String name;
  final String phone;
  final String otherName;
  final String webUrl;

  Courier({
    required this.slug,
    required this.name,
    required this.phone,
    required this.otherName,
    required this.webUrl,
  });

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      otherName: json['other_name'] ?? '',
      webUrl: json['web_url'] ?? '',
    );
  }
}

class TrackingException implements Exception {
  final String message;
  
  TrackingException(this.message);
  
  @override
  String toString() => 'TrackingException: $message';
}