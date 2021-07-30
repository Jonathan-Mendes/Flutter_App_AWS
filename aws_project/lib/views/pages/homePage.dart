import 'package:aws_project/controllers/productController.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:aws_project/views/pages/createProductPage.dart';
import 'package:aws_project/views/pages/editProductPage.dart';
import 'package:aws_project/utils/formatUtil.dart';
import 'package:aws_project/services/checkConnectionService.dart';
import 'package:aws_project/views/components/dialogComponent.dart';

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
  bool _connectionStatus = false;
  FormatUtil formatUtil = new FormatUtil();
  ProductController productController = new ProductController();
  CheckConnectionService checkConnectionService = new CheckConnectionService();
  DialogComponent dialogComponent = new DialogComponent();

  // Init States
  @override
  void initState() {
    super.initState();
    _initMethodAsync();
  }

  // Check Connection
  void _initMethodAsync() async {
    final _status = await checkConnectionService.checkConnection();

    setState(() {
      _connectionStatus = _status;
    });
  }

  // Navigators
  void _create() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProductPage()));
  }

  void _edit(Map<String, dynamic> data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProductPage(product: data)));
  }

  // View
  @override
  Widget build(BuildContext context) {
    return _homeConstruct();
  }

  Widget _homeConstruct() {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Lista de Produtos'),
            automaticallyImplyLeading: false,
          ),
          body: Container(color: Colors.white, child: _listProductsConstruct()),
          floatingActionButton: ExpandableFab(
            distance: 112.0,
            children: [
              ActionButton(
                icon: const Icon(
                  Icons.info_outlined,
                  color: Colors.white,
                ),
              ),
              ActionButton(
                onPressed: () => {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget))
                },
                icon: const Icon(
                  Icons.sync_sharp,
                  color: Colors.white,
                ),
              ),
              ActionButton(
                onPressed: () => _create(),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _listProductsConstruct() {
    return FutureBuilder<List>(
      future: productController.getAllProducts(),
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
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: ListTile(
                          leading: Icon(Icons.wallpaper_rounded,
                              size: 45, color: Colors.red),
                          title: Text(snapshot.data![index]['nome']),
                          subtitle: Text(snapshot.data![index]['descricao'] +
                              '\n' +
                              formatUtil
                                  .formatMoney(snapshot.data![index]['preco'])),
                          trailing: PopupMenuButton<ListAction>(
                            onSelected: (ListAction result) async {
                              switch (result) {
                                case ListAction.edit:
                                  _edit(snapshot.data![index]);
                                  break;
                                case ListAction.delete:
                                  dialogComponent.showDeleteDialog(
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
                                    Icon(Icons.edit, color: Colors.blue),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text('Editar',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    )
                                  ]),
                                ),
                                PopupMenuItem<ListAction>(
                                  value: ListAction.delete,
                                  child: Row(children: <Widget>[
                                    Icon(Icons.delete, color: Colors.red),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text('Excluir',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    )
                                  ]),
                                )
                              ];
                            },
                          ),
                        ));
                  }));
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

// Expandable Fab Button
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
            child: const Icon(Icons.inventory_2_outlined),
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
