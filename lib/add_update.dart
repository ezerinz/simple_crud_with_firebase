import 'package:flutter/material.dart';
import 'package:simple_crud/model.dart';
import 'package:simple_crud/services.dart';

class AddUpdateScreen extends StatefulWidget {
  const AddUpdateScreen({super.key, this.update = false, this.mahasiswa});
  final bool update;
  final Mahasiswa? mahasiswa;

  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  TextEditingController nama = TextEditingController();
  TextEditingController nim = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.update) {
      nama.text = widget.mahasiswa!.nama;
      nim.text = widget.mahasiswa!.nim;
    }
  }

  updateData() async {
    if (_formKey.currentState!.validate()) {
      Mahasiswa data = Mahasiswa(nama: nama.text, nim: nim.text);
      await Services().update(widget.mahasiswa!.uid!, data.toJson());

      // To Do: cek apakah berhasil dengan if else,
      // berhasil > back to home,
      // gagal > show snackbar
      if (context.mounted) Navigator.pop(context);
    }
  }

  addData() async {
    if (_formKey.currentState!.validate()) {
      Mahasiswa data = Mahasiswa(nama: nama.text, nim: nim.text);
      await Services().create(data.toJson());

      // To Do: cek apakah berhasil dengan if else,
      // berhasil > back to home,
      // gagal > show snackbar
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.update ? "Update" : "Add",
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            TextFormField(
              controller: nama,
              decoration: const InputDecoration(
                hintText: "Nama",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan nama';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: nim,
              decoration: const InputDecoration(
                hintText: "NIM",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan NIM';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.update ? updateData : addData,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: widget.update ? const Text('Update') : const Text('Add'),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
