class TechnicianModel {
  final String id;
  final String name;
  final String image;
  final String specialty;
  final double rating;
  final int jobsDone;
  final double distance;
  final bool isAvailable;

  TechnicianModel({
    required this.id,
    required this.name,
    required this.image,
    required this.specialty,
    required this.rating,
    required this.jobsDone,
    required this.distance,
    required this.isAvailable,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'specialty': specialty,
      'rating': rating,
      'jobsDone': jobsDone,
      'distance': distance,
      'isAvailable': isAvailable,
    };
  }

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      specialty: json['specialty'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      jobsDone: json['jobsDone'] ?? 0,
      distance: (json['distance'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}
