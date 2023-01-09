import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:whatsapp_ui/features/chat/widgets/video_player.dart';

class DisplayImageTextGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayImageTextGIF({Key? key, required this.message, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text ? Text(
      message,
      style: const TextStyle(
        fontSize: 16,
      ),
    ) : type == MessageEnum.video ? VideoPlayerItem(VideoUrl: message,) : CachedNetworkImage(imageUrl: message);
  }
}
