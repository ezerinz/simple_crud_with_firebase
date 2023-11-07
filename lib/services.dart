import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_crud/model.dart';

class Services {
  final _dbRef = FirebaseFirestore.instance.collection('mahasiswa');

  // return future boolean, true = success, false = gagal
  Future<bool> create(Map<String, dynamic> data) async {
    try {
      await _dbRef.add(data);
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Stream<List<Mahasiswa>> read() {
    final data = _dbRef.snapshots();
    var result = data.map((event) {
      List<Mahasiswa> listResult = event.docs.map((e) {
        Mahasiswa mahasiswa = Mahasiswa.fromJson(e.data());
        mahasiswa.uid = e.id;
        return mahasiswa;
      }).toList();

      return listResult;
    });

    return result;
  }

  Future<bool> update(String uid, Map<String, dynamic> data) async {
    try {
      await _dbRef.doc(uid).update(data);
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  Future<bool> delete(String uid) async {
    try {
      await _dbRef.doc(uid).delete();
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
