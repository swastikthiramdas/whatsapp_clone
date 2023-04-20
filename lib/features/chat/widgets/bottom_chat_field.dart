import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import '../../../common/enums/message_enum.dart';
import '../controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;

  const BottomChatField(this.recieverUserId, {Key? key}) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowAndHideButtons = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission not allowed');
    }

    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeybord() => focusNode.requestFocus();

  void hideKeybord() => focusNode.unfocus();

  void toggleEmojiKeybordContainer() {
    if (isShowEmojiContainer) {
      showKeybord();
      hideEmojiContainer();
    } else {
      hideKeybord();
      showEmojiContainer();
    }
  }

  void sendTextMessage() async {
    if (isShowAndHideButtons) {
      if (_messageController.text.trim().isNotEmpty) {
        ref.read(chatControllerProvider).sendTextMessage(
              context,
              _messageController.text.trim(),
              widget.recieverUserId,
            );
      }
      setState(() {
        _messageController.text = "";
      });
    } else {
      var temDir = await getTemporaryDirectory();
      var path = '${temDir!.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path) , MessageEnum.audio);
      } else {
        _soundRecorder!.startRecorder(toFile: path);
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.recieverUserId, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromgallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromgallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

/*
  void selectGIF() async {
    GiphyGif? gif = await pickGIF(context);
    if (gif != null) {
      ref
          .read(chatControllerProvider)
          .sendGIFMessage(context, gif.url, widget.recieverUserId);
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width.toDouble() / size.width.toDouble() / 10),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: () {
                    setState(() {
                      if (isShowEmojiContainer) {
                        isShowEmojiContainer = false;
                      }
                    });
                  },
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (val) {
                    setState(() {
                      if (val.isNotEmpty) {
                        isShowAndHideButtons = true;
                      } else {
                        isShowAndHideButtons = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: mobileChatBoxColor,
                    prefixIcon: SizedBox(
                      width: isShowAndHideButtons ? 50 : 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeybordContainer,
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: isShowAndHideButtons ? 50 : 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isShowAndHideButtons
                              ? const SizedBox(width: 1)
                              : IconButton(
                                  padding: EdgeInsets.symmetric(horizontal: 1),
                                  onPressed: selectImage,
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  ),
                                ),
                          IconButton(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            onPressed: selectVideo,
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
              SizedBox(width: size.width / 10 * 0.010),
              Padding(
                padding: EdgeInsets.only(left: size.width * 0.04),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFF128C7E),
                  child: GestureDetector(
                    child: Icon(
                      isShowAndHideButtons
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                      color: Colors.white,
                    ),
                    onTap: sendTextMessage,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: size.height / 60),
        isShowEmojiContainer
            ? SizedBox(
                height: 300,
                child: EmojiPicker(
                  onEmojiSelected: ((cat, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;

                      if (!isShowAndHideButtons) {
                        isShowAndHideButtons = true;
                      }
                    });
                  }),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
