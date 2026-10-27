class Cafe {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Cafe({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'address': String address,
        'latitude': double latitude,
        'longitude': double longitude,
      } =>
        Cafe(
          id: id,
          name: name,
          address: address,
          latitude: latitude,
          longitude: longitude,
        ),
      _ => throw const FormatException('Failed to load cafe.'),
    };
  }
}
