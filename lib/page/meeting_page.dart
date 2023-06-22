import 'package:conferance/models/model_meeting_detail.dart';
import 'package:conferance/page/home_screen.dart';
import 'package:conferance/utils/user.utils.dart';
import 'package:conferance/widget/controller_panel.dart';
import 'package:conferance/widget/remote_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
class MeetingPage extends StatefulWidget {
  final String ?meetingId;
  final String ? name;
  final MeetingDetail ? meetingDetail;
  const MeetingPage({Key? key, this.meetingId, this.name, this.meetingDetail}) : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRender = RTCVideoRenderer();
  final Map<String,dynamic> mediaCon = {"audio":true ,"video":true};
  bool isConnectionFailed = false;

  WebRTCMeetingHelper ? meetingHelper;






  @override
  void initState() {
    super.initState();
    initRender();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();

  }
  @override
  void dispose() {
    super.dispose();
    _localRender.dispose();
    if(meetingHelper != null){
      meetingHelper!.destroy();
      meetingHelper = null;
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: buildRoom(),
      bottomNavigationBar: ControllerPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle:onVideoToggle ,
        videoEnabled: isVideoEnable(),
        audioEnabled: isAudioEnable(),
        isConnectionFailed: isConnectionFailed,
        onMeetingEnd: onMeetingEnded,
        onReconnect: handleReconnect,
      ),
    );
  }


  void startMeeting()async {
    final String userId = await loadUserId();
    meetingHelper = WebRTCMeetingHelper(
      url: "http://192.168.1.150:4000",
      meetingId: widget.meetingDetail!.id,
      userId: userId,
      name: widget.name,
      autoConnect: true,maxRetryCount: 10
    );

    MediaStream _localStream = await navigator.mediaDevices.getUserMedia(mediaCon);

    _localRender.srcObject = _localStream;
    meetingHelper!.stream = _localStream;

      meetingHelper!.on("open", context,
            (ev, context) {
              print("////////////////////////////open ${ev.eventName}");
              print("////////////////////////////open ${ev.eventData}");
              setState(() {
                isConnectionFailed = false;
              });
            });


      meetingHelper!.on("connection", context,
              (ev, context) {
                print("////////////////////////////connection ${ev.eventName}");
                print("////////////////////////////connection ${ev.eventData}");
            setState(() {
              isConnectionFailed = false;
            });
          });

   meetingHelper!.on("connection-request", context,
              (ev, context) {
                print("////////////////////////////connection-request ${ev.eventName}");
                print("////////////////////////////connection-request ${ev.eventData}");
            setState(() {
              isConnectionFailed = false;
            });
          });

   meetingHelper!.on("incoming-connection-request", context,
              (ev, context) {
                print("////////////////////////////incoming-connection-request ${ev.eventName}");
                print("////////////////////////////incoming-connection-request ${ev.eventData}");
            setState(() {
              isConnectionFailed = false;
            });
          });


    meetingHelper!.on("join-meeting", context,
              (ev, context) {
                print("////////////////////////////join-meeting ${ev.eventName}");
                print("////////////////////////////join-meeting ${ev.eventData}");
            setState(() {
              isConnectionFailed = false;
            });



          });


    meetingHelper!.on("joined-meeting", context,
              (ev, context) {
                print("////////////////////////////joined-meeting ${ev.eventName}");
                print("////////////////////////////joined-meeting ${ev.eventData}");
            setState(() {
              isConnectionFailed = false;
            });
          });
    meetingHelper!.on("user-joined", context,
              (ev, context) {
                print("////////////////////////////user-joined ${ev.eventName}");
                print("////////////////////////////user-joined ${ev.eventData}");
            setState(() {
              isConnectionFailed = false;
            });
          });



      meetingHelper!.on("user-left", context,
              (ev, context) {
            setState(() {
              isConnectionFailed = false;
            });
          });


      meetingHelper!.on("video-toggle", context,
              (ev, context) {
            setState(() {

            });
          });

      meetingHelper!.on("audio-toggle", context,
              (ev, context) {
            setState(() {

            });
          });

      meetingHelper!.on("meeting-ended", context,
              (ev, context) {

               onMeetingEnded();
          });


      meetingHelper!.on("connection-setting-changed", context,
              (ev, context) {

                setState(() {
                  isConnectionFailed = false;
                });
          });


      meetingHelper!.on("stream-changed", context,
              (ev, context) {

                setState(() {
                  isConnectionFailed = false;
                });
          });

     meetingHelper!.on("offer-sdp", context,
              (ev, context) {

                print("//////////////////////////// ${ev.eventName}");
                setState(() {
                  isConnectionFailed = false;
                });
          });

     meetingHelper!.on("answer-sdp", context,
              (ev, context) {
                print("//////////////////////////// ${ev.eventName}");
                setState(() {
                  isConnectionFailed = false;
                });

          });

      setState(() {

      });

  }

  initRender()async {
    await _localRender.initialize();
  }

  void onMeetingEnded() {
    if(meetingHelper != null){
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHomePage();
    }

  }
  
  goToHomePage(){
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (cx)=>const HomeScreen()));
  }

  void onAudioToggle(){

    if(meetingHelper != null){
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }
  void onVideoToggle(){

    if(meetingHelper != null){
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }


  bool isVideoEnable(){
    return meetingHelper!= null? meetingHelper!.videoEnabled ! : false;
  }

  bool isAudioEnable(){
    return meetingHelper!= null? meetingHelper!.audioEnabled ! : false;
  }
  void handleReconnect (){
    if(meetingHelper != null){
      meetingHelper!.reconnect();
    }
  }

  buildRoom() {
    
    return Stack(
      children: [
        meetingHelper!= null  && meetingHelper!.connections.isNotEmpty?
            GridView.count(
                crossAxisCount:   meetingHelper!.connections.length < 3 ? 1 :2,
            children: List.generate(  meetingHelper!.connections.length,
                    (index) {
                     
              return Padding(padding: const EdgeInsets.all(1),
              
               child: RemoteConnection(renderer: meetingHelper!.connections[index].renderer,
                   connection: meetingHelper!.connections[index]),
              );
              
                    }),
            ):
            const Center(
              child: Padding(padding: EdgeInsets.all(10),
              
              child: Text("صبر کنید تا کاربر جدید وارد شود",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500
              ),),),
            ),

        Positioned(
            bottom: 10,
            right: 0,
            child: SizedBox(
              width: 150,
              height: 200,
              child: RTCVideoView(_localRender),
            ))
      ],
    );
  }
}
