class Users{
  final int? id;
  String? name;
  String? surname;
  String? imageUrl;
  String? phone;
  String? email;
  String? password;
  int? gender;
  final String? token;
  int? process;
  int? earnMark;
  String? bikeName;
  String? bikenumber;
  String? modelnumber;

  Users({
    this.name,
    this.id,
    this.surname,
    this.imageUrl,
    this.phone = "",
    this.email = "",
    this.password = "",
    this.token,
    this.gender = 0,
    this.process = 0,
    this.earnMark = 0,
    this.bikeName,
    this.bikenumber,
    this.modelnumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "surname": surname,
      "imageUrl": imageUrl,
      "phone": phone,
      "email": email,
      "token": token,
      "gender": gender,
      "password": password,
      "vehicle_number": bikenumber,
      "bikeName": bikeName,
      "modelnumber": modelnumber,
    };
  }

  static Users fromJson(dynamic json) {
    return Users(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      imageUrl: json['imageUrl'],
      phone: json['phone'],
      email: json['email'],
      token: json['token'],
      password: json['password'],
      gender: json['gender'],
      bikenumber: json['vehicle_number'],
      bikeName: json['bikeName'],
      modelnumber: json['modelnumber'],
    );
  }
}
