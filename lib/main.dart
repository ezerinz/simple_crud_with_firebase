import 'package:simple_crud/add_update.dart';
import 'package:simple_crud/model.dart';
import 'package:simple_crud/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        home: const HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read Data"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const AddUpdateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: StreamBuilder(
          stream: Services().read(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Text(
                    'Tidak ada data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  );
                } else {
                  List<Mahasiswa> listMhs = snapshot.data!;
                  return ListView.separated(
                    padding: const EdgeInsets.all(15.0),
                    itemBuilder: (context, index) {
                      return CustomCard(mahasiswa: listMhs[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10.0,
                    ),
                    itemCount: listMhs.length,
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.mahasiswa});
  final Mahasiswa mahasiswa;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.redAccent],
            ),
            borderRadius: BorderRadius.circular(8.0)),
        width: double.infinity,
        child: Row(
          children: [
            const SizedBox(
              width: 30.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mahasiswa.nama,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    mahasiswa.nim,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    await Services().delete(mahasiswa.uid!);
                  },
                  icon: const Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return AddUpdateScreen(
                          update: true,
                          mahasiswa: mahasiswa,
                        );
                      }),
                    );
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
            )
          ],
        ));
  }
}
