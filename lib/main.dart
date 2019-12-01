import 'package:flutter/material.dart';


void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: new ThemeData(primarySwatch: Colors.pink ),
  home: new BackdropPage(),
));
class BackdropPage extends StatefulWidget {
  @override
  _BackdropPageState createState() => new _BackdropPageState();
}

class _BackdropPageState extends State<BackdropPage> with SingleTickerProviderStateMixin {

  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller= new AnimationController(vsync: this,duration: new Duration(milliseconds: 100),value: 1.0);
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  bool get isPanelVisible{
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: new Text("BackDrop"),elevation: 0.0,
        leading: new IconButton(

            icon: AnimatedIcon(
                icon: AnimatedIcons.home_menu, progress: controller.view),
                onPressed: (){
                  controller.fling(velocity: isPanelVisible? -1.0: 1.0);
                }),

      ),
      body: TwoPanels(
        controller: controller,
      ),
    );
  }
}

class TwoPanels extends StatefulWidget {

  final AnimationController controller;
  TwoPanels({this.controller});

  @override
  _TwoPanelsState createState() => _TwoPanelsState();
}

class _TwoPanelsState extends State<TwoPanels> {
  static const header_height = 32.0;

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints){
    final height= constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return new RelativeRectTween(
        begin: new RelativeRect.fromLTRB(0.0, backPanelHeight, 0.0, frontPanelHeight),
         end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0,  0.0)
    ).animate(new CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints){

    final ThemeData theme = Theme.of(context);

    return new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            color: theme.primaryColor,
            child: new Center(child:new Text("BACK Panel",style: TextStyle(fontSize: 25.0,color: Colors.white),)
            ),
          ),
          new PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: new Material(
              elevation: 12.0,
              borderRadius: new BorderRadius.only(topLeft: new Radius.circular(16.0),topRight: new Radius.circular(16.0)),
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: header_height,
                    child: new Center(child: new Text("SHOP HERE",style: Theme.of(context).textTheme.button,),),
                  ),
                  new Expanded(
                      child: new Center(child: new Text("FRONT PANEL",style: TextStyle(fontSize: 25.0,color: Colors.black)),))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: bothPanels,

    );
  }
}
