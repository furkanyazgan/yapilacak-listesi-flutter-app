import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class YeniGorev extends StatefulWidget {
  Future<SharedPreferences> mySharedPrefences;

  YeniGorev() {
    mySharedPrefences = SharedPreferences.getInstance();
  }

  @override
  _YeniGorevState createState() => _YeniGorevState();
}

class _YeniGorevState extends State<YeniGorev> {
  // elemanlar hata ayıklanarak asenkron biçimde eklenir
  void eleman_ekle(String st_value) async {
    List<String> temp = [];

    try {
      print("dogru");
      widget.mySharedPrefences.then((value) {
        temp = value.getStringList("token")!;
        if (temp != null) {
          print("üst");
          temp.add(st_value);
          widget.mySharedPrefences
              .then((value) => value.setStringList("token", temp));

          setState(() {});
        } else {
          print("alt");
          temp = [];
          temp.add(st_value);
          widget.mySharedPrefences
              .then((value) => value.setStringList("token", temp));

          setState(() {});
        }
      });
    } catch (s) {
      print("hata");
      print(s);
    }
  }




  late SharedPreferences mySharedPrefences;

  String gorev = "";

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton( //sağ üst eleman ekleme butonu
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "home");
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.deepPurple])),
          ),
          actions: [
            Center(child: Text("Ekle")),
            Builder(builder: (context) {
              return IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    if (gorev != "") {
                      eleman_ekle(gorev);
                      Navigator.pushReplacementNamed(context, "home");
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Alan Boş Bırakılamaz",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
                        backgroundColor: Colors.deepPurple.shade300,
                        duration: Duration(milliseconds: 900),
                      ));
                    }
                  });
            })
          ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22.0, left: 18.0),
                child: Text(
                  "Ne Yapılacak :",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                          ),
                          child: TextFormField( // text veri giriş widgeti
                            onFieldSubmitted: (value) {
                              gorev = value;
                            },
                            onChanged: (value) {
                              gorev = value;
                            },
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                                hintText: "Buraya Görevi Girin",
                                contentPadding: EdgeInsets.only(top: 22),
                                fillColor: Colors.red),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25, right: 10, left: 10),
                      child: Icon(
                        Icons.assignment_outlined,
                        size: 28,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
