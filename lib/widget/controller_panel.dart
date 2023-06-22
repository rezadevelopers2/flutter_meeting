
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ControllerPanel extends StatelessWidget {

  final bool? videoEnabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;
  const ControllerPanel({Key? key,
    this.videoEnabled,
    this.audioEnabled,
    this.isConnectionFailed,
    this.onVideoToggle,
    this.onAudioToggle,
    this.onReconnect,
    this.onMeetingEnd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade900,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildController(),
      ),
    );

  }

  List<Widget> buildController(){
    if(!isConnectionFailed!){
      return [
        IconButton(onPressed: onVideoToggle,
            icon: Icon(videoEnabled! ? Icons.videocam :Icons.videocam_off),
        color: Colors.white,
        iconSize: 32,),


        IconButton(onPressed: onAudioToggle,
            icon: Icon(audioEnabled! ? Icons.mic :Icons.mic_off),
        color: Colors.white,
        iconSize: 32,),


        const SizedBox(width: 25,),

        Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red
          ),

          child: IconButton(onPressed: onMeetingEnd,
              icon: Icon(Icons.call_end),
          color: Colors.white,
          iconSize: 32,),
        )
      ];
    }else {

      return [

        FormHelper.submitButton(
            "Reconnect",
            onReconnect!,
            borderColor: Colors.red,
        width: 200,
          height: 40
        )
      ];
    }
  }
}
