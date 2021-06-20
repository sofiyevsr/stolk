import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;

String shortenString(String s, int limit) =>
    s.length <= limit ? s : s.replaceRange(limit, s.length, '...');

String typeIDToName(int type) {
  if (type == BusinessType.CLOTHING) {
    return tr("business_type.clothing");
  }
  if (type == BusinessType.FOOD) {
    return tr("business_type.food");
  } else
    return tr("business_type.default");
}

IconData typeIDToIcon(int type) {
  if (type == BusinessType.CLOTHING) {
    return Icons.checkroom_outlined;
  }
  if (type == BusinessType.FOOD) {
    return Icons.restaurant;
  } else
    return Icons.store;
}

Widget campaignStatusToContainer(int status) {
  if (status == CampaignStatus.PREMIUM) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: Color.fromRGBO(240, 220, 130, 1),
          ),
          child: Icon(Icons.star, color: Colors.white),
        ),
      ),
    );
  }
  return Container();
}

String convertTime(String date, BuildContext context) {
  final lang = EasyLocalization.of(context)?.currentLocale?.languageCode;
  final data = DateTime.tryParse(date)?.toLocal();
  if (data == null) {
    return "";
  }
  final format = DateFormat("HH:mm, d MMMM", lang ?? "en");
  return format.format(data);
}

String convertDiffTime(String date, BuildContext context) {
  final lang = EasyLocalization.of(context)?.currentLocale?.languageCode;
  final data = DateTime.tryParse(date)?.toLocal();
  if (data == null) {
    return "";
  }
  return timeago.format(data, locale: lang);
}

class LimitRangeTextInputFormatter extends TextInputFormatter {
  LimitRangeTextInputFormatter(this.min, this.max) : assert(min < max);

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == "") return newValue;
    var value = int.tryParse(newValue.text);
    if (value == null) return oldValue;
    if (value < min || value > max) {
      return oldValue;
    }
    return newValue;
  }
}

// TODO clarify logic
bool canCreateBooking(int? usersBooking, bool campaignExpired, int leftCount) {
  if (usersBooking != null) return false;
  if (campaignExpired == true) return false;
  if (leftCount <= 0) {
    return false;
  }
  return true;
}

// TODO clarify logic
bool canDeleteBooking(bool bookingExpired, String? bookingClaimed) {
  if (bookingExpired == true) return false;
  if (bookingClaimed != null) return false;
  return true;
}
