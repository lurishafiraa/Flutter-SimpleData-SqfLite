import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({Key? key}) : super(key: key);

  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  late TextEditingController txtID, txtNama, txtTgllahir;
  String gender = '';

  _CustomerFormState() {
    txtID = TextEditingController();
    txtNama = TextEditingController();
    txtTgllahir = TextEditingController();
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
        onPressed: () {},
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
