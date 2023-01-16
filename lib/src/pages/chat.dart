import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/repository/add_chat.dart';
import 'package:food_delivery_app/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/chat_controller.dart';
import '../elements/ChatMessageListItemWidget.dart';
import '../elements/EmptyMessagesWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/chat.dart';
import '../models/conversation.dart';
import '../models/route_argument.dart';

class ChatWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ChatWidget({Key key, this.parentScaffoldKey, this.routeArgument})
      : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends StateMVC<ChatWidget> {
  final _myListKey = GlobalKey<AnimatedListState>();
  final myController = TextEditingController();

  ChatController _con;
  int listLength = 0;
  var res = 0;

  _ChatWidgetState() : super(ChatController()) {
    _con = controller;
  }
  @override
  void initState() {
    _con.conversation = widget.routeArgument.param as Conversation;

    if (_con.conversation.id != null) {
      _con.listenForChats(_con.conversation);
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget chatList() {
    return StreamBuilder(
      stream: _con.chats,
      builder: (context, snapshot) {
        listLength = snapshot.hasData ? snapshot.data.documents.length : 0;
        return snapshot.hasData
            ? ListView.builder(
                key: _myListKey,
                reverse: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: false,
                primary: true,
                itemBuilder: (context, index) {
                  print(snapshot.data.documents[index].data());
                  Chat _chat =
                      Chat.fromJSON(snapshot.data.documents[index].data());
                  _chat.user = _con.conversation.users
                      .firstWhere((_user) => _user.id == _chat.userId);
                  return ChatMessageListItem(
                    chat: _chat,
                  );
                })
            : EmptyMessagesWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () {
             Navigator.of(context).pop();
            }),
        automaticallyImplyLeading: false,
        title: Text(
          _con.conversation.name,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: chatList(),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).hintColor.withOpacity(0.10),
                    offset: Offset(0, -4),
                    blurRadius: 10)
              ],
            ),
            child: TextField(
              autocorrect: false,
              controller: myController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                hintText: S.of(context).typeToStartChat,
                hintStyle: TextStyle(
                    color: Theme.of(context).focusColor.withOpacity(0.8)),
                suffixIcon: IconButton(
                  padding: EdgeInsets.only(
                      right: setting.value.mobileLanguage.value.languageCode ==
                              'en'
                          ? 30
                          : 0,
                      left: setting.value.mobileLanguage.value.languageCode ==
                              'en'
                          ? 0
                          : 30),
                  onPressed: () {
                    _con.addMessage(
                        _con.conversation, myController.text, listLength, widget.routeArgument.id);
                     Timer(Duration(milliseconds: 10), () {
                      myController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).accentColor,
                    size: 30,
                  ),
                ),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          )
        ],
      ),
    );
  }
}
