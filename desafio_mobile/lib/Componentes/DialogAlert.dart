import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class DialogAlert {
  late BuildContext context;
  String title = '';
  String conteudo = '';

  DialogAlert(BuildContext context, String title, String conteudo) {
    this.context = context;
    this.title = title;
    this.conteudo = conteudo;
  }

  Widget showDialog() {
    // retorna um objeto do tipo Dialog
    return Platform.isAndroid
        ? AlertDialog(
            title: new Text(title),
            // content: Positioned(
            //   left: Consts.padding,
            //   right: Consts.padding,
            //   child: CircleAvatar(
            //     backgroundColor: Colors.green,
            //     radius: Consts.avatarRadius,
            //   ),
            // ),
            content: Text(conteudo),
            actions: <Widget>[
              // define os botões na base do dialogo
              new TextButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: new Text(title),
            // content: Positioned(
            //   left: Consts.padding,
            //   right: Consts.padding,
            //   child: CircleAvatar(
            //     backgroundColor: Colors.green,
            //     radius: Consts.avatarRadius,
            //   ),
            // ),
            content: Text(conteudo),
            actions: <Widget>[
              // define os botões na base do dialogo
              new CupertinoButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
  }
}

Future<void> showDialogAlert(context, title, conteudo) async {
  // retorna um objeto do tipo Dialog
  DialogAlert modal = new DialogAlert(context, title, conteudo);

  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => modal.showDialog());
}
