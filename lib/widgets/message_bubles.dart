import 'package:flutter/material.dart';
import '../screens/gallary_screen.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      this.message, this.userName, this.userImage, this.isMe, this.imageShare,
      {this.key});

  final Key key;
  final String message;
  final String userName;
  final String userImage;
  final bool isMe;
  final String imageShare;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: isMe ? Colors.cyan[100] : Colors.orange[100]),
                gradient: isMe
                    ? LinearGradient(
                        colors: [Colors.cyan[400], Colors.cyan[100]],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.orange[100],
                          Colors.orange[300],
                        ],
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(22),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(22),
                ),
              ),
               width:(imageShare != null ? 260 : 160),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 8,
              ),
              child: Material(
                elevation: 5,
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(7),
                      child: Column(
                        children: <Widget>[
                          Text(
                            userName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMe
                                    ? Colors.blueGrey[900]
                                    : Colors.blueGrey[900]),
                            textAlign: TextAlign.center,
                          ),
                          Divider(
                            color: isMe ? Colors.cyan[300] : Colors.orange[300],
                            height: 2,
                          ),
                          Column(
                            children: <Widget>[
                              (message != null
                                  ? (Container(
                                      margin: EdgeInsets.all(5),
                                      child: Text(message,
                                          style: TextStyle(
                                            color: isMe
                                                ? Colors.blueGrey[900]
                                                : Colors.blueGrey[900],
                                          ),
                                          textAlign: TextAlign.center)))
                                  : SizedBox(
                                      height: 2,
                                    )),
                              (imageShare != null
                                  ? (InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => GalleryPage(
                                              imagePath: imageShare,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 200,
                                        width: 200,
                                        child: null,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              imageShare,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )))
                                  : SizedBox(
                                      height: 2,
                                    ))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
            top: 10,
            left:  isMe ? null : (imageShare != null ? 240 : 140),
            right: isMe ? (imageShare != null ? 240 : 140) : null,
            child: Material(
              elevation: 5,
              shape: CircleBorder(),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  userImage,
                ),
              ),
            )),
      ],
      overflow: Overflow.visible,
    );
  }
}
