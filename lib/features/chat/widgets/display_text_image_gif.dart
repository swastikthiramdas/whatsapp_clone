import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:whatsapp_ui/features/chat/widgets/video_player.dart';

class DisplayImageTextGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayImageTextGIF(
      {Key? key, required this.message, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPLaying = false;
    final AudioPlayer audioplayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints: const BoxConstraints(minWidth: 100),
                  onPressed: () async {
                    if (isPLaying) {
                      await audioplayer.pause();
                      setState(() {
                        isPLaying = false;
                      });
                    }
                    else{
                      await audioplayer.play(UrlSource(message));
                      setState(() {
                        isPLaying = true;
                      });
                    }
                  },
                  icon:
                      Icon(isPLaying ? Icons.pause_circle : Icons.play_circle),
                );
              })
            : type == MessageEnum.video
                ? VideoPlayerItem(
                    VideoUrl: message,
                  )
                : CachedNetworkImage(imageUrl: message);
  }
}
