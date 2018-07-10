import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tesbarcode/barcode_scanner.dart';
import 'package:tesbarcode/ui/DeviceInfo.dart';

class MainPage extends StatefulWidget {
  static String tag = 'main-page';

  _MainPage createState() => new _MainPage();
  
  // This widget is the root of your application.
  }

class _MainPage extends State<MainPage>{
  String barcode = "Unknown";
  var _ipAddress = 'Unknown';
  //String ipAddress = "";

  final httpClient = Client();
  final url = 'https://httpbin.org/ip';

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    
    final logo1 = Hero(
      tag: 'gitsLogo',     

      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50.0 ,
        child: Image.asset('assets/logo-gits.png'),
      )
    );
    
    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('Welcome to Flutter',
      style: TextStyle(fontSize: 28.0 ,
      color: Colors.blue,),
      ),
    );

    /*final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit condimentum mauris id tempor. Praesent eu commodo lacus. Praesent eget mi sed libero eleifend tempor. Sed at fringilla ipsum. Duis malesuada feugiat urna vitae convallis. Aliquam eu libero arcu.',
      style: TextStyle(fontSize: 16.0,
      color: Colors.grey,),
      )
    );**/

    final scanBtn = Padding(
    padding: EdgeInsets.only(top: 40.0, bottom: 4.0,),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
           onPressed: scan, child: new Text("Scan Barcode", style: TextStyle(color: Colors.white)),
          color: Colors.lightBlueAccent,
        ),
      ),

      );
    final hasil = Padding(
      padding: EdgeInsets.symmetric(vertical:4.0),
      child: new Text("Barcode Result: " + barcode),
    );

    final deviceInfoBtn = Padding(
      padding: EdgeInsets.symmetric(vertical:4.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            Navigator.of(context).pushNamed(DeviceInfo.tag);
          },
          color: Colors.lightBlueAccent,
          child: Text('Device Info', style: TextStyle(color: Colors.white)),
        ),
      ),
    );  

    final ipAddressTv = Padding(
      padding: EdgeInsets.symmetric(vertical:4.0),
      child: new Text("Public IP : $_ipAddress" ),
    );

    final cekLokasiTv = Padding(
      padding: EdgeInsets.symmetric(vertical:4.0),
      child: new Text(_ipAddress.trim().toString() == "203.210.86.14" ? 'Anda sedang berada di GITS' : 'Anda berada di luar lingkungan GITS')
    );

    final ipRefreshBtn = Padding(
      padding: EdgeInsets.symmetric(vertical:4.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            _getIPAddressUsingFuture();
          },
          color: Colors.lightBlueAccent,
          child: Text('Refresh IP', style: TextStyle(color: Colors.white)),
        ),
      ),
    );  

    final body = Container( 
      child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, top: 100.0, right: 24.0),
          children: <Widget>[
            
            logo1, 
            SizedBox(height: 48.0),

            ipAddressTv, 
            cekLokasiTv,
            hasil, 
            scanBtn, 
            deviceInfoBtn, 
            ipRefreshBtn
          ],
        ),
      );


    return Scaffold(body: body);
  }

  

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  _getIPAddressUsingFuture() {
    Future<Response> response = httpClient.get(url);
    response.then((value) {
      setState(() {
        _ipAddress = JSON.decode(value.body)['origin'];
      });
    }).catchError((error) => print(error));
}

_getIPAddressUsingAwait() async {
    
    var response = await httpClient.read(url);
    var ip = JSON.decode(response)['origin'];
    setState(() {
      _ipAddress = ip;
    });
  }
}






  




