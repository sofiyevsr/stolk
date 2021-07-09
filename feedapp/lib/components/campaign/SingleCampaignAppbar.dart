import 'package:partner_gainclub/logic/blocs/singleCampaignBloc/singleCampaign.dart';
import 'package:partner_gainclub/utils/common.dart';
import 'package:partner_gainclub/utils/services/app/navigationService.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleCampaignAppbar extends StatelessWidget {
  const SingleCampaignAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleCampaignBloc, SingleCampaignState>(
      builder: (ctx, state) => SliverAppBar(
        pinned: true,
        expandedHeight: 200,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
            ),
            // primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Icon(
            Icons.arrow_back_sharp,
            size: 24,
            color: Colors.white,
          ),
          onPressed: () {
            NavigationService.pop();
          },
        ),
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(bottom: 12),
          centerTitle: true,
          title: state is SingleCampaignStateSuccess
              ? FittedBox(
                  child: SizedBox(
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          campaignStatusToContainer(state.data.campaignStatus),
                          Text(
                            shortenString(state.data.name, 14),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
          background: Image.asset(
            "assets/static/campaign.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
