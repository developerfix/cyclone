import 'package:flutter/material.dart';

class LimitedText {
  LimitedText(
    this.widgetData, {
    Key key,
    this.widgetColorClickableText,
    this.widgetTrimLines = 2,
    this.widgetStyle,
    this.widgetTextAlign,
    this.widgetTextDirection,
    this.widgetLocale,
    this.widgetTextScaleFactor,
    this.widgetSemanticsLabel,
    this.maxWidth,
    this.maxHeight,
  }) : assert(widgetData != null);

  final String widgetData;
  final Color widgetColorClickableText;
  final int widgetTrimLines;
  final TextStyle widgetStyle;
  final TextAlign widgetTextAlign;
  final TextDirection widgetTextDirection;
  final Locale widgetLocale;
  final double widgetTextScaleFactor;
  final String widgetSemanticsLabel;
  final double maxWidth, maxHeight;

  final String _kEllipsis = '\u2026';

  bool canWrite(BuildContext context) {
    var resultOfProcess = true;
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = widgetStyle;
    if (widgetStyle == null || widgetStyle.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widgetStyle);
    }

    final textAlign =
        widgetTextAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widgetTextDirection ?? Directionality.of(context);
    final textScaleFactor =
        widgetTextScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    final overflow = defaultTextStyle.overflow;
    final locale = widgetLocale ?? Localizations.localeOf(context);

    print('Controlling 2');

    // Create a TextSpan with data
    final text = TextSpan(
      style: effectiveTextStyle,
      children: <TextSpan>[
        TextSpan(
          style: effectiveTextStyle,
          text: widgetData,
        ),
      ],
    );

    // Layout and measure link
    TextPainter textPainter = TextPainter(
      text: text,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
      maxLines: widgetTrimLines,
      ellipsis: overflow == TextOverflow.ellipsis ? _kEllipsis : null,
      locale: locale,
    );

    textPainter.text = text;
    textPainter.layout(maxWidth: maxWidth);
    final textSize = textPainter.size;

    if (textSize.width < maxWidth) {
      //
    } else {
      resultOfProcess = false;
    }

    if (textPainter.didExceedMaxLines) {
      resultOfProcess = false;
    } else {
      //
    }
    print('height: ${textPainter.height} maxHeight: ${maxHeight}');
    print('width: ${textPainter.width} maxWidth: ${maxWidth}');

    /*return RichText(
          textAlign: textAlign,
          textDirection: textDirection,
          softWrap: true,
          //softWrap,
          overflow: TextOverflow.clip,
          //overflow,
          textScaleFactor: textScaleFactor,
          text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: new TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            children: <TextSpan>[
              textSpan,
            ],
          ),
        );*/

    return resultOfProcess;
  }
}
