import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart' hide Image;

class ConfigPage extends StatefulWidget {
  final Ticket ticket;
  ConfigPage({this.ticket});

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    printerManager.scanResults.listen((devices) async {
      setState(() {
        _devices = devices;
      });
    });
    _startScanDevices();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startScanDevices() {
    setState(() {
      _devices = [];
    });
    printerManager.startScan(Duration(seconds: 4));
  }

  void _stopScanDevices() {
    printerManager.stopScan();
  }

  void _testPrint(PrinterBluetooth printer) async {
    printerManager.selectPrinter(printer);

    final PosPrintResult res = await printerManager.printTicket(widget.ticket);
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(res.msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Choose Device'),
      ),
      body: ListView.builder(
          itemCount: _devices.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () => _testPrint(_devices[index]),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.print),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_devices[index].name ?? ''),
                              Text(_devices[index].address),
                              Text(
                                'Click to print a test receipt',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          }),
      floatingActionButton: StreamBuilder<bool>(
        stream: printerManager.isScanningStream,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: _stopScanDevices,
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: _startScanDevices,
            );
          }
        },
      ),
    );
  }
}
