import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_event.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class UserProfileTemplate extends StatefulWidget {
  const UserProfileTemplate({
    super.key,
    this.openProfile,
    required this.employee,
  });

  final VoidCallback? openProfile;
  final EmployeeModel employee;

  @override
  State<UserProfileTemplate> createState() => _UserProfileTemplateState();
}

class _UserProfileTemplateState extends State<UserProfileTemplate> {
  @override
  Widget build(BuildContext context) {
    // if (widget.openProfile != null) {
    //   return Container(
    //     width: MediaQuery.of(context).size.width,
    //     height: (context.read<LoginBloc>().state as LoginSuccess).user.code == 0
    //         ? 114
    //         : 98,
    //     alignment: Alignment.center,
    //     margin: EdgeInsets.symmetric(
    //       horizontal: MediaQuery.of(context).size.width * 0.025,
    //     ),
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(
    //         horizontal: MediaQuery.of(context).size.width * 0.025,
    //         vertical: MediaQuery.of(context).size.height * 0.02,
    //       ),
    //       child: InkWell(
    //         onTap: widget.openProfile ?? () {},
    //         child: Row(
    //           spacing: 20,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             // ~:Avatar Section:~
    //             CircleAvatar(
    //               radius: 30.0,
    //               backgroundColor: Colors.white,
    //               child: Builder(
    //                 builder: (context) {
    //                   if (widget.employee.code == 1 &&
    //                       widget.employee.profilePicture != '') {
    //                     return ClipOval(
    //                       child: SizedBox.fromSize(
    //                         size: Size.fromRadius(28),
    //                         child: Image.memory(
    //                           base64Decode(
    //                             widget.employee.profilePicture,
    //                           ),
    //                           fit: BoxFit.cover,
    //                         ),
    //                       ),
    //                     );
    //                   } else {
    //                     return const Icon(
    //                       Icons.person,
    //                       size: 25.0,
    //                       color: Colors.black,
    //                     );
    //                   }
    //                 },
    //               ),
    //             ),
    //
    //             // ~:Profile Section:~
    //             Expanded(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Builder(
    //                     builder: (context) {
    //                       if (widget.employee.employeeName.isNotEmpty) {
    //                         return Text(
    //                           widget.employee.employeeName,
    //                           overflow: TextOverflow.ellipsis,
    //                           style: TextThemes.subtitle.copyWith(
    //                             fontSize: 24,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         );
    //                       } else {
    //                         return Text(
    //                           'GUEST',
    //                           overflow: TextOverflow.ellipsis,
    //                           style: TextThemes.subtitle.copyWith(
    //                             fontSize: 24,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         );
    //                       }
    //                     },
    //                   ),
    //                   Builder(
    //                     builder: (context) {
    //                       if (widget.employee.employeeID.isNotEmpty) {
    //                         return Text(
    //                           widget.employee.employeeID,
    //                           style: TextThemes.subtitle.copyWith(fontSize: 18),
    //                         );
    //                       } else {
    //                         return Text(
    //                           'XXXXX/XXXXXX',
    //                           style: TextThemes.subtitle.copyWith(fontSize: 18),
    //                         );
    //                       }
    //                     },
    //                   ),
    //                   BlocBuilder<LoginBloc, LoginState>(
    //                     builder: (context, state) {
    //                       if (state is LoginSuccess && state.user.code == 0) {
    //                         return Text(
    //                           '${Formatter.toTitleCase(widget.employee.bsName)}, ${Formatter.toTitleCase(widget.employee.locationName)}',
    //                           style: TextThemes.subtitle.copyWith(fontSize: 18),
    //                         );
    //                       } else {
    //                         return SizedBox.shrink();
    //                       }
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // } else {
    //
    // }

    if (widget.employee.code == 1) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 98,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.025,
            // vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Row(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ~:Avatar Section:~
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginSuccess &&
                      state.user.profilePicture.isNotEmpty) {
                    return InkWell(
                      onTap: () => Functions.viewPhoto(
                        context,
                        state.user.profilePicture,
                        isCircular: true,
                      ),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(28),
                            child: Image.memory(
                              base64Decode(
                                state.user.profilePicture,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // ~:Profile Picture:~
                        CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 25.0,
                            color: Colors.black,
                          ),
                        ),

                        // ~:Camera Icon:~
                        // Users are allowed to upload their own profile picture
                        BlocListener<ImageCubit, ImageState>(
                          listener: (context, state) async {
                            if (state is ImageLoading) {
                              Functions.customFlutterToast(
                                'Uploading photo...',
                              );
                            } else if (state is ImageError) {
                              log('Image upload failed: ${state.message}');
                              Functions.customFlutterToast(state.message);
                            } else if (state is ImageCaptured) {
                              log('Image uploaded successfully');
                              Functions.customFlutterToast(
                                'Foto berhasil diupload.',
                              );

                              context.read<LoginBloc>().add(
                                LoginButtonPressed(
                                  context: (context.mounted)
                                      ? context
                                      : context,
                                  id: await Functions.readAndWriteEmployeeId(),
                                  pass: await Functions.readAndWriteUserPass(),
                                  isRefresh: true,
                                ),
                              );
                            }
                          },
                          child: Positioned(
                            right: -5,
                            bottom: -5,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 16),
                                color: Colors.black,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () async =>
                                    context.read<ImageCubit>().uploadImage(
                                      await Functions.readAndWriteEmployeeId(),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),

              // ~:Profile Section:~
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        if (widget.employee.employeeName.isNotEmpty) {
                          return Text(
                            widget.employee.employeeName,
                            overflow: TextOverflow.ellipsis,
                            style: TextThemes.subtitle.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return Text(
                            'GUEST',
                            overflow: TextOverflow.ellipsis,
                            style: TextThemes.subtitle.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                    Builder(
                      builder: (context) {
                        if (widget.employee.employeeID.isNotEmpty) {
                          return Text(
                            widget.employee.employeeID,
                            style: TextThemes.subtitle.copyWith(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          );
                        } else {
                          return Text(
                            'XXXXX/XXXXXX',
                            style: TextThemes.subtitle.copyWith(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                      },
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginSuccess && state.user.code == 0) {
                          return Text(
                            '${Formatter.toTitleCase(widget.employee.bsName)}, ${Formatter.toTitleCase(widget.employee.locationName)}',
                            style: TextThemes.subtitle.copyWith(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: (context.read<LoginBloc>().state as LoginSuccess).user.code == 0
            ? 116
            : 98,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.025,
            // vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: InkWell(
            onTap: widget.openProfile ?? () {},
            child: Row(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ~:Avatar Section:~
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 25.0,
                    color: Colors.black,
                  ),
                ),

                // ~:Profile Section:~
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          if (widget.employee.employeeName.isNotEmpty) {
                            return Text(
                              widget.employee.employeeName,
                              overflow: TextOverflow.ellipsis,
                              style: TextThemes.subtitle.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return Text(
                              'GUEST',
                              overflow: TextOverflow.ellipsis,
                              style: TextThemes.subtitle.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                      Builder(
                        builder: (context) {
                          if (widget.employee.employeeID.isNotEmpty) {
                            return Text(
                              widget.employee.employeeID,
                              style: TextThemes.subtitle.copyWith(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            );
                          } else {
                            return Text(
                              'XXXXX/XXXXXX',
                              style: TextThemes.subtitle.copyWith(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        },
                      ),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if (state is LoginSuccess && state.user.code == 0) {
                            return Text(
                              '${Formatter.toTitleCase(widget.employee.bsName)}, ${Formatter.toTitleCase(widget.employee.locationName)}',
                              style: TextThemes.subtitle.copyWith(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
