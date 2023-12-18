class UserModel {
  String? uid;
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? mobilenumber;

  UserModel(
      {this.uid,
      this.firstname,
      this.lastname,
      this.email,
      this.password,
      this.mobilenumber});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      password: map['password'],
      mobilenumber: map['mobilenumber'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'mobilenumber': mobilenumber
    };
  }
}
