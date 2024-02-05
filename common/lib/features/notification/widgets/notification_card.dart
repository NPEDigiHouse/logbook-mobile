import 'package:common/features/notification/notification_page.dart';
import 'package:common/features/notification/utils/notif_item_helper.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/notification/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:main/blocs/notification_cubit/notification_cubit.dart';

class NotificationCard extends StatelessWidget {
  final ActivityType activityType;
  final NotificationModel notification;
  final NotificationRole role;
  const NotificationCard(
      {super.key,
      required this.activityType,
      required this.notification,
      required this.role});

  @override
  Widget build(BuildContext context) {
    final notifPref = NotifiItemHelper.getNotifData(
        context, role, notification)[activityType];
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: notifPref?.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  color: (notification.isSeen ?? false)
                      ? secondaryTextColor.withOpacity(.3)
                      : primaryColor.withOpacity(.1),
                  child: Center(
                    child: SvgPicture.asset(
                      AssetPath.getIcon(notifPref!.pathIcon),
                      color: (notification.isSeen ?? false)
                          ? onFormDisableColor
                          : primaryColor,
                      width: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: textTheme.bodyMedium
                            ?.copyWith(color: primaryTextColor),
                        children: <TextSpan>[
                          TextSpan(
                            text: Utils.capitalizeFirstLetter(
                                '${notification.senderName} '),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: notification.message,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          Utils.capitalizeFirstLetter(notifPref.name),
                          style: textTheme.bodySmall
                              ?.copyWith(color: secondaryTextColor),
                        ),
                        const Spacer(),
                        Text(
                          NotifiItemHelper.getSpecificTimeAgo(
                              notification.createdAt!),
                          style: textTheme.bodySmall
                              ?.copyWith(color: secondaryTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
