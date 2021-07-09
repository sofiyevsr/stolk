import 'package:partner_gainclub/components/common/iconBackground.dart';
import 'package:partner_gainclub/utils/@types/response/singleBusiness.dart';
import 'package:partner_gainclub/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BusinessDetails extends StatelessWidget {
  final SingleBusiness business;

  BusinessDetails({required this.business});

  @override
  Widget build(ctx) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      typeIDToIcon(business.businessTypeID),
                      size: 30,
                      color: Colors.blue,
                    ),
                    Text(
                      typeIDToName(business.businessTypeID),
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: business.rating != null
                    ? double.tryParse(business.rating!) ?? 0
                    : 0,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemSize: 20,
                itemCount: 5,
                direction: Axis.horizontal,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              shortenString(business.name.toUpperCase(), 15),
              style: Theme.of(ctx).textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (business.description != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                shortenString(business.description!, 100),
                style: Theme.of(ctx).textTheme.subtitle1?.copyWith(),
              ),
            ),
          Card(
            elevation: 1.5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(4),
              leading: IconBackground(
                icon: Icons.location_on_sharp,
                color: Colors.blue,
                iconColor: Colors.white,
              ),
              title: Text(
                shortenString(business.address, 30),
                style: Theme.of(ctx).textTheme.bodyText2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
