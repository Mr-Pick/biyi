import 'dart:ui';

import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/services/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:influxui/influxui.dart';
import 'package:screen_capturer/screen_capturer.dart';

class TranslationInputView extends StatelessWidget {
  const TranslationInputView({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.onChanged,
    this.capturedData,
    required this.isTextDetecting,
    required this.translationMode,
    required this.onTranslationModeChanged,
    required this.inputSetting,
    required this.onClickExtractTextFromScreenCapture,
    required this.onClickExtractTextFromClipboard,
    required this.onButtonTappedClear,
    required this.onButtonTappedTrans,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  final CapturedData? capturedData;
  final bool isTextDetecting;

  final String translationMode;
  final ValueChanged<String> onTranslationModeChanged;
  final String inputSetting;

  final VoidCallback onClickExtractTextFromScreenCapture;
  final VoidCallback onClickExtractTextFromClipboard;

  final VoidCallback onButtonTappedClear;
  final VoidCallback onButtonTappedTrans;

  final bool isAddedToVocabulary = true;

  Widget _buildToolbarItems(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: LocaleKeys.app_home_tip_translation_mode.tr(
            args: [
              'translation_mode.$translationMode'.tr(),
            ],
          ),
          child: IconButton(
            FluentIcons.target_20_regular,
            variant: IconButtonVariant.subtle,
            iconBuilder: (context, icon) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    color: translationMode == kTranslationModeAuto
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).iconTheme.color,
                  ),
                  if (translationMode == kTranslationModeAuto)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        padding: const EdgeInsets.only(
                          left: 2,
                          right: 2,
                          top: 1.4,
                          bottom: 1.4,
                        ),
                        child: const Text(
                          'AUTO',
                          style: TextStyle(
                            color: ExtendedColors.white,
                            fontSize: 5.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            size: IconButtonSize.small,
            onPressed: () {
              String newTranslationMode =
                  translationMode == kTranslationModeAuto
                      ? kTranslationModeManual
                      : kTranslationModeAuto;

              UserPreference? userPreference =
                  localDb.preference(kPrefTranslationMode).get();
              if (userPreference != null) {
                localDb.preference(kPrefTranslationMode).update(
                      value: newTranslationMode,
                    );
              } else {
                localDb.preferences.create(
                  key: kPrefTranslationMode,
                  value: newTranslationMode,
                );
              }
              onTranslationModeChanged(newTranslationMode);
            },
          ),
        ),
        const SizedBox(
          width: 8,
          height: 20,
          child: Divider(
            direction: Axis.vertical,
          ),
        ),
        Tooltip(
          message:
              LocaleKeys.app_home_tip_extract_text_from_screen_capture.tr(),
          child: IconButton(
            FluentIcons.crop_20_regular,
            iconBuilder: (context, icon) {
              return Icon(
                icon,
                color: Theme.of(context).iconTheme.color,
              );
            },
            variant: IconButtonVariant.subtle,
            size: IconButtonSize.small,
            onPressed: onClickExtractTextFromScreenCapture,
          ),
        ),
        const SizedBox(width: 4),
        Tooltip(
          message: LocaleKeys.app_home_tip_extract_text_from_clipboard.tr(),
          child: IconButton(
            FluentIcons.clipboard_text_ltr_20_regular,
            iconBuilder: (context, icon) {
              return Icon(
                icon,
                color: Theme.of(context).iconTheme.color,
              );
            },
            variant: IconButtonVariant.subtle,
            size: ButtonSize.small,
            onPressed: onClickExtractTextFromClipboard,
          ),
        ),
        // const SizedBox(
        //   height: 20,
        //   child: VerticalDivider(
        //     width: 8,
        //   ),
        // ),
        // _ToolbarItemAddToNewWord(
        //   controller: controller,
        // )
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 56),
          child: Button(
            variant: ButtonVariant.outlined,
            label: LocaleKeys.app_home_btn_clear.tr(),
            size: ButtonSize.small,
            onPressed: onButtonTappedClear,
          ),
        ),
        const SizedBox(width: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 56),
          child: Button(
            variant: ButtonVariant.filled,
            label: LocaleKeys.app_home_btn_trans.tr(),
            size: ButtonSize.small,
            onPressed: onButtonTappedTrans,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 0,
        bottom: 12,
      ),
      child: Card(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.zero,
              child: Stack(
                children: [
                  CupertinoTextField(
                    focusNode: focusNode,
                    decoration: const BoxDecoration(
                      color: Color(0x00000000),
                    ),
                    selectionHeightStyle: BoxHeightStyle.max,
                    controller: controller,
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 14,
                      bottom: 12,
                    ),
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.2,
                    ),
                    placeholder: LocaleKeys.app_home_input_hint.tr(),
                    placeholderStyle: textTheme.bodyMedium?.copyWith(
                      color: textTheme.bodyMedium?.color?.withOpacity(0.5),
                      height: 1.2,
                    ),
                    maxLines:
                        inputSetting == kInputSettingSubmitWithEnter ? 1 : 6,
                    minLines: 1,
                    onChanged: onChanged,
                    onSubmitted: (newValue) {
                      onButtonTappedTrans();
                    },
                  ),
                  if (isTextDetecting)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        color: Theme.of(context).canvasColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SpinKitDoubleBounce(
                                  color: textTheme.bodySmall!.color,
                                  size: 18.0,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  LocaleKeys.app_home_text_extracting_text.tr(),
                                  style: TextStyle(
                                    color: textTheme.bodySmall!.color,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 8,
                right: 12,
                top: 8,
                bottom: 8,
              ),
              child: Row(
                children: [
                  _buildToolbarItems(context),
                  Expanded(child: Container()),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
