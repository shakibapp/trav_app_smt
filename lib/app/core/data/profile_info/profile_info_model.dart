
class ProfileInfoModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? image;
  final String? role;
  final bool? hasPaidPlan;
  final String? phoneNumber;
  final String? address;
  final DateTime? dob;
  final String? educationLevel;
  final String? employmentStatus;
  final String? parentingGoal;
  final String? supportSystem;
  final String? relation;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileInfoModel({
    this.id,
    this.fullName,
    this.email,
    this.image,
    this.role,
    this.hasPaidPlan,
    this.phoneNumber,
    this.address,
    this.dob,
    this.educationLevel,
    this.employmentStatus,
    this.parentingGoal,
    this.supportSystem,
    this.relation,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileInfoModel.fromJson(Map<String, dynamic> json) => ProfileInfoModel(
    id: json["id"],
    fullName: json["fullName"],
    email: json["email"],
    image: json["image"],
    role: json["role"],
    hasPaidPlan: json["hasPaidPlan"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    educationLevel: json["educationLevel"],
    employmentStatus: json["employmentStatus"],
    parentingGoal: json["parentingGoal"],
    supportSystem: json["supportSystem"],
    relation: json["relation"],
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "image": image,
    "role": role,
    "hasPaidPlan": hasPaidPlan,
    "phoneNumber": phoneNumber,
    "address": address,
    "dob": dob?.toIso8601String(),
    "educationLevel": educationLevel,
    "employmentStatus": employmentStatus,
    "parentingGoal": parentingGoal,
    "supportSystem": supportSystem,
    "relation": relation,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
