import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:partner_gainclub/components/common/customCachedImage.dart';
import 'package:partner_gainclub/components/common/iconBackground.dart';
import 'package:partner_gainclub/components/common/scaleButton.dart';
import 'package:partner_gainclub/components/error/fetchFailWidget.dart';
import 'package:partner_gainclub/logic/blocs/singleBusinessBloc/singleBusiness.dart';
import 'package:partner_gainclub/screens/Campaign.dart';
import 'package:partner_gainclub/utils/constants.dart';
import 'package:partner_gainclub/utils/services/app/navigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../BusinessDetails.dart';

class HomeBusinessView extends StatelessWidget {
  void goToCampaignScreen(int id) {
    NavigationService.push(
        CampaignPage(campaignID: id), RouteNames.SINGLE_CAMPAIGN);
  }

  @override
  Widget build(ctx) => BlocBuilder<SingleBusinessBloc, SingleBusinessState>(
        builder: (context, snapshot) {
          if (snapshot is SingleBusinessStateSuccess)
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomCachedImage(
                          url: snapshot.data.logoUrl,
                          height: 50,
                          width: 50,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final phone = 'tel:${snapshot.data.phoneNumber}';
                            if (await canLaunch(phone)) await launch(phone);
                          },
                          child: IconBackground(
                            icon: Icons.phone,
                            iconColor: Colors.white,
                            color: Colors.blue,
                            iconSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 100,
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...snapshot.data.campaigns.map(
                            (e) => ScaleButton(
                              onFinish: () {
                                goToCampaignScreen(e.id);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.transparent, width: 3),
                                    borderRadius: BorderRadius.circular(45.0),
                                  ),
                                  child: GestureDetector(
                                    child: CircleAvatar(
                                      child: FittedBox(
                                        child: Text(
                                          e.discount.toString() + "%",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      ),
                                      radius: 40.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: CarouselSlider.builder(
                      itemCount: snapshot.data.urls.length,
                      itemBuilder: (ctx, i, _) => CustomCachedImage(
                        url: snapshot.data.urls[i],
                        fit: BoxFit.cover,
                        radius: 20,
                      ),
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        disableCenter: true,
                        scrollPhysics: BouncingScrollPhysics(),
                      ),
                    ),
                  ),
                  BusinessDetails(business: snapshot.data),
                ],
              ),
            );

          if (snapshot is SingleBusinessStateLoading)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (snapshot is SingleBusinessStateError)
            return Center(
              child: FetchFailWidget(),
            );
          if (snapshot is SingleBusinessStateInitial)
            return Center(
              child: Text(
                tr("tooltip.choose_business_map"),
              ),
            );
          return Container();
        },
      );
}
