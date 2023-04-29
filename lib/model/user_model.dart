class UserModel {
  String? name;
  String? email;
  int? phone;
  String? imageUrl;
  String? userId;
  String? bioText;
  String? dateOfBirth;
  String? createAt;
  String? gender;
  String? status;
  UserModel({
    this.status,
    this.gender,
    this.name,
    this.email,
    this.phone,
    this.imageUrl,
    this.userId,
    this.bioText,
    this.dateOfBirth,
    this.createAt,
  });

  Map<String, dynamic> toJson() => {
        'createAt': createAt,
        'name': name,
        'email': email,
        'phone': phone,
        'imgUrl': imageUrl,
        'userId': userId,
        'bioText': bioText,
        'dateOfBirth': dateOfBirth,
        'gender': gender
      };
  UserModel.fromJson(Map<String, dynamic> json)
      : dateOfBirth = json['dateOfBirth'],
        bioText = json['bioText'],
        createAt = json['createAt'],
        name = json['userName'],
        email = json['email'],
        imageUrl = json['imageUrl'],
        phone = json['Phone'],
        userId = json['userId'],
        status=json['status'],
        gender = json['gender'];
}
