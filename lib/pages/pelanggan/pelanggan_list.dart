import 'package:flutter/material.dart';
import 'package:flutter_sqlite/helper/db_helper.dart';
import 'package:flutter_sqlite/pages/pelanggan/pelanggan_form.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<Map> listData = [];

  void refresh() async {
    final _db = await DBHelper.db();
    final sql = 'SELECT * FROM pelanggan';
    listData = (await _db?.rawQuery(sql))!;
    _refreshController.refreshCompleted();
    setState(() {});
  }

  Future<bool> hapusData(int id) async {
    final _db = await DBHelper.db();
    final count =
        await _db?.delete('pelanggan', where: 'id=?', whereArgs: [id]);
    return count! > 0;
  }

  Widget item(Map d) => ListTile(
        onLongPress: () {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  100, MediaQuery.of(context).size.height / 2, 100, 0),
              items: [
                PopupMenuItem(
                  child: Text('Sunting data ini'),
                  value: 'S',
                ),
                PopupMenuItem(
                  child: Text('Hapus data ini'),
                  value: 'H',
                )
              ]).then((value) {
            if (value == 'S') {
              Navigator.push(context,
                      MaterialPageRoute(builder: (c) => CustomerForm(data: d)))
                  .then((value) {
                if (value == true) refresh();
              });
            } else if (value == 'H') {
              showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        content: Text('Pelanggan ${d['nama']} ingin dihapus?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                hapusData(d['id']).then((value) {
                                  if (value == true) refresh();
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Ya, saya yakin banget')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Nggak jadi deh...')),
                        ],
                      ));
            }
          });
        },
        title: Text('${d['nama']}'),
        trailing: Text('${d['gender']}'),
        subtitle: Text('${d['tgl_lahir']}'),
      );

  Widget tambahData() => ElevatedButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (c) => CustomerForm()))
              .then((value) {
            if (value == true) {
              refresh();
            }
          });
        },
        child: Text('Tambah Pelanggan'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pelanggan'),
      ),
      floatingActionButton: tambahData(),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () => refresh(),
        child: ListView(
          children: [for (Map d in listData) item(d)],
        ),
      ),
    );
  }
}
