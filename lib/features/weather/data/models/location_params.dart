class LocationParams {
  final double lat;
  final double lon;

  LocationParams({required this.lat, required this.lon});

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lon': lon};
  }
}
