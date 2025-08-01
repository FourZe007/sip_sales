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

  @override
  void initState() {
    super.initState();
    // Initialize date formatting for Indonesian locale
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<SipSalesState>(context);

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
                return Center(
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is UpdateFollowupDashboardLoaded) {
                log('Data length: ${state.updateFollowupData.length}');
                log('Detail length: ${state.updateFollowupData[0].followup.length}');
                return ListView.builder(
                  itemCount: state.updateFollowupData.length,
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
                                        Format.toTitleCase(data.customerName),
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
                                        Format.toTitleCase(data.modelName),
                                        style: GlobalFont.bigfontR,
                                        maxLines: null,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),

                                // ~:Prospect Status:~
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Status',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        Format.toTitleCase(data.prospectStatus),
                                        style: GlobalFont.bigfontR,
                                        maxLines: null,
                                        overflow: TextOverflow.visible,
                                      ),
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
                            final bool isEditable =
                                _isCardEditable(data.followup, index);

                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  spacing: 8,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ~:Follow-Up Data Header:~
                                    Row(
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
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // ~:Follow-Up Date:~
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Tanggal',
                                            style: GlobalFont.bigfontR,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            onTap: isEditable
                                                ? () async {
                                                    final date =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          e.fuDate.isNotEmpty
                                                              ? DateTime.parse(
                                                                  e.fuDate)
                                                              : DateTime.now(),
                                                      firstDate: DateTime(2020),
                                                      lastDate: DateTime(2030),
                                                    );

                                                    if (date != null) {
                                                      final newFollowup =
                                                          UpdateFollowupDashboardDetails(
                                                        fuDate: date
                                                            .toIso8601String(),
                                                        fuMemo: e.fuMemo,
                                                        fuResult: e.fuResult,
                                                        nextFUDate:
                                                            e.nextFUDate,
                                                        line: e.line,
                                                      );
                                                      setState(() {
                                                        data.followup[index] =
                                                            newFollowup;
                                                      });
                                                    }
                                                  }
                                                : null,
                                            child: Text(
                                              isEditable
                                                  ? e.fuDate.isNotEmpty
                                                      ? DateFormat(
                                                          'dd MMMM yyyy',
                                                          'id_ID',
                                                        ).format(DateTime.parse(
                                                          e.fuDate))
                                                      : DateFormat(
                                                          'dd MMMM yyyy',
                                                          'id_ID',
                                                        ).format(DateTime.now())
                                                  : '-',
                                              style:
                                                  GlobalFont.bigfontR.copyWith(
                                                color: isEditable
                                                    ? Colors.blue
                                                    : Colors.black,
                                                fontStyle: isEditable
                                                    ? FontStyle.italic
                                                    : FontStyle.normal,
                                              ),
                                            ),
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
                                                  e.fuMemo.isNotEmpty
                                                      ? e.fuMemo
                                                      : '-',
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
