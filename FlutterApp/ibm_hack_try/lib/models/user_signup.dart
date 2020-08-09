class NewUser {
  final String user;
  final String name;
  final String psswd;
  
 
  NewUser({this.user, this.name, this.psswd,});
 
  factory NewUser.fromJson(Map<String, dynamic> json) {
    return NewUser(
      user: json['user'],
      name: json['name'],
      psswd: json['psswd'],
    );
  }
 
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["user"] = user;
    map["name"] = name;
    map["psswd"] = psswd;
 
    return map;
  }
}