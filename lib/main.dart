import 'package:flutter/material.dart';
import 'package:clippy_flutter/triangle.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  Color _sendIconButtonColor;

  Widget _buildTextComposer(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      constraints: BoxConstraints(
        maxHeight: 100
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              //color: Theme.of(context).highlightColor,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(5)
              ),
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _textController,
                onChanged: _handleChanged,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                    hintText: 'Send Message'
                ),
              ),
            )
          ),
          Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send),
              color: _sendIconButtonColor == null ? Theme.of(context).disabledColor : _sendIconButtonColor,
              onPressed: () => _handleSubmitted(_textController.text)
            ),
          )
        ],
      )
    );
  }

  void _handleChanged(String text) {
    setState(() {
      _sendIconButtonColor = text.isEmpty ? Theme.of(context).disabledColor : Theme.of(context).accentColor;
    });
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    _textController.clear();
    this._handleChanged(_textController.text);
    var message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  void _handleListViewOnTap() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: GestureDetector(
              onTap: () => _handleListViewOnTap(),
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
          ),
          Divider(height: 1.0),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor
            ),
            child: _buildTextComposer(context),
          )
        ],
      )
    );
  }

  @override
  void dispose() {
    for (var message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}


class ChatMessage extends StatelessWidget {
  ChatMessage({ this.text, this.animationController });
  final String text;
  final String _name = 'Hiro';
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width * .6;

    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                maxRadius: 24,
                child: Text(_name[0]),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name, style: Theme.of(context).textTheme.caption),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 13),
                        child: Triangle.isosceles(
                          edge: Edge.LEFT,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth,
                        ),
                        child: GestureDetector(
                          // onTapDown: ,
                          // onTapUp: ,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Text(text, style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}