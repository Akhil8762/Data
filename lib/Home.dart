import 'package:data/Data.dart';
import 'package:data/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  var indexid; // for getting id of new updating value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TASK"),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      hintText: 'Name',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: jobController,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      hintText: 'job',
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        saveData(nameController.text, jobController.text);
                      });
                    },
                    child: Text('add'),
                    color: Colors.red,
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        updateData(nameController.text, jobController.text);
                      });
                    },
                    child: Text('update'),
                    color: Colors.red,
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Data>>(
                  future: DatabaseHelper.instance.retrieveData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index].name),
                            leading: Text(snapshot.data[index].id.toString()),
                            subtitle: Text(snapshot.data[index].job),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.blue,
                                    onPressed: () {
                                      setState(() {
                                        nameController.text =
                                            snapshot.data[index].name;
                                        jobController.text =
                                            snapshot.data[index].job;
                                        indexid = snapshot.data[index].id; // select the id from iconbutton
                                      });
                                    }),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      setState(() {
                                        deleteData(snapshot.data[index]);
                                      });
                                    }),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("Oops!");
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  saveData(String name, String job) {
    DatabaseHelper.instance.insertdata(Data(name: name, job: job));
  }

  updateData(String name, String job) {
    DatabaseHelper.instance.updatedata(Data(id: indexid, name: name, job: job));
  }

  deleteData(Data data) {
    DatabaseHelper.instance.deletedata(data.id);
  }
}
