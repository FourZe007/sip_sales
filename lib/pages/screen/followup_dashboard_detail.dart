import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state/followupdate_cubit.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/global/state/updatefollowupdashboard/update_followup_dashboard_bloc.dart';
import 'package:sip_sales/global/state/updatefollowupdashboard/update_followup_dashboard_event.dart';
import 'package:sip_sales/global/state/updatefollowupdashboard/update_followup_dashboard_state.dart';
import 'package:sip_sales/widget/date/follow_up.dart';
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
  String results = '';

  void refreshFollowupDashboard(
    BuildContext context,
    SipSalesState appState,
  ) {
    final salesmanId = appState.getUserAccountList.isNotEmpty
        ? appState.getUserAccountList[0].employeeID
        : '';

    context.read<FollowupCubit>().resetFollowup();

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
    UpdateFollowUpDashboardModel data,
    int currentIndex,
  ) {
    // For the first follow-up date
    if (currentIndex == -1) {
      return data.firstFUDate.isEmpty; // Only editable if empty
    }

    // For follow-up cards
    // Check if firstFUDate is set
    if (data.firstFUDate.isEmpty) {
      return false;
    }

    // Check if all previous cards are filled
    for (int i = 0; i < currentIndex; i++) {
      if (i < data.followup.length && !_isCardFilled(data.followup[i])) {
        return false;
      }
    }

    // Check if current card is not already filled
    if (currentIndex < data.followup.length) {
      return !_isCardFilled(data.followup[currentIndex]);
    }

    return false;
  }

  // Helper method to check if a card has been filled
  bool _isCardFilled(UpdateFollowupDashboardDetails card) {
    if (card.fuResult != FollowUpResults.pending.name) {
      return card.fuDate.isNotEmpty && card.fuMemo.isNotEmpty;
    }

    return card.fuDate.isNotEmpty &&
        card.nextFUDate.isNotEmpty &&
        card.fuMemo.isNotEmpty;
  }

  void selectDate(
    BuildContext context, {
    int fuMode = 0,
    required UpdateFollowUpDashboardModel data,
    UpdateFollowupDashboardDetails? details,
    int index = 0,
  }) async {
    log('fuMode: $fuMode');

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      if (fuMode == 0) {
        // Update firstFUDate
        final updatedData = data.copyWith(
          firstFUDate: date.toIso8601String(),
        );

        // Update the state with the new data
        if (context.mounted) {
          context.read<FollowupCubit>().changeFollowup(updatedData);
        }
      } else {
        if (details != null) {
          // Update follow-up date
          final updatedDetails = details.copyWith(
            fuDate: fuMode == 1 ? date.toIso8601String() : details.fuDate,
            nextFUDate:
                fuMode == 2 ? date.toIso8601String() : details.nextFUDate,
          );
          log('updatedDetails: $updatedDetails');

          // Update the state with the new details
          if (context.mounted) {
            // Update your state with the new details
            // This depends on your state management solution
            final updatedFollowups =
                List<UpdateFollowupDashboardDetails>.from(data.followup);
            // final index = data.followup.indexOf(details);
            log('index: $index');
            updatedFollowups[index] = updatedDetails;
            final updatedData = data.copyWith(followup: updatedFollowups);
            log('updatedData: ${updatedData.followup[index].fuDate}');
            // Update your state with updatedData
            context.read<FollowupCubit>().changeFollowup(updatedData);
          }
        } else {}
      }
    }
  }

  void selectFollowupStatus(
    BuildContext context,
    String newValue,
    UpdateFollowUpDashboardModel data,
    int index,
  ) {
    final followupCubit = context.read<FollowupCubit>();

    final updatedDetailedData = data.followup[index].copyWith(
      fuDate: followupCubit.getFollowup.followup[index].fuDate,
      fuResult: newValue,
      nextFUDate: followupCubit.getFollowup.followup[index].nextFUDate,
      fuMemo: followupCubit.getFollowup.followup[index].fuMemo,
    );
    log('updatedDetailedData: ${updatedDetailedData.fuResult}');

    final updatedFollowups =
        List<UpdateFollowupDashboardDetails>.from(data.followup);
    updatedFollowups[index] = updatedDetailedData;
    final updatedData = data.copyWith(followup: updatedFollowups);
    log('updatedData: ${updatedData.followup[index].fuResult}');

    // Update your state with updatedData
    context.read<FollowupCubit>().changeFollowup(updatedData);
  }

  void modifyFUDesc(
    BuildContext context,
    String newValue,
    UpdateFollowUpDashboardModel data,
    int index,
  ) async {
    final followupCubit = context.read<FollowupCubit>();

    final updatedDetailedData = data.followup[index].copyWith(
      fuDate: followupCubit.getFollowup.followup[index].fuDate,
      fuResult: followupCubit.getFollowup.followup[index].fuResult,
      nextFUDate: followupCubit.getFollowup.followup[index].nextFUDate,
      fuMemo: newValue,
    );
    log('updatedDetailedData: ${updatedDetailedData.fuMemo}');

    final updatedFollowups =
        List<UpdateFollowupDashboardDetails>.from(data.followup);
    updatedFollowups[index] = updatedDetailedData;
    final updatedData = data.copyWith(followup: updatedFollowups);
    log('updatedData: ${updatedData.followup[index].fuMemo}');

    // Update your state with updatedData
    context.read<FollowupCubit>().changeFollowup(updatedData);
  }

  String getFollowupStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PD':
        return 'Pending';
      case 'DL':
        return 'Deal';
      case 'CL':
        return 'Cancel';
      default:
        return '';
    }
  }

  void saveFollowup(
    BuildContext context,
    UpdateFollowUpDashboardModel data,
    int fuMode,
    UpdateFollowupDashboardBloc updateFollowup,
    FollowupCubit followup,
    SipSalesState appState, {
    int fuDetailsIndex = 0,
  }) {
    final salesmanId = appState.getUserAccountList.isNotEmpty
        ? appState.getUserAccountList[0].employeeID
        : '';

    if (fuMode == 0) {
      log('index 0');
      log(followup.getFollowup.firstFUDate.split('T')[0]);
      updateFollowup.add(
        SaveUpdateFollowup(
          salesmanId,
          widget.mobilePhone,
          widget.prospectDate,
          fuMode,
          followup.getFollowup.firstFUDate.split('T')[0],
          '',
          '',
          '',
        ),
      );
    } else {
      UpdateFollowUpDashboardModel modifiedData =
          context.read<FollowupCubit>().getFollowup;

      if (modifiedData.followup.isEmpty) {
        final details = data.followup[fuDetailsIndex].copyWith(
          fuDate: DateTime.now().toIso8601String(),
          fuResult: 'PD',
          fuMemo: '-',
          nextFUDate: DateTime.now().toIso8601String(),
        );

        modifiedData = data.copyWith(
          followup: [details],
        );
      }

      if (_isCardFilled(modifiedData.followup[fuDetailsIndex])) {
        log('Follow-Up #${fuDetailsIndex + 1}');
        log('Salesman Id: $salesmanId');
        log('Mobile Phone: ${modifiedData.mobilePhone}');
        log('Prospect Date: ${modifiedData.prospectDate}');
        log('Line: ${fuDetailsIndex + 1}');
        log('Follow-Up Date: ${modifiedData.followup[fuDetailsIndex].fuDate}');
        log('Follow-Up Result: ${modifiedData.followup[fuDetailsIndex].fuResult}');
        log('Follow-Up Memo: ${modifiedData.followup[fuDetailsIndex].fuMemo}');
        log('Follow-Up Next Date: ${modifiedData.followup[fuDetailsIndex].nextFUDate}');

        updateFollowup.add(
          SaveUpdateFollowup(
            salesmanId,
            widget.mobilePhone,
            widget.prospectDate,
            fuDetailsIndex + 1,
            modifiedData.followup[fuDetailsIndex].fuDate.split('T')[0],
            modifiedData.followup[fuDetailsIndex].fuResult,
            modifiedData.followup[fuDetailsIndex].fuMemo,
            modifiedData.followup[fuDetailsIndex].nextFUDate.split('T')[0],
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
  }

  @override
  void initState() {
    super.initState();
    // Initialize date formatting for Indonesian locale
    initializeDateFormatting('id_ID', null);
  }

  @override
  void dispose() {
    super.dispose();

    results = '';
    // newFuDate = '';
    // newNextFuDate = '';
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<SipSalesState>(context);
    final updateFollowup = context.read<UpdateFollowupDashboardBloc>();
    final followup = context.read<FollowupCubit>();

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
                // log('Data length: ${state.updateFollowupData.length}');
                // log('Detail length: ${state.updateFollowupData[0].followup.length}');

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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Data Konsumen',
                                      style: GlobalFont.bigfontRBold,
                                    ),
                                    Builder(builder: (context) {
                                      if (data.firstFUDate.isNotEmpty) {
                                        return SizedBox.shrink();
                                      } else {
                                        return ElevatedButton(
                                          onPressed: () => saveFollowup(
                                            context,
                                            data,
                                            0,
                                            updateFollowup,
                                            followup,
                                            appState,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                            minimumSize: const Size(52, 32),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                          ),
                                          child: BlocConsumer<
                                              UpdateFollowupDashboardBloc,
                                              UpdateFollowupDashboardState>(
                                            listener: (context, state) {
                                              if (state
                                                  is SaveFollowupSucceed) {
                                                refreshFollowupDashboard(
                                                  context,
                                                  appState,
                                                );
                                              }
                                            },
                                            builder: (context, state) {
                                              if (state
                                                  is SaveFollowupLoading) {
                                                if (Platform.isIOS) {
                                                  return const CupertinoActivityIndicator(
                                                    radius: 12.5,
                                                    color: Colors.white,
                                                  );
                                                } else {
                                                  return const CircleLoading(
                                                    warna: Colors.white,
                                                    customizedHeight: 20,
                                                    customizedWidth: 20,
                                                    strokeWidth: 3,
                                                  );
                                                }
                                              } else {
                                                return Text(
                                                  'Save',
                                                  style: GlobalFont.bigfontR
                                                      .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      }
                                    }),
                                  ],
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
                                        DateFormat(
                                          'dd MMMM yyyy',
                                          'id_ID',
                                        ).format(
                                          DateTime.parse(data.prospectDate),
                                        ),
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
                                    ),
                                  ],
                                ),

                                // ~:First Followup Date:~
                                Row(
                                  children: [
                                    // ~:Title:~
                                    Expanded(
                                      child: Text(
                                        'FU Pertama',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    ),

                                    // ~:Date Picker:~
                                    Expanded(
                                        flex: 2,
                                        child: BlocBuilder<FollowupCubit,
                                            UpdateFollowUpDashboardModel>(
                                          builder: (context, state) {
                                            if (_isCardEditable(data, -1)) {
                                              return InkWell(
                                                onTap: () async => selectDate(
                                                  context,
                                                  fuMode: 0,
                                                  data: data,
                                                ),
                                                child: Text(
                                                  state.firstFUDate.isNotEmpty
                                                      ? DateFormat(
                                                          'dd MMMM yyyy',
                                                          'id_ID',
                                                        ).format(
                                                          DateTime.parse(
                                                            state.firstFUDate,
                                                          ),
                                                        )
                                                      : DateFormat(
                                                          'dd MMMM yyyy',
                                                          'id_ID',
                                                        ).format(
                                                          DateTime.now(),
                                                        ),
                                                  style: GlobalFont.bigfontR
                                                      .copyWith(
                                                    color: Colors.blue,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                DateFormat(
                                                  'dd MMMM yyyy',
                                                  'id_ID',
                                                ).format(
                                                  DateTime.parse(
                                                    data.firstFUDate,
                                                  ),
                                                ),
                                                style: GlobalFont.bigfontR
                                                    .copyWith(
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              );
                                            }
                                          },
                                        )),
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
                            final bool isEditable =
                                _isCardEditable(data, index);

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
                                                    data,
                                                    index + 1,
                                                    updateFollowup,
                                                    followup,
                                                    appState,
                                                    fuDetailsIndex: index,
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

                                                      refreshFollowupDashboard(
                                                        context,
                                                        appState,
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
                                                      if (Platform.isIOS) {
                                                        return const CupertinoActivityIndicator(
                                                          radius: 12.5,
                                                          color: Colors.white,
                                                        );
                                                      } else {
                                                        return const CircleLoading(
                                                          warna: Colors.white,
                                                          customizedHeight: 20,
                                                          customizedWidth: 20,
                                                          strokeWidth: 3,
                                                        );
                                                      }
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
                                    BlocBuilder<FollowupCubit,
                                            UpdateFollowUpDashboardModel>(
                                        builder: (context, state) {
                                      final currentFollowup =
                                          state.followup.elementAtOrNull(index);

                                      return FollowupDatePicker(
                                        label: 'Tanggal FU',
                                        date:
                                            currentFollowup?.fuDate ?? e.fuDate,
                                        isEditable: isEditable,
                                        onTap: () => selectDate(
                                          context,
                                          fuMode: 1,
                                          data: data,
                                          details: currentFollowup ?? e,
                                          index: index,
                                        ),
                                      );
                                    }),

                                    // ~:Followup Result:~
                                    Row(
                                      children: [
                                        // ~:Title:~
                                        Expanded(
                                          child: Text(
                                            'Hasil FU',
                                            style: GlobalFont.bigfontR,
                                          ),
                                        ),

                                        // ~:Dropdown:~
                                        Expanded(
                                          flex: 2,
                                          child: BlocBuilder<FollowupCubit,
                                                  UpdateFollowUpDashboardModel>(
                                              builder: (context, state) {
                                            if (isEditable) {
                                              return Container(
                                                width: double.infinity,
                                                height: 36,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  border: Border.all(
                                                    color: Colors.blue,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 4.0,
                                                ),
                                                child: DropdownButton<String>(
                                                  value: state.followup.isEmpty
                                                      ? FollowUpResults
                                                          .pending.name
                                                      : state.followup[index]
                                                              .fuResult.isEmpty
                                                          ? FollowUpResults
                                                              .pending.name
                                                          : state
                                                              .followup[index]
                                                              .fuResult,
                                                  isExpanded: true,
                                                  dropdownColor: Colors.white,
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_drop_down_rounded,
                                                    color: Colors.blue,
                                                  ),
                                                  iconSize: 28,
                                                  elevation: 0,
                                                  style: GlobalFont.bigfontR,
                                                  underline: SizedBox(),
                                                  onChanged:
                                                      (String? newValue) =>
                                                          selectFollowupStatus(
                                                    context,
                                                    newValue!,
                                                    data,
                                                    index,
                                                  ),
                                                  items: FollowUpResults.values
                                                      .map<
                                                          DropdownMenuItem<
                                                              String>>((value) {
                                                    String result = '';
                                                    switch (value) {
                                                      case FollowUpResults
                                                            .pending:
                                                        result = 'Pending';
                                                        break;
                                                      case FollowUpResults.deal:
                                                        result = 'Deal';
                                                        break;
                                                      case FollowUpResults
                                                            .cancel:
                                                        result = 'Cancel';
                                                        break;
                                                    }

                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value.name,
                                                      child: Text(result),
                                                    );
                                                  }).toList(),
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                e.fuResult.isNotEmpty
                                                    ? getFollowupStatus(
                                                        e.fuResult)
                                                    : '-',
                                                style: GlobalFont.bigfontR,
                                                overflow: TextOverflow.visible,
                                              );
                                            }
                                          }),
                                        ),
                                      ],
                                    ),

                                    // ~:Next Followup Date:~
                                    BlocBuilder<FollowupCubit,
                                            UpdateFollowUpDashboardModel>(
                                        builder: (context, state) {
                                      if (state.followup.isNotEmpty &&
                                          state.followup[index].fuResult !=
                                              '' &&
                                          state.followup[index].fuResult !=
                                              FollowUpResults.pending.name) {
                                        log(state.followup[index].fuResult);
                                        return SizedBox.shrink();
                                      } else {
                                        final currentNextFollowup = state
                                            .followup
                                            .elementAtOrNull(index);

                                        return FollowupDatePicker(
                                          label: 'Next FU',
                                          date:
                                              currentNextFollowup?.nextFUDate ??
                                                  e.nextFUDate,
                                          isEditable: isEditable,
                                          onTap: () => selectDate(
                                            context,
                                            fuMode: 2,
                                            data: data,
                                            details: currentNextFollowup ?? e,
                                            index: index,
                                          ),
                                        );
                                      }
                                    }),

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
                                                  onChanged: (value) =>
                                                      modifyFUDesc(
                                                    context,
                                                    value,
                                                    data,
                                                    index,
                                                  ),
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
