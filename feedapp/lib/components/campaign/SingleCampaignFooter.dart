import 'package:easy_localization/easy_localization.dart';
import 'package:partner_gainclub/components/auth/views/AuthView.dart';
import 'package:partner_gainclub/components/common/inputs/number.dart';
import 'package:partner_gainclub/logic/blocs/authBloc/auth.dart';
import 'package:partner_gainclub/logic/blocs/singleCampaignBloc/utils/singleCampaignBloc.dart';
import 'package:partner_gainclub/screens/BookingPage.dart';
import 'package:partner_gainclub/utils/common.dart';
import 'package:partner_gainclub/utils/constants.dart';
import 'package:partner_gainclub/utils/services/server/bookingService.dart';
import 'package:partner_gainclub/utils/services/app/navigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleCampaignFooter extends StatefulWidget {
  @override
  _SingleCampaignFooterState createState() => _SingleCampaignFooterState();
}

class _SingleCampaignFooterState extends State<SingleCampaignFooter> {
  int? _count;
  bool requestSent = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext ctx) {
    final auth = ctx.read<AuthBloc>();
    return BlocBuilder<SingleCampaignBloc, SingleCampaignState>(
      builder: (context, state) {
        if (state is SingleCampaignStateSuccess)
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NumberedInput(
                  onSaved: (count) {
                    if (count != null) _count = int.tryParse(count);
                  },
                ),
                Container(
                  height: 60,
                  child: ElevatedButton(
                    child: requestSent == true
                        ? CircularProgressIndicator()
                        : Text(
                            tr("buttons.book"),
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: requestSent == true ||
                            !canCreateBooking(
                              state.data.userBookingId,
                              state.data.campaignExpired,
                              state.data.leftCount,
                            )
                        ? null
                        : () async {
                            if (!(auth.state is AuthorizedState))
                              return NavigationService.push(
                                AuthView(),
                                RouteNames.AUTH,
                              );
                            final isValid = _formKey.currentState?.validate();
                            if (isValid != true) return;
                            _formKey.currentState?.save();
                            if (_count != null) {
                              setState(() {
                                requestSent = true;
                              });
                              final book = BookingService();
                              try {
                                final res = await book.createBooking(
                                  state.data.id,
                                  _count!,
                                );
                                NavigationService.replaceCurrent(
                                  BookingPage(id: res.id),
                                  RouteNames.SINGLE_BOOKING,
                                );
                              } catch (e) {
                                print('error $e');
                              } finally {
                                setState(() {
                                  requestSent = false;
                                });
                              }
                            }
                          },
                  ),
                ),
              ],
            ),
          );
        return Container();
      },
    );
  }
}
