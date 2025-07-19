class PresensiRiwayatModel {
  final String tanggal;
  final String jam;
  final String status;

  PresensiRiwayatModel({
    required this.tanggal,
    required this.jam,
    required this.status,
  });

  factory PresensiRiwayatModel.fromJson(Map<String, dynamic> json) {
    return PresensiRiwayatModel(
      tanggal: json['tanggal'],
      jam: json['Jam'],
      status: json['status'],
    );
  }
}
