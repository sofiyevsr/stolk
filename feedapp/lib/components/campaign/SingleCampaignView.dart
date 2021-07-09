import 'package:easy_localization/easy_localization.dart';
import 'package:partner_gainclub/components/campaign/SingleCampaignAppbar.dart';
import 'package:partner_gainclub/components/campaign/SingleCampaignFooter.dart';
import 'package:partner_gainclub/components/common/groupListTile.dart';
import 'package:partner_gainclub/components/error/fetchFailWidget.dart';
import 'package:partner_gainclub/logic/blocs/singleCampaignBloc/singleCampaign.dart';
import 'package:partner_gainclub/utils/common.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

List<SingleTileInGroup> _buildBusinessSection({
  required String? isBusinessActive,
  required int businessTypeId,
  required String businessAddress,
  required String businessName,
  required String phoneNumber,
  required String? businessRating,
}) {
  print(businessRating);
  return [
    SingleTileInGroup(
      icon: Icons.storefront_outlined,
      leadingText: tr("business.name"),
      trailing: Text(businessName),
    ),
    SingleTileInGroup(
      icon: Icons.home_outlined,
      leadingText: tr("business.address"),
      trailing: Text(
        businessAddress,
        overflow: TextOverflow.visible,
      ),
    ),
    SingleTileInGroup(
      icon: Icons.star_outline_outlined,
      leadingText: tr("business.rating"),
      trailing: FittedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: RatingBarIndicator(
            rating: businessRating != null
                ? double.tryParse(businessRating) ?? 0
                : 0,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            direction: Axis.horizontal,
          ),
        ),
      ),
    ),
    SingleTileInGroup(
      icon: Icons.phone_in_talk_outlined,
      leadingText: tr("business.phone"),
      trailing: TextButton(
        onPressed: () async {
          final phone = 'tel:$phoneNumber';
          if (await canLaunch(phone)) await launch(phone);
        },
        child: Text(
          phoneNumber,
          style: TextStyle(fontSize: 17),
        ),
      ),
    ),
  ];
}

List<SingleTileInGroup> _buildCampaignSection({
  required int discount,
  required String expiresAt,
  required int count,
  required String startsAt,
  required int leftCount,
  required int bookingValidForHours,
}) {
  return [
    SingleTileInGroup(
      icon: Icons.local_offer_outlined,
      leadingText: tr("campaign.discount"),
      trailing: Text(discount.toString() + " %"),
    ),
    SingleTileInGroup(
      icon: Icons.hourglass_top_outlined,
      leadingText: tr("campaign.starts_at"),
      trailing: Text(startsAt),
    ),
    SingleTileInGroup(
      icon: Icons.hourglass_bottom_outlined,
      leadingText: tr("campaign.expires_at"),
      trailing: Text(expiresAt),
    ),
    SingleTileInGroup(
      icon: Icons.local_activity_outlined,
      leadingText: tr("campaign.count"),
      trailing: Text(count.toString()),
    ),
    SingleTileInGroup(
      icon: Icons.event_available,
      leadingText: tr("campaign.left_count"),
      trailing: Text(leftCount.toString()),
    ),
    SingleTileInGroup(
      icon: Icons.schedule,
      leadingText: tr("campaign.booking_valid_for_hours"),
      trailing: Text(bookingValidForHours.toString()),
    ),
  ];
}

class SingleCampaignView extends StatefulWidget {
  const SingleCampaignView({Key? key}) : super(key: key);

  @override
  _SingleCampaignViewState createState() => _SingleCampaignViewState();
}

class _SingleCampaignViewState extends State<SingleCampaignView> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SingleCampaignAppbar(),
                  _buildCampaignDetails(context, _controller),
                ],
              ),
            ),
            SingleCampaignFooter(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "1");
  }

  Widget _buildCampaignDetails(
      BuildContext ctx, TextEditingController _controller) {
    return BlocBuilder<SingleCampaignBloc, SingleCampaignState>(
      builder: (context, state) {
        if (state is SingleCampaignStateSuccess)
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                GroupListTile(
                  title: tr("single_campaign.business_details"),
                  tiles: _buildBusinessSection(
                    businessAddress: state.data.businessAddress,
                    businessRating: state.data.businessRating,
                    businessName: state.data.businessName,
                    businessTypeId: state.data.businessTypeID,
                    isBusinessActive: state.data.businessArchivedAt,
                    phoneNumber: state.data.phoneNumber,
                  ),
                ),
                GroupListTile(
                  title: tr("single_campaign.campaign_details"),
                  tiles: _buildCampaignSection(
                    discount: state.data.discount,
                    startsAt: convertTime(state.data.startsAt, ctx),
                    expiresAt: convertTime(state.data.expiresAt, ctx),
                    leftCount: state.data.leftCount,
                    count: state.data.count,
                    bookingValidForHours: state.data.bookingValidForHours,
                  ),
                ),
              ],
            ),
          );
        if (state is SingleCampaignStateLoading)
          return SliverFillRemaining(
            child: Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        if (state is SingleCampaignStateError)
          return SliverFillRemaining(
            child: Center(
              child: FetchFailWidget(
                errorText: "errors.campaign_fetch_failed",
              ),
            ),
          );
        return SliverFillRemaining(
          child: Container(),
        );
      },
    );
  }
}
