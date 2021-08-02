import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget _createHeader(context) {
  var size = MediaQuery.of(context).size;

  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.white, Colors.white, Colors.pink],
          stops: [0.0, 0.2, 0.3, 1.0],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        ),
      ),
      child: Stack(children: <Widget>[
        SizedBox(
            height: size.height / 7.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo-bycoders.jpg",
                  fit: BoxFit.contain,
                ),
              ],
            )),
        Positioned(
            bottom: 12.0,
            left: 75.0,
            child: Text("DESAFIO MOBILE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500))),
      ]));
}

Widget _createDrawerItem(
    {IconData? icon, String? text, GestureTapCallback? onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text ?? ''),
        )
      ],
    ),
    onTap: onTap,
  );
}

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final Future<PackageInfo> info = PackageInfo.fromPlatform();

  Future<String> getVersionNumber() async {
    final PackageInfo info = await PackageInfo.fromPlatform();

    return info.version;
  }

  Future<Null> recuperaDados() async {
    //final prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    recuperaDados();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getVersionNumber(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _createHeader(context),
                  _createDrawerItem(
                      //icon: Icons.speaker_phone,
                      icon: Icons.app_registration,
                      text: 'Registros',
                      onTap: () =>
                          {Navigator.pushNamed(context, '/TelaColetor')}),
                  Divider(),
                  _createDrawerItem(
                      icon: Icons.exit_to_app,
                      text: 'Deslogar',
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/TelaLogin', (Route<dynamic> route) => false);
                        });
                      }),
                  _createDrawerItem(
                      icon: Icons.restore,
                      text: 'Reiniciar',
                      onTap: () => {
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/TelaLogin',
                                  (Route<dynamic> route) => false);
                            })
                          }),
                  ListTile(
                    title: Text("v${snapshot.data}"),
                    onTap: () {},
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
