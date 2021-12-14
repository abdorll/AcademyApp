import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muslim_app/Screens/none_auth_screens/mentor_mentee_screen/pending_mentor_request.dart';
import 'package:muslim_app/Screens/none_auth_screens/user_profile_screen/user_profile_page.dart';
import 'package:muslim_app/model/mentee_model.dart';
import 'package:muslim_app/model/pending_request_model.dart';
import 'package:muslim_app/providers/none_auth_provoders/mentee_provider/get_mentee_provider.dart';
import 'package:muslim_app/providers/none_auth_provoders/pending_request_provider/get_pending_request_provider.dart';
import 'package:muslim_app/utils/muslim_navigation.dart';
import 'package:muslim_app/utils/style.dart';
import 'package:muslim_app/widgets/SideSpace.dart';
import 'package:muslim_app/widgets/XSpace.dart';
import 'package:muslim_app/widgets/YSpace.dart';
import 'package:muslim_app/widgets/text.dart';
import 'package:provider/provider.dart';

import 'mentor.dart';



class Mentee extends StatelessWidget {
  static int? mentee_id_of_all_mentee;
  static int? number_of_mentees;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SideSpace(
          0,
          0,
          Column(children: [
            InkWell(
              onTap: (){
                ForwardNavigation.withReturn(context, PendingMentees());
              },
              child: Container(
                decoration: BoxDecoration(color: green),
                child: SideSpace(10, 0,Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [TextOf("Pending mentees...", 14, FontWeight.w700, light_green), TextOf(PendingMentees.pending_mentees.toString() ?? 'loading...', 14, FontWeight.w700, light_green)],),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  child: Consumer<GetMenteeProvider>(builder: (context, value, child) {
                    value.setBuildContext = context;
                    return SideSpace(10, 10, Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: value.menteeModel.length,
                                itemBuilder: (BuildContext context, int index) {
                                  MenteeModel mentee = value.menteeModel[index];
                                  mentee_id_of_all_mentee = mentee.id;
                                  if (value.menteeModel.length == null){
                                    number_of_mentees = 0;
                                  }
                                  number_of_mentees = value.menteeModel.length;
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: light_green,
                                            border: Border.all(color: green),
                                            borderRadius: BorderRadius.circular(25)
                                        ),
                                        child: SideSpace(10,5, Row(
                                          children: [
                                            Stack(children: [CircleAvatar(radius: 30, backgroundColor: green,),Positioned(child: CircleAvatar(radius: 28, backgroundColor: white,), left: 1, right: 1, top: 1, bottom: 1,)]),
                                            XSpace(10),
                                            TextOf(mentee.first_name!, 20, FontWeight.w700, ash2),
                                            XSpace(10),
                                            TextOf(mentee.last_name!, 20, FontWeight.w700, ash2),
                                          ],
                                        ),
                                        ),
                                      ),
                                      YSpace(5)
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    );
                  })),
            ),],)


        ));
  }
}

class PendingMentees extends StatelessWidget {
  const PendingMentees({Key? key}) : super(key: key);
  static int? pending_mentees;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextOf('Pending mentees', 20, FontWeight.w700, white), backgroundColor: green,),
      body: Column(
        children: [
          Expanded(child: Consumer<GetPendingRequestsProvider>(builder: (context, value, child) {
            value.setBuildContext = context;
            return
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.pendingRequestModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      PendingRequestModel pending = value.pendingRequestModel[index];
                      PendingRequestPage.user_id  = pending.id;
                      PendingMentees.pending_mentees = value.pendingRequestModel.length;
                      if(pending.mentee_id != UserProfile.one_user_id){
                        PendingRequestPage.recipient_id = pending.mentor_id;
                      }else if(pending.mentor_id != UserProfile.one_user_id){
                        PendingRequestPage.recipient_id = pending.mentee_id;
                      } else{
                        PendingRequestPage.recipient_id = null;
                      };
                      return Expanded(
                        child:
                        Column(
                          children: [
                            SideSpace(10, 0, InkWell(
                              onTap: (){ForwardNavigation.withReturn(context, AcceptOrDecline());},
                              child: Container(
                                decoration: BoxDecoration(
                                    color: light_green,
                                    border: Border.all(color: green),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child:SideSpace(10,10, Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Stack(children: [CircleAvatar(radius: 30, backgroundColor: green,),Positioned(child: CircleAvatar(radius: 28, backgroundColor: white,), left: 1, right: 1, top: 1, bottom: 1,)]),
                                      XSpace(10),
                                      Column(children: [Row(children: [TextOf(pending.mentee_first_name, 20, FontWeight.w700, ash2),
                                        XSpace(10),
                                        TextOf(pending.mentee_last_name, 20, FontWeight.w700, ash2),
                                      ],),
                                        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [Column(children: [TextOf("Your status:", 10, FontWeight.bold, black), TextOf("${pending.mentor_status}", 10, FontWeight.w400, black),],),XSpace(20),Column(children: [TextOf("Mentee status:", 10, FontWeight.bold, black), TextOf("${pending.mentee_status}", 10, FontWeight.w400, black)],)],)
                                      ],)

                                    ],),
                                  ],

                                ),
                                ),
                              ),
                            )


                            ),
                            YSpace(8),

                          ],
                        ),
                      );
                    }),

              );
          })),

        ],
      ),
    );
  }
}