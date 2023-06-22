import 'package:conferance/models/model_meeting_detail.dart';
import 'package:conferance/page/meeting_page.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class JoinScreen extends StatefulWidget {
  final MeetingDetail ?meetingDetail;

  const JoinScreen({Key? key,  this.meetingDetail, }) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {

  GlobalKey<FormState> formKey = GlobalKey();
  String userName = "";
  @override
  Widget build(BuildContext context) {
    return      Scaffold(
      appBar: AppBar(
        title: Text("Join Meeting app"),
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

          SizedBox(
            height: 20,
          ),

          FormHelper.inputFieldWidget(
              context,
              "userId",
              "enter your name",
                  (val){
                if(val.toString().isEmpty){
                  return "name not empty";
                }
                return null;
              },
                  (onSaved){
                userName = onSaved;
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

                      // meeting:
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MeetingPage(
                        meetingDetail: widget.meetingDetail,
                        meetingId: widget.meetingDetail!.id,
                        name: userName,

                      )));
                    }

                  }
              )),


            ],
          )
        ],
      ),
    ),
  );

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

