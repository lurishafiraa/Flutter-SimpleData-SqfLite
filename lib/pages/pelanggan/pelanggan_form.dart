import 'package:flutter/material.dart';
import 'package:flutter_sqlite/helper/db_helper.dart';
import 'package:intl/intl.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({Key? key}) : super(key: key);

  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  late TextEditingController txtID, txtNama, txtTgllahir;
  String gender = '';

  Future<int> lastID() async {
    try {
      final _db = await DBHelper.db();
      final query = 'SELECT MAX(id) as id FROM pelanggan';
      final ls = (await _db?.rawQuery(query))!;

      if (ls.length > 0) {
        return int.tryParse('${ls[0]['id']}') ?? 0;
      }
    } catch (e) {
      print('error lastid $e');
    }
    return 0;
  }

  Future<bool> simpanData() async {
    try {
      final _db = await DBHelper.db();
      var data = {
        'id': txtID.value.text,
        'nama': txtNama.value.text,
        'gender': gender,
        'tgl_lahir': txtTgllahir.value.text,
      };
      final id = await _db?.insert('pelanggan', data);
      return id! > 0;
    } catch (e) {}
    return false;
  }

  _CustomerFormState() {
    txtID = TextEditingController();
    txtNama = TextEditingController();
    txtTgllahir = TextEditingController();

    lastID().then((value) {
      txtID.text = '${value + 1}';
    });
  }

  Widget txtInputID() => TextFormField(
      controller: txtID,
      readOnly: true,
      decoration: InputDecoration(labelText: 'ID Pelanggan'));

  Widget txtInputNama() => TextFormField(
      controller: txtNama,
      decoration: InputDecoration(labelText: 'Nama Pelanggan'));

  Widget dropDownGender() => DropdownButtonFormField(
        decoration: InputDecoration(labelText: 'Jenis Kelamin'),
        isExpanded: true,
        value: gender,
        onChanged: (g) {
          gender = '$g';
        },
        items: [
          DropdownMenuItem(child: Text('PIlih Gender'), value: ""),
          DropdownMenuItem(child: Text('Laki-Laki'), value: "L"),
          DropdownMenuItem(child: Text('Perempuan'), value: "P"),
        ],
      );

  DateTime initTgllahir() {
    try {
      return DateFormat('yyyy-MM-dd').parse(txtTgllahir.value.text);
    } catch (e) {}
    return DateTime.now();
  }

  Widget txtInputTglLahir() => TextFormField(
        readOnly: true,
        decoration: InputDecoration(labelText: 'Tanggal Lahir'),
        controller: txtTgllahir,
        onTap: () async {
          final tgl = await showDatePicker(
              context: context,
              initialDate: initTgllahir(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());

          if (tgl != null)
            txtTgllahir.text = DateFormat('yyyy-MM-dd').format(tgl);
        },
      );

  Widget tombolSimpan() => TextButton(
        onPressed: () {
          simpanData().then((h) {
            var pesan = h == true ? 'Sukses simpan' : 'Gagal simpan';

            showDialog(
                context: context,
                builder: (bc) => AlertDialog(
                      title: Text('Simpan pelanggan'),
                      content: Text('$pesan'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Oke'))
                      ],
                    )).then((value) {
              Navigator.pop(context, h);
            });
          });
        },
        child: Text('Simpan', style: TextStyle(color: Colors.white)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Form Pelanggan'),
          actions: [tombolSimpan()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(children: [
            txtInputID(),
            txtInputNama(),
            dropDownGender(),
            txtInputTglLahir()
          ]),
        ));
  }
}
