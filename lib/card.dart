import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class CustomCard extends StatefulWidget {
  String gorev = "";
  int sayi;
  int index;
  bool checkbox ;

  CustomCard(this.gorev, this.sayi, this.index,this.checkbox);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  void eleman_sil(int x) {  //elaman silmek için yazıldı
    List<String>? temp;
    SharedPreferences.getInstance().then((value) {
      temp = value.getStringList("token");
      temp?.removeAt(x);
      value.setStringList("token", temp!);
      HomePage.gorevler = value.getStringList("token")!;
      homeState.setState(() {});
    });

    setState(() {});

  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        child: Container(
          color: Colors.grey[200],
          child: ListTile( // pozisyon düzenleme widgeti
            title: Text(
              widget.gorev,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
            ),

            leading: Text(widget.sayi.toString() + "."),
            // leading:

            trailing: IconButton( // elemanın sağında elemanı silme butonu
                icon: Icon(Icons.delete),
                onPressed: () {
                  eleman_sil(widget.index);
                }),
          ),
        ),
        elevation: 5,
      ),
    );
  }
}
