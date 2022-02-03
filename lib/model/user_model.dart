class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? surname;

  UserModel({this.uid, this.email, this.firstName, this.surname});
  //data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      surname: map['surname'],
    );
  }
  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'surname': surname,
    };
  }
}
