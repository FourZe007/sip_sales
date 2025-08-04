import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/global/state/updatefollowupdashboard/update_followup_dashboard_bloc.dart';
import 'package:sip_sales/global/state/updatefollowupdashboard/update_followup_dashboard_event.dart';
import 'package:sip_sales/global/state/updatefollowupdashboard/update_followup_dashboard_state.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

class FollowupDashboardDetail extends StatefulWidget {
  const FollowupDashboardDetail({
    required this.mobilePhone,
    required this.prospectDate,
    super.key,
  });

  final String mobilePhone;
  final String prospectDate;

  @override
  State<FollowupDashboardDetail> createState() =>
      _FollowupDashboardDetailState();
}

class _FollowupDashboardDetailState extends State<FollowupDashboardDetail> {
  void refreshFollowupDashboard(
    BuildContext context,
    SipSalesState appState,
  ) {
    final salesmanId = appState.getUserAccountList.isNotEmpty
        ? appState.getUserAccountList[0].employeeID
        : '';
    context.read<UpdateFollowupDashboardBloc>().add(
          LoadUpdateFollowupDashboard(
            salesmanId,
            widget.mobilePhone,
            widget.prospectDate,
          ),
        );
  }

  // Helper method to check if a card should be editable
  bool _isCardEditable(
    List<UpdateFollowupDashboardDetails> followups,
    int currentIndex,
  ) {
    // If this is the first card, it's always editable if empty
    if (currentIndex == 0) {
      return !_isCardFilled(followups[0]);
    }

    // For other cards, check if all previous cards are filled
    for (int i = 0; i < currentIndex; i++) {
      if (!_isCardFilled(followups[i])) {
        return false; // A previous card is not filled, so this one isn't editable
      }
    }

    // This card is editable only if it's not already filled and all previous cards are filled
    return !_isCardFilled(followups[currentIndex]);
  }

  // Helper method to check if a card has been filled
  bool _isCardFilled(UpdateFollowupDashboardDetails card) {
    return card.fuDate.isNotEmpty && card.fuMemo.isNotEmpty;
  }

