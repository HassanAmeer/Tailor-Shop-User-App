import 'package:ThreeStarWorld/helpers/nullables.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:waveform_recorder/waveform_recorder.dart';
import '../../constants/appColors.dart';
import '../../constants/appImages.dart';
import '../../provider/auth.dart';
import '../../widgets/dotloader.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _messageController = TextEditingController();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users_chats");
  final ScrollController _chatScrollController = ScrollController();
  var fileLink = "";
  XFile? pickedFile;

  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  Future<void> _sendMessage(p) async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a message")));
      return;
    }

    final message = _messageController.text.trim();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _dbRef.push().set({
      "msg": message,
      "timestamp": timestamp,
      "from": "user",
      "file": "",
      "voice": "",
      "uid": p.userProfile.uid,
      "profileImage": p.userProfile.profileImage,
    });
    _messageController.clear();
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          _chatScrollController.position.maxScrollExtent);
    }
    setState(() {});
  }

  syncFirstF() async {
    // var user = await Provider.of<AuthVm>(context).userProfile;
    // if (user.uid.isEmpty) {
    //   var user = await Provider.of<AuthVm>(context).getUserData();
    //   currentUserId = user!.uid;
    // } else {
    //   currentUserId = user.uid;
    // }
    // setState(() {});
  }

  Future<String?> _uploadImage() async {
    if (pickedFile == null) return null;
    try {
      final cloudinary = Cloudinary.signedConfig(
        apiKey: "191182111899947",
        apiSecret: "cqOT8xRwcZoaaw9z0bm9bIsQDYE",
        cloudName: "dal3uq1y5",
      );

      final response = await cloudinary.upload(
          file: pickedFile!.path,
          fileBytes: await pickedFile!.readAsBytes(),
          resourceType: CloudinaryResourceType.image,
          folder: 'chats',
          fileName: '${DateTime.now().millisecondsSinceEpoch}',
          progressCallback: (count, total) {
            print('Uploading image from file with progress: $count/$total');
          });

      if (response.isSuccessful) {
        // print('👉 img resp: ${response}');
        // print('👉Get your image from with ${response.secureUrl}');
      }

      return response.secureUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _pickImage(p, {bool isFromGallery = true}) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: isFromGallery ? ImageSource.gallery : ImageSource.camera);
    setState(() {
      pickedFile = pickedImage;
    });
    if (pickedFile == null) return;
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Send Image'),
            actions: [
              CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancle')),
              CupertinoButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    var link = await _uploadImage();
                    final timestamp = DateTime.now().millisecondsSinceEpoch;

                    await _dbRef.push().set({
                      "msg": "",
                      "timestamp": timestamp,
                      "from": "user",
                      "file": "$link",
                      "voice": "",
                      "uid": p.userProfile.uid,
                      "profileImage": p.userProfile.profileImage,
                    });
                    if (_chatScrollController.hasClients) {
                      _chatScrollController.animateTo(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          _chatScrollController.position.maxScrollExtent);
                    }
                  },
                  child: Text('yes')),
            ],
            insetAnimationCurve: Curves.slowMiddle,
            insetAnimationDuration: const Duration(seconds: 2),
          );
        });
  }

  WaveformRecorderController waveController = WaveformRecorderController();

  @override
  void dispose() {
    waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, p, c) {
      return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
              title: const Text('Live Chats',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              actions: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(AppImages.chatIcon,
                        color: AppColors.primaryColor.shade100))
              ],
              backgroundColor: AppColors.primaryColor,
              elevation: 0),
          body: Column(children: [
            Expanded(
                child: StreamBuilder(
                    stream: _dbRef
                        .orderByChild("timestamp")
                        // .equalTo(p.userProfile.uid, key: "uid")
                        .onValue,
                    // stream: _dbRef.orderByChild("timestamp").onValue,
                    builder: (context, snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return Center(
                      //       child: DotLoader(
                      //           color: AppColors.primaryColor.shade100));
                      // }

                      if (snapshot.hasData && snapshot.data != null) {
                        final data = (snapshot.data!).snapshot.value
                            as Map<dynamic, dynamic>?;

                        if (data == null) {
                          return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Image.asset(AppImages.chatIcon,
                                        color: AppColors.primaryColor.shade100,
                                        opacity:
                                            const AlwaysStoppedAnimation(0.3))),
                                const Center(
                                    child: Text("No messages yet",
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)))
                              ])
                              .animate(
                                  delay: 500.ms,
                                  onPlay: (controller) => controller.repeat())
                              .shimmer(
                                  duration: const Duration(milliseconds: 1500),
                                  delay: const Duration(milliseconds: 1000))
                              .shimmer(
                                  color: AppColors.primaryColor.shade100
                                      .withOpacity(0.3),
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.easeInOut);
                        }

                        final messages = data.entries.toList()
                          ..sort((a, b) => a.value["timestamp"]
                              .compareTo(b.value["timestamp"]));

                        return Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                                controller: _chatScrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final chat = messages[index].value;
                                  final isAdmin =
                                      chat["uid"] == p.userProfile.uid &&
                                          chat["from"] == "admin";

                                  return isAdmin
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                              InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  onTap: () {},
                                                  child: CircleAvatar(
                                                      backgroundColor: Colors
                                                          .orange.shade100
                                                          .withOpacity(0.6),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  50),
                                                          child: CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              width: 37,
                                                              height: 37,
                                                              imageUrl:
                                                                  "https://www.creativefabrica.com/wp-content/uploads/2021/06/02/Admin-Roles-Icon-Graphics-12796525-1.jpg",
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons.person_4,
                                                                      color: Colors
                                                                          .orange),
                                                              placeholder: (context, url) =>
                                                                  const CircularProgressIndicator.adaptive(strokeWidth: 2))))),
                                              chat['voice']
                                                          .toString()
                                                          .toNullString() !=
                                                      ""
                                                  ? SizedBox(
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.8,
                                                      child: VoiceWidget(
                                                          color: Colors
                                                              .orange.shade100,
                                                          isSender: false,
                                                          url: chat['voice']
                                                              .toString()
                                                              .toNullString()))
                                                  : chat['file']
                                                              .toString()
                                                              .toNullString() !=
                                                          ""
                                                      ? SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          height: 120,
                                                          child:
                                                              BubbleNormalImage(
                                                            id: '12',
                                                            image:
                                                                CachedNetworkImage(
                                                              fit: BoxFit
                                                                  .contain,
                                                              imageUrl: chat[
                                                                      'file']
                                                                  .toString()
                                                                  .toNullString(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(
                                                                      Icons
                                                                          .image,
                                                                      color: Colors
                                                                          .purpleAccent),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const DotLoader(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            color: Colors.orange
                                                                .shade100,
                                                            isSender: false,
                                                            tail: true,
                                                            delivered: true,
                                                          ),
                                                        )
                                                      : BubbleSpecialOne(
                                                          text: chat['msg']
                                                              .toString(),
                                                          isSender: false,
                                                          color: Colors
                                                              .orange.shade100,
                                                          textStyle: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontStyle: FontStyle
                                                                  .italic,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                            ])
                                      : (chat["uid"] == p.userProfile.uid &&
                                              chat["from"] == "user")
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                  chat['voice'].toString().toNullString() !=
                                                          ""
                                                      ? SizedBox(
                                                          width: MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: VoiceWidget(
                                                              color: AppColors
                                                                  .primaryColor,
                                                              isSender: true,
                                                              url: chat['voice']
                                                                  .toString()
                                                                  .toNullString()))
                                                      : chat['file']
                                                                  .toString()
                                                                  .toNullString() !=
                                                              ""
                                                          ? SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.45,
                                                              height: 120,
                                                              child:
                                                                  BubbleNormalImage(
                                                                id: '12',
                                                                image:
                                                                    CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  imageUrl: chat[
                                                                          'file']
                                                                      .toString()
                                                                      .toNullString(),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .image,
                                                                          color:
                                                                              Colors.purpleAccent),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      const DotLoader(
                                                                          color:
                                                                              Colors.grey),
                                                                ),
                                                                color: AppColors
                                                                    .primaryColor
                                                                    .shade100,
                                                                isSender: true,
                                                                tail: true,
                                                                delivered: true,
                                                              ),
                                                            )
                                                          : BubbleSpecialOne(
                                                              text: chat['msg']
                                                                  .toString(),
                                                              isSender: true,
                                                              color: AppColors
                                                                  .primaryColor
                                                                  .shade100
                                                                  .withOpacity(
                                                                      0.6),
                                                              textStyle: TextStyle(
                                                                  color: AppColors
                                                                      .primaryColor
                                                                      .shade700,
                                                                  fontStyle: FontStyle.italic,
                                                                  fontWeight: FontWeight.bold)),
                                                  InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      onTap: () {},
                                                      child: CircleAvatar(
                                                          backgroundColor: AppColors
                                                              .primaryColor
                                                              .shade100
                                                              .withOpacity(0.6),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      50),
                                                              child: CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 37,
                                                                  height: 37,
                                                                  imageUrl: context
                                                                          .read<
                                                                              AuthVm>()
                                                                          .userProfile
                                                                          .profileImage
                                                                          .isEmpty
                                                                      ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSq3t9dFOmI3lGU6fDJmGn3cagEbJwaqiOi9YKw1lyGxGZ_T1QLEx7-hlt5DpVd-vDEBb8&usqp=CAU"
                                                                      : context
                                                                          .read<AuthVm>()
                                                                          .userProfile
                                                                          .profileImage,
                                                                  errorWidget: (context, url, error) => const Icon(Icons.person, color: AppColors.primaryColor),
                                                                  placeholder: (context, url) => const CircularProgressIndicator.adaptive(strokeWidth: 2)))))
                                                ])
                                          : SizedBox.shrink();
                                }));
                      }

                      return const Center(child: Text(""));
                    })),
            Padding(
                padding: const EdgeInsets.all(14),
                child: Expanded(
                    child: ListenableBuilder(
                        listenable: waveController,
                        builder: (context, _) => TextField(
                            controller: _messageController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              prefixIcon: waveController.isRecording
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width: 20),
                                        InkWell(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            onTap: () {
                                              waveController.stopRecording();
                                              isCanceled = true;
                                            },
                                            child: const Icon(
                                              Icons.cancel,
                                              color: AppColors.primaryColor,
                                            )),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: WaveformRecorder(
                                              height: 48,
                                              controller: waveController,
                                              onRecordingStopped: () {
                                                onRecordingStopped(p);
                                              }),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width: 10),
                                        InkWell(
                                            onTap: () {
                                              _pickImage(p,
                                                  isFromGallery: true);
                                            },
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Icon(Icons.attach_file,
                                                color: AppColors.primaryColor)),
                                        SizedBox(width: 8),
                                        InkWell(
                                            onTap: () {
                                              _pickImage(p,
                                                  isFromGallery: false);
                                            },
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: AppColors.primaryColor)),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                              hintText: "Type a message...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              suffixIcon: _messageController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.send,
                                          color: AppColors.primaryColor),
                                      onPressed: () {
                                        _sendMessage(p);
                                      })
                                  : IconButton(
                                      icon: Icon(
                                        waveController.isRecording
                                            ? Icons.stop
                                            : Icons.mic,
                                        color: waveController.isRecording
                                            ? Colors.grey
                                            : AppColors.primaryColor,
                                      ),
                                      onPressed: toggleRecording),
                            )))))
          ]));
    });
  }

  //////////////////

  bool isCanceled = false;
  void toggleRecording() {
    if (waveController.isRecording) {
      waveController.stopRecording();
    } else {
      waveController.startRecording();
    }
    isCanceled = false;
  }

  Future<void> onRecordingStopped(p) async {
    try {
      final file = waveController.file;
      if (file == null || isCanceled) return;

      debugPrint("👉 file: $file");

      final cloudinary = Cloudinary.signedConfig(
        apiKey: "191182111899947",
        apiSecret: "cqOT8xRwcZoaaw9z0bm9bIsQDYE",
        cloudName: "dal3uq1y5",
      );

      final response = await cloudinary.upload(
          file: file.path,
          fileBytes: await file.readAsBytes(),
          resourceType: CloudinaryResourceType.video,
          folder: 'chats',
          fileName: '${DateTime.now().millisecondsSinceEpoch}',
          progressCallback: (count, total) {
            print('Uploading voices from file with progress: $count/$total');
          });

      if (response.isSuccessful) {
        print('👉 audio resp: ${response}');
        print('👉Get your audio from with ${response.secureUrl}');
      } else {
        print('Error uploading audio: ${response.error}');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await _dbRef.push().set({
        "msg": "",
        "timestamp": timestamp,
        "from": "user",
        "file": "",
        "voice": response.secureUrl,
        "uid": p.userProfile.uid,
        "profileImage": p.userProfile.profileImage,
      });
    } catch (e, st) {
      debugPrint("💥 when voice uploading $e $st");
    }
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          _chatScrollController.position.maxScrollExtent);
    }
  }
}

