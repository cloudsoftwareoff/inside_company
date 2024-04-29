import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:intl/intl.dart';

class OpportunityColoredCard extends StatefulWidget {
  final Opportunity opportunity;
  final VoidCallback onClick;
  const OpportunityColoredCard(
      {super.key, required this.opportunity, required this.onClick});

  @override
  State<OpportunityColoredCard> createState() => _OpportunityColoredCardState();
}

class _OpportunityColoredCardState extends State<OpportunityColoredCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 570,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          text: widget.opportunity.title,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          DateFormat('MMM dd, HH:mm')
                              .format(widget.opportunity.timestamp!.toDate()),
                          style: const TextStyle(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.secondaryColor,
                              width: 2,
                            ),
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  7, 0, 7, 0),
                              child: Text(
                                widget.opportunity.material.join('-'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: Text(
                        '${widget.opportunity.budget} DT',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: widget.opportunity.status == "CONFIRMED"
                              ? Colors.lightGreen[300]
                              : widget.opportunity.status == "PENDING"
                                  ? Colors.amber[300]
                                  : Colors.red[300],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.opportunity.status == "CONFIRMED"
                                ? Colors.lightGreen
                                : widget.opportunity.status == "PENDING"
                                    ? Colors.amber
                                    : Colors.red,
                            width: 2,
                          ),
                        ),
                        child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 12, 0),
                            child: Text(
                              widget.opportunity.status,
                              style: const TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}