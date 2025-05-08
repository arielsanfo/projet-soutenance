import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante%5B1%5D.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text(
                      textAlign: TextAlign.left,
                      'Mon Profil',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // SizedBox(height: 5),
                  Container(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 100,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Sanfo Ariel'),
                          SizedBox(height: 15),
                          Text('arielsanfo@gmail.com'),

                          SizedBox(height: 30),
                          Container(
                            // height: ,
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.textPrimary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor,
                                  blurRadius: 1,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(padding: EdgeInsets.all(10)),
                                Row(
                                  spacing: 140,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        //
                                      },
                                      child: Text(
                                        'Administrateur',
                                        style: TextStyle(
                                          color: AppColors.textOnPrimary,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.admin_panel_settings,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // child: Container(child: Text('Role')),
                          ),
                          SizedBox(height: 30),
                          Container(
                            // height: ,
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.textPrimary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor,
                                  blurRadius: 1,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(padding: EdgeInsets.all(10)),
                                Row(
                                  spacing: 140,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        //
                                      },
                                      child: Text(
                                        'Decembre 2015',
                                        style: TextStyle(
                                          color: AppColors.textOnPrimary,
                                        ),
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.calendar_month,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // child: Container(child: Text('Role')),
                          ),
                          SizedBox(height: 50),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                //
                              },
                              // child: Text('data'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 60,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                
                              ),child: Text('data',style: TextStyle(color: AppColors.accentColor,),
                            ),
                          ),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// 