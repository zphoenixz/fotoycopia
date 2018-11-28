import 'package:documents_picker/documents_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
class StorageClass {
  String path='';
  String download='';
  StorageClass();
  Future<Null> uploadFile() async {
    String name=path.substring(path.lastIndexOf('/'));
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('UCB'+name);
    File a = new File(path);
    final StorageUploadTask task = firebaseStorageRef.putFile(a);
    this.download = await firebaseStorageRef.getDownloadURL();
  }
  Future<Null> getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    path=image.path;
  }
  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    path=image.path;
  }
  Future getDocument() async {
    var docPaths = await DocumentsPicker.pickDocuments;
    path=docPaths.single;
  }
}
