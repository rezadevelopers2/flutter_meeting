

import 'dart:convert';
import 'package:conferance/models/model_meeting_detail.dart';
import 'package:http/http.dart';
import 'package:conferance/api/meeting.api.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GlobalKey<FormState> formKey = GlobalKey();
  String meetingId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meeting app"),
      ),
      
      body: Form(
        key: formKey,
        child: formUi(),
      ),
    );
  }

  formUi() {
    
    return  Center(
      child: Padding(padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("welcome to meeting",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800
          ),),
          
          const SizedBox(
            height: 20,
          ),
          
          FormHelper.inputFieldWidget(
              context,
              "meetingId",
              "enter your Meeting id",
              (val){
                if(val.toString().isEmpty){
                  return "meeting id not empty";
                }
                return null;
              },
              (onSaved){
                meetingId = onSaved;
              },
          borderRadius: 10,
            hintColor: Colors.grey
          ),

          const SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              Flexible(child: FormHelper.submitButton(
                  "join Meeting",
                  (){

                    if(validateAndSave()){

                      validateMeeting(meetingId);
                    }

                  }
              )),

              Flexible(child: FormHelper.submitButton(
                  "start Meeting",
                  ()async{
                    var response = await startMeeting();
                    final body = json.decode(response!.body);
                    final meetId = body["data"];
                    validateMeeting(meetId);
                  }
              )),
            ],
          )
        ],
      ),
      ),
    );
    
  }

  void validateMeeting(String meetingId) async{

    try{

      Response response = await joinMeeting(meetingId);
      var data = json.decode(response.body);
      final meetingDetail = MeetingDetail.fromJson(data['data']);
      gotToJoinScreen(meetingDetail);
    }catch(e){

      FormHelper.showSimpleAlertDialog(context,
          "Meeting App",
          "Invalid Meeting Id",
          "ok",
          (){
        Navigator.pop(context);
          });
    }
  }

  gotToJoinScreen(MeetingDetail meetingDetail){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>JoinScreen(
      meetingDetail: meetingDetail,

    )));
  }
  bool validateAndSave() {
    final form = formKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }
}
