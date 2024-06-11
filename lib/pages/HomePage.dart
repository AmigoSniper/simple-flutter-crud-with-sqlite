import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crud_flutter/services/dbHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nimControler = TextEditingController();
  TextEditingController nameControler = TextEditingController();
  TextEditingController tanggalLahirControler = TextEditingController();
  TextEditingController emailControler = TextEditingController();
  TextEditingController JurusanControler = TextEditingController();
  ScrollController _firstController = ScrollController();
  final ImagePicker picker = ImagePicker();
  late String imagePath;

  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void clear() {
    nimControler.clear();
    nameControler.clear();
    tanggalLahirControler.clear();
    emailControler.clear();
    JurusanControler.clear();
    // imagePath = '';
  }

  void getData() async {
    var result = await DbHelper.instance.queryAll();
    setState(() {
      data = result;
    });
    print(data);
  }

  void addData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Mahasiswa'),
        content: SingleChildScrollView(
          controller: _firstController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Semantics(
                    label: 'image_picker_example_from_gallery',
                    child: FormBuilder(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FormBuilderImagePicker(
                            name: 'profil',
                            decoration:
                                const InputDecoration(labelText: 'Pick Photos'),
                            maxImages: 1,
                            onChanged: (value) async {
                              final directory =
                                  await getApplicationDocumentsDirectory();
                              XFile image = value?.first;
                              String newName = "${DateTime.now().microsecond}";
                              final newPath =
                                  Path.join(directory.path, newName);
                              final File newImage =
                                  await File(image.path).copy(newPath);
                              setState(() {
                                imagePath = newImage.path;
                              });
                              print("letak imagePath ====== ${imagePath}");
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'NIM'),
                  controller: nimControler,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Nama'),
                  controller: nameControler,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(labelText: 'TanggalLahir'),
                  controller: tanggalLahirControler,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Jurusan'),
                  controller: JurusanControler,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: emailControler,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> row = {
                'NIM': int.parse(nimControler.text),
                'name': nameControler.text,
                'TanggalLahir': tanggalLahirControler.text,
                'Jurusan': JurusanControler.text,
                'email': emailControler.text,
                'image': imagePath,
              };
              print('Masuk');
              print('letak foto ${imagePath}');
              print(data.length);
              await DbHelper.instance.insert(row);
              print('Masuk 2');
              print(data.length);
              clear();
              Navigator.pop(context);
              getData();
            },
            child: Text('Add'),
          )
        ],
      ),
    );
  }

  void edit(String id) {
    TextEditingController nimEdit = TextEditingController(text: id);
    nimControler = nimEdit;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Mahasiswa'),
        content: SingleChildScrollView(
          controller: _firstController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'Photo Edit',
                child: FormBuilder(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FormBuilderImagePicker(
                        name: 'profil',
                        decoration:
                            const InputDecoration(labelText: 'Pick Photos'),
                        maxImages: 1,
                        onChanged: (value) async {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          XFile image = value?.first;
                          String newName = "${DateTime.now().microsecond}";
                          final newPath = Path.join(directory.path, newName);
                          final File newImage =
                              await File(image.path).copy(newPath);
                          setState(() {
                            imagePath = newImage.path;
                          });
                          print("letak imagePath ====== ${imagePath}");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  enabled: false,
                  decoration: InputDecoration(labelText: 'NIM'),
                  controller: nimControler,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Nama'),
                  controller: nameControler,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(labelText: 'TanggalLahir'),
                  controller: tanggalLahirControler,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Jurusan'),
                  controller: JurusanControler,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: emailControler,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> row = {
                'NIM': int.parse(nimControler.text),
                'name': nameControler.text,
                'TanggalLahir': tanggalLahirControler.text,
                'Jurusan': JurusanControler.text,
                'email': emailControler.text,
                'image': imagePath,
              };
              // await DbHelper.instance.insert(row);
              await DbHelper.instance.update(row);
              clear();
              Navigator.pop(context);
              getData();
            },
            child: Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD SQlite Yowki'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addData();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            if (index < data.length) {
              print(index.bitLength);
              return Card(
                  child: ExpansionTile(
                title: Text('Name: ${data[index]['name']}'),
                children: [
                  Image.file(
                    File(data[index]['image']),
                    fit: BoxFit.contain,
                    height: 300,
                    width: 300,
                  ),
                  Text('NIM: ${data[index]['NIM']}'),
                  Text('Tanggal Lahir: ${data[index]['TanggalLahir']}'),
                  Text('Jurusan: ${data[index]['Jurusan']}'),
                  Text('Email: ${data[index]['email']}'),
                ],
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          int id = data[index]['NIM'];
                          DbHelper.instance.delete(id);
                          getData();
                        },
                        icon: Icon(Icons.delete)),
                    IconButton(
                        onPressed: () {
                          String id = data[index]['NIM'].toString();
                          edit(id);
                          getData();
                        },
                        icon: Icon(Icons.edit)),
                  ],
                ),
              ));
            } else {
              return const Text("Data kosong");
            }
          }),
    );
  }
}
