import 'dart:math';
import 'dart:typed_data';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:flutter_printer/config_page.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'config_page.dart';
import 'cart_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String getTimeString(DateTime time) =>
      '${DateFormat('kk:mm:ss a').format(time)}';

  String getDateString(DateTime date) =>
      '${DateFormat('yyyy-MM-dd').format(date)}';

  print() async {
    final Ticket ticket = Ticket(PaperSize.mm58);
    final list = Provider.of<CartModel>(context, listen: false).items;
    final ByteData data = await rootBundle.load('assets/flutter-512.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    ticket.image(image);

    DateTime date = DateTime.now();
    ticket.text('${DateFormat('dd-MM-yyyy kk:mm:ss a').format(date)}',
        styles: PosStyles(fontType: PosFontType.fontB));
    ticket.row([
      PosColumn(
        text: 'Item     ',
        width: 9,
        styles: PosStyles(align: PosTextAlign.right, underline: true),
      ),
      PosColumn(
        text: 'Price',
        width: 3,
        styles: PosStyles(align: PosTextAlign.right, underline: true),
      ),
    ]);
    list.forEach((element) {
      ticket.row([
        PosColumn(
          text: '${element.name}      ',
          width: 9,
          styles: PosStyles(align: PosTextAlign.right),
        ),
        PosColumn(
          text: '${element.price}',
          width: 3,
          styles: PosStyles(align: PosTextAlign.right),
        ),
      ]);
    });
    ticket.text(
        'Total    ${Provider.of<CartModel>(context, listen: false).totalPrice}',
        styles: PosStyles(
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosTextAlign.right));
    ticket.text('--Thank you for shoping with us--',
        styles: PosStyles(
            height: PosTextSize.size7,
            width: PosTextSize.size7,
            align: PosTextAlign.center));
    ticket.feed(1);

    Navigator.push(
        context, MaterialPageRoute(builder: (c) => ConfigPage(ticket: ticket)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth print'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.print),
          onPressed: print,
        )
      ]),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          return ListView.separated(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cart.items[index].name),
                trailing: Text('${cart.items[index].price}'),
              );
            },
            separatorBuilder: (context, index) {
              if (index == cart.items.length - 1) {
                return Divider();
              } else {
                return Container();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            double price = Random.secure().nextInt(500).toDouble();
            Provider.of<CartModel>(context, listen: false).add(Cart(
                name:
                    'Item ${Provider.of<CartModel>(context, listen: false).items.length}',
                price: price));
          },
          child: Icon(Icons.add)),
    );
  }
}
