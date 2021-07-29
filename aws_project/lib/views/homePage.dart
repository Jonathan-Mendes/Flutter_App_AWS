import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:aws_project/views/createProductPage.dart';
import 'package:aws_project/views/editProductPage.dart';
import 'package:aws_project/utils/formatUtil.dart';

enum ListAction { edit, delete }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // Variables
  FormatUtil formatUtil = new FormatUtil();
  bool _connectionStatus = false;

  @override
  void initState() {
    super.initState();
    _initMethodAsync();
  }

  void _initMethodAsync() async {
    final _status = await _checkConection();

    setState(() {
      _connectionStatus = _status;
    });
  }

  void _createProduct() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProductPage()));
  }

  void _editProduct(Map<String, dynamic> data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProductPage(product: data)));
  }

  Future<bool> _checkConection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
        return false;
      else
        return true;
    } on SocketException catch (_) {
      return true;
    }
  }

  Future _showDeleteDialog(BuildContext context, String id, String nome) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Excluir Produto'),
            content: Container(
              child: Text(
                  'Produto: ${nome} \n\n Você realmente deseja excluir este produto?'),
            ),
            actions: <Widget>[
              ElevatedButton(
                  child: Text('Sim'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onPressed: () {
                    _deleteProduct(id);
                  }),
              ElevatedButton(
                  child: Text('Não'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  })
            ],
          );
        });
  }

  Future _deleteProduct(String id) async {
    var _url = Uri.parse(
        'https://2zdjuu605f.execute-api.us-east-1.amazonaws.com/prod/product');

    Map<String, String> _headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    var _body = jsonEncode(<String, String>{
      'id': id,
    });

    var response = await http.delete(_url, headers: _headers, body: _body);

    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else
      throw Exception("Erro excluir produto no servidor");
  }

  Future<List> _listProducts() async {
    // var _url = Uri.parse(
    //     'https://2zdjuu605f.execute-api.us-east-1.amazonaws.com/prod/products');

    var _url = Uri.parse('https://2zdjuu605f');

    var response = await http.get(_url);

    if (response.statusCode == 200) {
      var objectResponse = json.decode(utf8.decode(response.bodyBytes));
      objectResponse = objectResponse["products"] as List;
      return objectResponse;
    } else
      throw Exception("Falha ao buscar produtos no servidor!");
  }

  // View
  @override
  Widget build(BuildContext context) {
    return _homeConstruct();
  }

  Widget _homeConstruct() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Lista de Produtos'),
      ),
      body: Container(color: Colors.white, child: _listProductsConstruct()),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            // onPressed: () => _showAction(context, 1),
            icon: const Icon(
              Icons.receipt_long,
              color: Colors.white,
            ),
          ),
          ActionButton(
            // onPressed: () => _createProduct(),
            icon: const Icon(
              Icons.sync_sharp,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => _createProduct(),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listProductsConstruct() {
    return FutureBuilder<List>(
      future: _listProducts(),
      builder: (context, snapshot) {
        if (_connectionStatus) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: <Widget>[
                      Icon(
                        Icons.signal_wifi_off_outlined,
                        color: Colors.red,
                        size: 70,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text('Verifique sua conexão de internet!',
                              style: TextStyle(fontSize: 17)))
                    ])),
              ]));
        }

        if (snapshot.hasError) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: <Widget>[
                      Icon(
                        Icons.warning_amber_outlined,
                        color: Colors.red,
                        size: 70,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text('Falha ao carregar lista de produtos!',
                              style: TextStyle(fontSize: 17)))
                    ])),
              ]));
        }

        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.wallpaper_rounded,
                      size: 45, color: Colors.red),
                  title: Text(snapshot.data![index]['nome']),
                  subtitle: Text(snapshot.data![index]['descricao'] +
                      '\n' +
                      formatUtil.formatMoney(snapshot.data![index]['preco'])),
                  trailing: PopupMenuButton<ListAction>(
                    onSelected: (ListAction result) async {
                      switch (result) {
                        case ListAction.edit:
                          _editProduct(snapshot.data![index]);
                          break;
                        case ListAction.delete:
                          _showDeleteDialog(
                              context,
                              snapshot.data![index]['id'],
                              snapshot.data![index]['nome']);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<ListAction>>[
                        PopupMenuItem<ListAction>(
                          value: ListAction.edit,
                          child: Row(children: <Widget>[
                            Icon(Icons.edit, color: Colors.orange),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Editar',
                                  style: TextStyle(color: Colors.black)),
                            )
                          ]),
                        ),
                        PopupMenuItem<ListAction>(
                          value: ListAction.delete,
                          child: Row(children: <Widget>[
                            Icon(Icons.delete, color: Colors.red),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Excluir',
                                  style: TextStyle(color: Colors.black)),
                            )
                          ]),
                        )
                      ];
                    },
                  ),
                );
              });
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.accentColor,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    Key? key,
    required this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
