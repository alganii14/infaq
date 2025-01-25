// To parse this JSON data, do
//
//     final infaq = infaqFromJson(jsonString);

import 'dart:convert';

List<Infaq> infaqFromJson(String str) => List<Infaq>.from(json.decode(str).map((x) => Infaq.fromJson(x)));

String infaqToJson(List<Infaq> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Infaq {
    int id;
    String nama;
    String jenispenerimaan;
    String jumlah;
    DateTime createdAt;
    DateTime updatedAt;

    Infaq({
        required this.id,
        required this.nama,
        required this.jenispenerimaan,
        required this.jumlah,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Infaq.fromJson(Map<String, dynamic> json) => Infaq(
        id: json["id"],
        nama: json["nama"],
        jenispenerimaan: json["jenispenerimaan"],
        jumlah: json["jumlah"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "jenispenerimaan": jenispenerimaan,
        "jumlah": jumlah,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
