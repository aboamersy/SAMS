import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ite_project/constants.dart';

class FirebaseNetworkings {
  String rootCollection;
  FirebaseNetworkings({this.rootCollection}) {
    rootCollection != null
        ? rootCollection = '$kSessionsRootCollection/$rootCollection'
        : rootCollection = '$kSessionsRootCollection/';
  }

  Future<QuerySnapshot> getDocs() async {
    Future<QuerySnapshot> data =
        FirebaseFirestore.instance.collection(rootCollection).get();
    return data;
  }

  void addDocument(String docName, Map collectionData) {
    final CollectionReference usersRoot =
        FirebaseFirestore.instance.collection(rootCollection);
    usersRoot
        .doc(docName)
        .set(collectionData)
        .catchError((onError) => print('Error $onError'));
  }

  CollectionReference referenceCollection() {
    return FirebaseFirestore.instance.collection(rootCollection);
  }

  String getRoot() {
    return rootCollection;
  }
}
