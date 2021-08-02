class Login {
  int? id;
  int? uid;
  String? email;
  int? localizationId;
  String? datetime;

  Login({this.id, this.uid, this.email, this.localizationId, this.datetime});

  // factory Login.fromJson(Map<String, dynamic> json) {
  //   return Login(id: null, email: null, localizationId: null, datetime: null);
  // }
}