class VoiceWidget extends StatefulWidget {
  final bool isSender;
  final Color color;
  final String url;
  const VoiceWidget({
    super.key,
    required this.url,
    this.isSender = false,
    this.color = const Color.fromARGB(255, 255, 224, 178),
  });

  @override
  State<VoiceWidget> createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
  final player = AudioPlayer();

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  bool isPlaying = false;
  bool isPaused = false;
  bool isLoading = false;
  String audioUrl = "";
  double position = 0.0; // Current position
  double duration = 0.0; // Total duration

  void play(String url) {
    if (audioUrl != url) {
      audioUrl = url;
      stop(); // Ensure previous audio is stopped before playing a new one
    }
    if (!isPlaying) {
      updatePositionAndDuration();
      player.play(UrlSource(audioUrl));
      setState(() {
        isPlaying = true;
        isPaused = false;
      });
    } else {
      pause();
    }
  }

  void pause() {
    if (isPlaying) {
      player.pause();
      setState(() {
        isPlaying = false;
        isPaused = true;
      });
    }
  }

  void stop() {
    player.stop();
    setState(() {
      isPlaying = false;
      isPaused = false;
    });
  }

  void updatePositionAndDuration() {
    player.onPositionChanged.listen((position) {
      setState(() {
        this.position = position.inMilliseconds.toDouble(); // Update position
      });
    });

    player.onDurationChanged.listen((duration) {
      setState(() {
        this.duration = duration.inMilliseconds.toDouble(); // Update duration
      });
    });
    //  player.onLog.listen((isBuffering) {
    //     isLoading = isBuffering.isNotEmpty;
    //     setState(() {});
    //  });
  }

  onSeekChanged(v) {
    player.seek(Duration(milliseconds: v.toInt())); // Seek to the new position
  }

  @override
  Widget build(BuildContext context) {
    return BubbleNormalAudio(
      color: widget.color,

      duration: duration / 1000, // Pass the total duration
      position: position / 1000, // Pass the current position
      isPlaying: isPlaying,
      isLoading: isLoading,
      isPause: isPaused,
      onSeekChanged: (v) {
        debugPrint("seek: $v");
        onSeekChanged(v);
      },
      onPlayPauseButtonClick: () {
        debugPrint("onPlayPauseButtonClick: ");
        play(widget.url);
      },
      sent: true,
      isSender: widget.isSender,
    );
  }
}
