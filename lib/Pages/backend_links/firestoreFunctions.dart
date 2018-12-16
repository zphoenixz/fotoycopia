import 'package:cloud_firestore/cloud_firestore.dart';

Future<dynamic> checkNumber(String phoneNumber) async {
  var user = Firestore.instance.collection('personas').document(phoneNumber);
  var val = await user.get().then((dataUser) {
    if (!dataUser.exists)
      return false;
    else
      return true;
  });

  return val;
}

Future<dynamic> createUser(
    Map<String, dynamic> newUserData, String token) async {
  print(newUserData);
  print(newUserData['phone']);
  var user =
      Firestore.instance.collection('personas').document(newUserData['phone']);
  user.setData({
    "nombre": newUserData['name'],
    "direccion": newUserData['direction'],
    "panico": false,
    "token": token
  });
}

Future<dynamic> panicAttack(String phone) async {
  print(phone);
  var user = Firestore.instance.collection('personas').document(phone);
  user.get().then((data) {
    if (data.data['panico'])
      user.updateData({
        "panico": false,
      });
    else
      user.updateData({
        "panico": true,
      });
  });
}
