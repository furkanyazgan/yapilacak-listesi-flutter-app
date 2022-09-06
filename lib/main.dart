import 'package:flutter/material.dart';
import 'yenigorev.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yapilacak_listesi/card.dart';

void main() {
  runApp(StajOdevi());
}

class StajOdevi extends StatelessWidget {
  //ana gövde
  //çerçeve de değiştrime yapılmayacak stless
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Yapılacak Listesi",
      initialRoute: "home",
      routes: {
        "home": (context) => HomePage(),
        "yenigorev": (context) => YeniGorev()
      },
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
    ;
  }
}

_HomePageState homeState;

class HomePage extends StatefulWidget {
  // tüm tasarım MediaQuery ile responsive edildi.
  Future<SharedPreferences> mySharedPrefences;
  static List<String> gorevler = ["bos"];

  HomePage() {
    mySharedPrefences = SharedPreferences.getInstance();
  }

  //değişimler olacak stfull
  @override
  _HomePageState createState() {
    homeState = _HomePageState();
    return homeState;
  }
}

class _HomePageState extends State<HomePage> {
  List<CustomCard> cards = [];

  void eleman_ekle(String st_value) async {
    // elemanlar hata ayıklanarak asenkron biçimde eklenir
    List<String>? temp = [];

    try {
      print("dogru");
      widget.mySharedPrefences.then((value) {
        temp = value.getStringList("token");
        if (temp != null) {
          print("üst");
          temp?.add(st_value);
          widget.mySharedPrefences
              .then((value) => value.setStringList("token", temp!));
          HomePage.gorevler = temp!;
          setState(() {});
        } else {
          print("alt");
          temp = [];
          temp?.add(st_value);
          widget.mySharedPrefences
              .then((value) => value.setStringList("token", temp!));
          HomePage.gorevler = temp!;
          setState(() {});
        }
      });
    } catch (s) {
      print("hata");
      print(s);
    }
  }

  void guncelle() {
    //değişimlerde global veriye veri tabanından veri güncellemesi yapar
    widget.mySharedPrefences.then((value) {
      HomePage.gorevler = value.getStringList("token")!;
      if (HomePage.gorevler == null) {
        HomePage.gorevler = [];
      }

      setState(() {});
    });
  }

  void delete() {
    //kullanım dışı..... veri tabanını siler. debug için yazıldı.
    widget.mySharedPrefences.then((value) => value.remove("token"));
  }

  @override
  void initState() {
    //tasarım gelemeden önce veri tabanından verileri burada alırız
    guncelle();

    super.initState();
  }

  void card_olustur() {
    //string listesinde ki verileri card listesine render için dönüştürür
    widget.mySharedPrefences.then((value) {
      HomePage.gorevler = value.getStringList("token")!;
      cards = HomePage.gorevler.map((value) {
        bool tmp = false;
        if (value[0] == "0") {
          tmp = true;
        }
        return CustomCard(value, HomePage.gorevler.indexOf(value) + 1,
            HomePage.gorevler.indexOf(value), tmp);
      }).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    card_olustur();

    return Scaffold(
      //uygulama tasarım iskeleti
      appBar: AppBar(
        title: Text("Furkan Yazgan Staj Ödevi"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.deepPurple])),
        ),
      ),
      floatingActionButton: Container(
        //sağ alt eleman ekleme sayfasına gitme butonu
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.065),
        child: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          child: Icon(Icons.add),
          onPressed: () {
            widget.mySharedPrefences
                .then((value) => value.setString("y", "naber"));
            Navigator.pushReplacementNamed(context, "yenigorev");
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                //elemanları listeleme widgeti
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return cards[index];
                  // Text(HomePage.gorevler[index]);
                }),
          ),
          Container(
            // Hızlı Görev başlangıcı MediaQuery yapıldı **********************
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.lightBlueAccent])),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.07,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: MediaQuery.of(context).size.height * 0.013),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(9),
                        bottomRight: Radius.circular(9)),
                    border: Border.all(color: Colors.white)),
                child: Center(
                  child: Text("Görev Eklemek İçin  +  Butonuna Basınız "),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