  void selectDate(
    BuildContext context,
    UpdateFollowupDashboardDetails e,
    int index,
    List<UpdateFollowupDashboardDetails> data,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          e.fuDate.isNotEmpty ? DateTime.parse(e.fuDate) : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      final newFollowup = UpdateFollowupDashboardDetails(
        fuDate: date.toIso8601String(),
        fuMemo: e.fuMemo,
        fuResult: e.fuResult,
        nextFUDate: e.nextFUDate,
        line: e.line,
      );
      setState(() {
        data[index] = newFollowup;
      });
    }
  }

  void saveFollowup(
    BuildContext context,
    UpdateFollowupDashboardDetails e,
    int index,
    UpdateFollowupDashboardBloc updateFollowup,
    SipSalesState appState,
  ) {
    final salesmanId = appState.getUserAccountList.isNotEmpty
        ? appState.getUserAccountList[0].employeeID
        : '';

    if (_isCardFilled(e)) {
      updateFollowup.add(
        SaveUpdateFollowupStatus(
          salesmanId,
          widget.mobilePhone,
          widget.prospectDate,
          index,
          e.fuDate,
          e.fuResult,
          e.fuMemo,
          e.nextFUDate,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
            'Harap isi semua kolom!',
            style: GlobalFont.bigfontR,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.all(8),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize date formatting for Indonesian locale
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<SipSalesState>(context);
    final updateFollowup = context.read<UpdateFollowupDashboardBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Detail',
          style: GlobalFont.bigfontR,
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Platform.isIOS
                ? Icons.arrow_back_ios_new_rounded
                : Icons.arrow_back_rounded,
            size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => refreshFollowupDashboard(context, appState),
            icon: Icon(
              Icons.refresh_rounded,
              size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
          child: BlocBuilder<UpdateFollowupDashboardBloc,
              UpdateFollowupDashboardState>(
            bloc: updateFollowup,
            buildWhen: (previous, current) =>
                current is UpdateFollowupDashboardLoading ||
                current is UpdateFollowupDashboardLoaded ||
                current is UpdateFollowupDashboardError,
            // listener: (context, state) => refreshFollowupDashboard(
            //   context,
            //   appState,
            // ),
            builder: (context, state) {
              log('Builder State: $state');
              if (state is UpdateFollowupDashboardLoading) {
                if (Platform.isIOS) {
                  return const CupertinoActivityIndicator(
                    radius: 12.5,
                    color: Colors.black,
                  );
                } else {
                  return const CircleLoading(
                    warna: Colors.black,
                    strokeWidth: 3,
                  );
                }
              } else if (state is UpdateFollowupDashboardError) {
                log('Error: ${state.message}');
                if (state.message.contains('[]')) {
                  return Center(
                    child: Text(
                      'Data Tidak Ditemukan',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Center(
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is UpdateFollowupDashboardLoaded) {
                log('Data length: ${state.updateFollowupData.length}');
                log('Detail length: ${state.updateFollowupData[0].followup.length}');

                if (state.updateFollowupData.isEmpty) {
                  return Center(
                    child: Text(
                      'Data Tidak Ditemukan',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.updateFollowupData.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = state.updateFollowupData[index];

                    return Column(
                      children: [
                        // ~:Customer Data Card:~
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ~:Card Title:~
                                Text(
                                  'Data Konsumen',
                                  style: GlobalFont.bigfontRBold,
                                ),

                                // ~:Customer Name:~
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Nama',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        Format.toSentenceUpperCase(
                                            data.customerName),
                                        style: GlobalFont.bigfontR,
                                        maxLines: null,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),

                                // ~:Prospect Date:~
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Tanggal',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DateFormat('dd MMMM yyyy').format(
                                            DateTime.parse(data.prospectDate)),
                                        style: GlobalFont.bigfontR,
                                        maxLines: null,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),

                                // ~:Customer Capability:~
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Kemampuan',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        data.customerStatus,
                                        style: GlobalFont.bigfontR,
                                        maxLines: null,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                // ~:Customer Interest:~
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Minat',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        Format.toSentenceUpperCase(
                                            data.modelName),
                                        style: GlobalFont.bigfontR,
                                        maxLines: null,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),

                                // ~:Prospect Status:~
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // ~:Label:~
                                    Expanded(
                                      child: Text(
                                        'Status',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    ),

                                    // ~:Dropdown Options:~
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        Format.toSentenceUpperCase(
                                            data.prospectStatus),
                                        style: GlobalFont.bigfontR,
                                        maxLines: null,
                                        overflow: TextOverflow.visible,
                                      ),
                                      // ~:Dropdown Followup Options:~
                                      // child: BlocBuilder<
                                      //         UpdateFollowupDashboardBloc,
                                      //         UpdateFollowupDashboardState>(
                                      //     builder: (context, state) {
                                      //   String status = '';
                                      //   if (state
                                      //       is UpdateFollowupDashboardStatusSucceed) {
                                      //     status = state.status.name;
                                      //   } else {
                                      //     status = FollowUpStatus.notYet.name;
                                      //   }
                                      //
                                      //   return Container(
                                      //     width: double.infinity,
                                      //     height: 36,
                                      //     alignment: Alignment.center,
                                      //     decoration: BoxDecoration(
                                      //       borderRadius:
                                      //           BorderRadius.circular(20.0),
                                      //       border: Border.all(
                                      //         color: Colors.blue,
                                      //         width: 1.5,
                                      //       ),
                                      //     ),
                                      //     padding: const EdgeInsets.symmetric(
                                      //       horizontal: 8.0,
                                      //       vertical: 4.0,
                                      //     ),
                                      //     child: DropdownButton<String>(
                                      //       value: status,
                                      //       isExpanded: true,
                                      //       dropdownColor: Colors.white,
                                      //       icon: const Icon(
                                      //         Icons.arrow_drop_down_rounded,
                                      //         color: Colors.blue,
                                      //       ),
                                      //       iconSize: 28,
                                      //       elevation: 0,
                                      //       style: GlobalFont.bigfontR,
                                      //       underline: SizedBox(),
                                      //       onChanged: (String? newValue) {
                                      //         log('Change prospect status to $newValue');
                                      //         updateFollowup.add(
                                      //           SelectUpdateFollowupStatus(
                                      //             FollowUpStatus.values
                                      //                 .firstWhere((e) =>
                                      //                     e.name == newValue),
                                      //           ),
                                      //         );
                                      //       },
                                      //       items: FollowUpStatus.values
                                      //           .map<DropdownMenuItem<String>>(
                                      //               (value) {
                                      //         // ~:Option 2 is the best approach:~
                                      //         // It is more concise and easier to read.
                                      //         // The switch statement is more efficient than the if-else chain.
                                      //         // The code is also more maintainable since it is easier to add or remove cases.
                                      //
                                      //         String status = '';
                                      //         switch (value) {
                                      //           case FollowUpStatus.notYet:
                                      //             status = 'Belum Follow-Up';
                                      //             break;
                                      //           case FollowUpStatus.inProgress:
                                      //             status = 'Proses Follow-Up';
                                      //             break;
                                      //           case FollowUpStatus.completed:
                                      //             status = 'Deal';
                                      //             break;
                                      //           case FollowUpStatus.cancelled:
                                      //             status = 'Cancel';
                                      //             break;
                                      //         }
                                      //
                                      //         return DropdownMenuItem<String>(
                                      //           value: value.name,
                                      //           child: Text(status),
                                      //         );
                                      //       }).toList(),
                                      //     ),
                                      //   );
                                      // }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ~:Customer Follow-Up Attempts:~
                        Column(
                          children: data.followup.asMap().entries.map((entry) {
                            final index = entry.key;
                            final e = entry.value;

                            // Check if this card should be editable
                            final bool isEditable = _isCardEditable(
                              data.followup,
                              index,
                            );

                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  spacing: 8,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ~:Follow-Up Data Header:~
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Follow-Up #${index + 1}',
                                            style: GlobalFont.bigfontRBold,
                                          ),
                                          Builder(
                                            builder: (context) {
                                              if (!isEditable &&
                                                  _isCardFilled(e)) {
                                                return const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 20,
                                                );
                                              } else if (isEditable) {
                                                return ElevatedButton(
                                                  onPressed: () => saveFollowup(
                                                    context,
                                                    e,
                                                    index,
                                                    updateFollowup,
                                                    appState,
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        20,
                                                      ),
                                                    ),
                                                    minimumSize:
                                                        const Size(52, 32),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8),
                                                  ),
                                                  child: BlocConsumer<
                                                          UpdateFollowupDashboardBloc,
                                                          UpdateFollowupDashboardState>(
                                                      listener:
                                                          (context, state) {
                                                    if (state
                                                        is SaveFollowupSucceed) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              Colors.grey,
                                                          content: Text(
                                                            'Update follow-up berhasil.',
                                                            style: GlobalFont
                                                                .bigfontR,
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          margin:
                                                              EdgeInsets.all(8),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                        ),
                                                      );
                                                    } else if (state
                                                        is SaveFollowupFailed) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              Colors.grey,
                                                          content: Text(
                                                            state.message,
                                                            style: GlobalFont
                                                                .bigfontR,
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          margin:
                                                              EdgeInsets.all(8),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                        ),
                                                      );
                                                    }
                                                  }, builder: (context, state) {
                                                    if (state
                                                        is SaveFollowupLoading) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    } else {
                                                      return Text(
                                                        'Save',
                                                        style: GlobalFont
                                                            .bigfontR
                                                            .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      );
                                                    }
                                                  }),
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ~:Follow-Up Date:~
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Tanggal FU',
                                            style: GlobalFont.bigfontR,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Builder(
                                            builder: (context) {
                                              if (isEditable) {
                                                return InkWell(
                                                  onTap: () async => selectDate(
                                                    context,
                                                    e,
                                                    index,
                                                    data.followup,
                                                  ),
                                                  child: Text(
                                                    e.fuDate.isNotEmpty
                                                        ? DateFormat(
                                                            'dd MMMM yyyy',
                                                            'id_ID',
                                                          ).format(
                                                            DateTime.parse(
                                                                e.fuDate))
                                                        : DateFormat(
                                                            'dd MMMM yyyy',
                                                            'id_ID',
                                                          ).format(
                                                            DateTime.now()),
                                                    style: GlobalFont.bigfontR
                                                        .copyWith(
                                                      color: Colors.blue,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                if (e.fuDate.isNotEmpty) {
                                                  return Text(
                                                    DateFormat(
                                                      'dd MMMM yyyy',
                                                      'id_ID',
                                                    ).format(DateTime.parse(
                                                        e.fuDate)),
                                                    style: GlobalFont.bigfontR
                                                        .copyWith(
                                                      color: Colors.black,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  );
                                                } else {
                                                  return Text(
                                                    '-',
                                                    style: GlobalFont.bigfontR
                                                        .copyWith(
                                                      color: Colors.black,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ~:Follow-Up Information:~
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Keterangan',
                                            style: GlobalFont.bigfontR,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Builder(
                                            builder: (context) {
                                              if (isEditable) {
                                                return TextFormField(
                                                  initialValue: e.fuMemo,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Masukkan keterangan...',
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                  ),
                                                  style: GlobalFont.bigfontR,
                                                  maxLines: null,
                                                  onChanged: (value) {
                                                    final updatedFollowup =
                                                        UpdateFollowupDashboardDetails(
                                                      fuDate: e.fuDate,
                                                      fuMemo: value,
                                                      fuResult: e.fuResult,
                                                      nextFUDate: e.nextFUDate,
                                                      line: e.line,
                                                    );
                                                    setState(() {
                                                      data.followup[index] =
                                                          updatedFollowup;
                                                    });
                                                  },
                                                );
                                              } else {
                                                return Text(
                                                  e.fuMemo.isEmpty
                                                      ? '-'
                                                      : Format
                                                          .toFirstLetterUpperCase(
                                                              e.fuMemo),
                                                  style: e.fuMemo.isNotEmpty
                                                      ? GlobalFont.bigfontR
                                                      : GlobalFont.bigfontR
                                                          .copyWith(
                                                          color: Colors.black,
                                                        ),
                                                  maxLines: null,
                                                  overflow:
                                                      TextOverflow.visible,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
