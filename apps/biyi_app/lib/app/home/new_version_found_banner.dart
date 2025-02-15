import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/utilities/utilities.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:influxui/influxui.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersionFoundBanner extends StatelessWidget {
  const NewVersionFoundBanner({
    super.key,
    required this.latestVersion,
  });

  final Version latestVersion;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          left: 0,
          right: 0,
        ),
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 18,
          right: 18,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: LocaleKeys
                    .app_home_newversion_banner_text_found_new_version
                    .tr(args: [latestVersion.version]),
              ),
              style: textTheme.bodyMedium!.copyWith(
                color: ExtendedColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: Container()),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: LocaleKeys.app_home_newversion_banner_btn_update.tr(),
                    style: const TextStyle(
                      color: ExtendedColors.white,
                      height: 1.3,
                      decoration: TextDecoration.underline,
                      decorationColor: ExtendedColors.white,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Uri url = Uri.parse(
                          '${sharedEnv.webUrl}/release-notes#${latestVersion.version}',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                  ),
                ],
              ),
              style: textTheme.bodyMedium!.copyWith(
                color: ExtendedColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
