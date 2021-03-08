import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signal_final/models/app_state.dart';
import 'package:signal_final/models/contants_and_utils.dart';

class CustomListTile1 extends StatelessWidget {
  final int index; // for deleting unique tiles

  CustomListTile1({@required this.index});

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppState>(context, listen: false).brokerData[index];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, rMqttPage, arguments: index);
        },
        onLongPress: () {
          //print('LongTap >> $taskTitle');
          openDialog(
            title: data['name'],
            content: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 6,
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Edit'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, rInfoPage,
                          arguments: index);
                    },
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text('Delete'),
                    onTap: () {
                      Provider.of<AppState>(context, listen: false)
                          .deleteBrokerData(index);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            actionWidgetList: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            context: context,
          );
          // Provider.of<AppState>(context, listen: false).deleteBrokerData(index);
        },
        title: Text(data['name']),
        subtitle: Text(data['host']),
        trailing: FlatButton(
          child: Icon(Icons.edit),
          onPressed: () {
            print('Edit...');
            Navigator.pushNamed(context, rInfoPage, arguments: index);
          },
        ),
        // trailing: Container(
        //   child: Row(
        //     children: [
        //       IconButton(icon: Icon(Icons.edit), onPressed: () {}),
        //       IconButton(icon: Icon(Icons.delete), onPressed: () {}),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

class CustomListTile2 extends StatelessWidget {
  final Function onTap;
  final Function onLongTap;
  final String title;
  final String subtitle;
  final Widget trailing;

  CustomListTile2({
    this.onTap,
    this.title,
    this.subtitle,
    this.trailing,
    this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongTap,
        // onLongPress: () {
        //   //print('LongTap >> $taskTitle');
        //   Provider.of<AppState>(context, listen: false).deleteBrokerData(index);
        // },
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  final Function onLongPress;

  const ButtonContainer({
    Key key,
    this.title,
    this.subtitle,
    this.child,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColorDark.withOpacity(0.4),
              offset: Offset(0, 4), //(x,y)
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: FittedBox(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .headline6
                            .color
                            .withOpacity(0.6),
                      ),
                ),
              ),
            ),
            SizedBox(height: 4),
            Expanded(
              flex: 5,
              child: child,
            ),
            SizedBox(height: 4),
            Expanded(
              flex: 3,
              child: FittedBox(
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .color
                            .withOpacity(0.6),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
