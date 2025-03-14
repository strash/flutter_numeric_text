import "dart:math";
import "dart:ui" as ui;

import "package:flutter/widgets.dart";

part "./config.dart";
part "./extensions.dart";
part "./painter.dart";
part "./renderbox.dart";

class NumericText extends StatelessWidget {
  /// The text to display.
  final String data;

  /// The duration of the transition from the old [data] value to the new one
  /// for each character. This duration determines how long the animation
  /// takes for each character to transition individually, creating a dynamic
  /// effect as the text updates. The overall duration of the transition
  /// will vary depending on the number of characters being animated.
  final Duration? duration;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? style;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with
  /// `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was
  /// unlimited horizontal space.
  final bool? softWrap;

  /// How visual overflow should be handled.
  ///
  /// If this is null [TextStyle.overflow] will be used, otherwise the value
  /// from the nearest [DefaultTextStyle] ancestor will be used.
  final TextOverflow? overflow;

  /// {@macro flutter.painting.textPainter.textScaler}
  final TextScaler? textScaler;

  /// An optional maximum number of lines for the text to span, wrapping if
  /// necessary.
  /// If the text exceeds the given number of lines, it will be truncated
  /// according to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int? maxLines;

  /// {@template flutter.widgets.Text.semanticsLabel}
  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text. This will overwrite any of the semantics labels
  /// applied directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// const Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// A widget that displays any text with individual character animations.
  ///
  /// This class serves as the entry point for users of the plugin. It renders
  /// the provided text as a standard [Text] widget, while additionally
  /// animating each character separately whenever the data changes. This can be
  /// useful for creating dynamic and visually engaging text displays, such as
  /// counters or animated labels.
  ///
  /// The [data] parameter specifies the text to be displayed. The optional
  /// [duration] parameter defines the transition duration from the old value
  /// to the new one for each character. This duration determines how long the
  /// animation takes for each character to transition individually, creating a
  /// dynamic effect as the text updates. The overall duration of the transition
  /// will vary depending on the number of characters being animated. The
  /// [style] parameter allows customization of the text appearance, merging
  /// with the closest enclosing [DefaultTextStyle] if its "inherit" property is
  /// set to true. The [strutStyle] parameter can be used to control the spacing
  /// of the text. The [textAlign] parameter controls the horizontal alignment
  /// of the text, while [maxLines] can be used to limit the number of lines the
  /// text spans, enabling wrapping if necessary. The [textDirection] parameter
  /// determines the directionality of the text, affecting how alignment values
  /// like [TextAlign.start] and [TextAlign.end] are interpreted. The [locale]
  /// parameter is used to select a font when the same Unicode character can be
  /// rendered differently, depending on the locale. The [softWrap] parameter
  /// specifies whether the text should break at soft line breaks. The
  /// [overflow] parameter defines how visual overflow should be handled. The
  /// [textScaler] parameter allows for scaling the text based on the device's
  /// text scaling factor. The [semanticsLabel] provides an alternative
  /// semantics label for this text, which can be useful for accessibilit
  /// purposes. The [textWidthBasis] parameter determines how the text width is
  /// calculated, and the [textHeightBehavior] parameter controls the behavior
  /// of text height adjustments.
  ///
  /// Example usage:
  /// ```dart
  /// NumericText(
  ///   "12345 or text",
  ///   duration: const Duration(milliseconds: 300),
  ///   style: const TextStyle(fontSize: 24, color: Colors.black),
  ///   textAlign: TextAlign.center,
  ///   textDirection: TextDirection.ltr,
  ///   locale: const Locale("en", "US"),
  ///   softWrap: true,
  ///   overflow: TextOverflow.ellipsis,
  ///   maxLines: 1,
  ///   semanticsLabel: "Numeric value",
  /// )
  /// ```
  const NumericText(
    this.data, {
    super.key,
    this.duration,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _NumericText(
          data: data,
          duration: duration,
          constraints: constraints,
          config: _NumericTextConfig(
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
          ),
        );
      },
    );
  }
}

class _NumericText extends StatefulWidget {
  final String data;
  final Duration? duration;
  final BoxConstraints constraints;
  final _NumericTextConfig config;

  const _NumericText({
    required this.data,
    this.duration,
    required this.constraints,
    required this.config,
  });

  @override
  State<_NumericText> createState() => _NumericTextState();
}

class _NumericTextState extends State<_NumericText>
    with SingleTickerProviderStateMixin {
  late final TextPainter _oldPainter = TextPainter(
    text: widget.config.getSpan(context, widget.data),
    textDirection: widget.config.getTextDirection(context),
  );
  late final TextPainter _newPainter = TextPainter(
    text: widget.config.getSpan(context, widget.data),
    textDirection: widget.config.getTextDirection(context),
  );

  late String _oldData = widget.data;
  (Size, Size) _sizes = (Size.zero, Size.zero);
  List<_Line> _data = [];

  Duration _delay = Duration.zero;
  Duration _duration = Duration.zero;

  late final _controller = AnimationController(
    vsync: this,
    lowerBound: .0,
    upperBound: 1.0,
    duration: widget.duration ?? _defaultDurationPerChange,
  )..addStatusListener(_statusListener);

  Duration get _defaultDurationPerChange {
    return const Duration(milliseconds: 150);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _oldData = widget.data;
      _controller.reset();
      _updatePainters();
      _computeSizes();
      _computeData();
    }
  }

  void _updatePainters() {
    widget.config.update(context, _oldData, _oldPainter);
    widget.config.update(context, widget.data, _newPainter);
  }

  void _computeSizes() {
    final minWidth = widget.constraints.minWidth;
    final maxWidth =
        (widget.config.softWrap ?? true) ||
                widget.config.overflow == TextOverflow.ellipsis
            ? widget.constraints.maxWidth
            : double.infinity;
    _oldPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
    _newPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
    _sizes = (_oldPainter.size, _newPainter.size);
  }

  /// input:
  /// old | $12.23 abc
  /// new | $4312.23 c
  ///
  /// output:
  /// old | $ | null | null | 1 | 2 | . | 2 | 3 |   | a |    b |    c |
  /// new | $ |    4 |    3 | 1 | 2 | . | 2 | 3 |   | c | null | null |
  ///
  /// old nulls are growing over the time
  /// new nulls are shrinking
  void _computeData() {
    final oldChars = _oldData.characters;
    final newChars = widget.data.characters;
    final oldMetrics = _oldPainter.computeLineMetrics();
    final newMetrics = _newPainter.computeLineMetrics();

    int lineIdx = 0;
    int oldLineTextPosOffset = 0;
    int newLineTextPosOffset = 0;
    final List<_Line> pairs = [];

    while (oldMetrics.elementAtOrNull(lineIdx) != null &&
        newMetrics.elementAtOrNull(lineIdx) != null) {
      final line = _Line(
        oldLineMetrics: oldMetrics.elementAtOrNull(lineIdx),
        newLineMetrics: newMetrics.elementAtOrNull(lineIdx),
      );

      final oldLineBoundary = _oldPainter.getLineBoundary(
        TextPosition(offset: oldLineTextPosOffset),
      );
      final oldLineChars = oldChars
          .skip(oldLineBoundary.start)
          .take(oldLineBoundary.end - oldLineBoundary.start);
      oldLineTextPosOffset = oldLineBoundary.end + 1;
      final oldNums = oldLineChars.string.allNumbers;

      final newLineBoundary = _newPainter.getLineBoundary(
        TextPosition(offset: newLineTextPosOffset),
      );
      final newLineChars = newChars
          .skip(newLineBoundary.start)
          .take(newLineBoundary.end - newLineBoundary.start);
      newLineTextPosOffset = newLineBoundary.end + 1;
      final newNums = newLineChars.string.allNumbers;

      final count = max(oldLineChars.length, newLineChars.length);
      for (int i = 0; i < count; i++) {
        line.oldChars.add(oldLineChars.elementAtOrNull(i));
        line.newChars.add(newLineChars.elementAtOrNull(i));
      }

      // find slots before numbers to grow/shrink and fill them with nulls
      if (oldNums.isNotEmpty &&
          newNums.isNotEmpty &&
          oldLineChars.length != newLineChars.length) {
        // (start, length)
        final List<(int, int)> oldCommands = [];
        final List<(int, int)> newCommands = [];
        int oldInsertLength = 0;
        int newInsertLength = 0;
        // create commands to execute
        int numIdx = 0;
        while (true) {
          final oldNum = oldNums.elementAtOrNull(numIdx);
          final newNum = newNums.elementAtOrNull(numIdx);
          if (oldNum == null || newNum == null) break;
          var oldNumLength = oldNum.end - oldNum.start;
          var newNumLength = newNum.end - newNum.start;
          if (oldNumLength != newNumLength) {
            if (oldNumLength > newNumLength) {
              var length = oldNumLength - newNumLength;
              newCommands.add((newNum.start, length));
              newInsertLength += length;
            } else {
              var length = newNumLength - oldNumLength;
              oldCommands.add((oldNum.start, length));
              oldInsertLength += length;
            }
          }
          numIdx++;
        }
        // execute commands in reversed order
        for (var i = oldCommands.length - 1; i >= 0; i--) {
          final command = oldCommands.elementAt(i);
          for (var j = 0; j < command.$2; j++) {
            line.oldChars.insert(command.$1 + j, null);
          }
        }
        for (var i = newCommands.length - 1; i >= 0; i--) {
          final command = newCommands.elementAt(i);
          for (var j = 0; j < command.$2; j++) {
            line.newChars.insert(command.$2 + j, null);
          }
        }
        // equalize lengths
        for (var i = 0; i < (oldInsertLength - newInsertLength).abs(); i++) {
          if (oldInsertLength > newInsertLength) {
            if (line.oldChars.isNotEmpty) {
              if (line.oldChars.last == null) {
                line.oldChars.removeLast();
              } else {
                line.newChars.add(null);
              }
            }
          } else {
            if (line.newChars.isNotEmpty) {
              if (line.newChars.last == null) {
                line.newChars.removeLast();
              } else {
                line.oldChars.add(null);
              }
            }
          }
        }
      }

      assert(
        line.oldChars.length == line.newChars.length,
        "The length of the chars must be equal. "
        "${line.oldChars} ${line.newChars}",
      );

      pairs.add(line);
      lineIdx++;
    }
    _data = pairs;
  }

  @override
  void didUpdateWidget(covariant _NumericText oldWidget) {
    _oldData = oldWidget.data;
    _updatePainters();
    _computeSizes();
    _computeData();
    final diffCount = _data.fold(
      -1,
      (prev, curr) => prev + curr.diffCount + curr.nullsCount,
    );
    _duration = widget.duration ?? _defaultDurationPerChange;
    _delay = _duration * .18;
    _controller.duration = _duration + _delay * max(0, diffCount);
    if (_controller.status != AnimationStatus.forward) {
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.removeStatusListener(_statusListener);
    _controller.dispose();
    _oldPainter.dispose();
    _newPainter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sizes.isEmpty) {
      _updatePainters();
      _computeSizes();
      _computeData();
    }

    final imax = _controller.duration!.inMilliseconds.toDouble();
    final delay = _delay.inMilliseconds.toDouble().remap(.0, imax, .0, 1.0);
    final dur = _duration.inMilliseconds.toDouble().remap(.0, imax, .0, 1.0);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          Widget result = _Text(
            data: _data,
            animation: _controller,
            delay: delay,
            duration: dur,
            config: widget.config.inferData(context),
            sizes: _sizes,
            oldPainter: _oldPainter,
            newPainter: _newPainter,
          );

          if (widget.config.semanticsLabel != null) {
            result = Semantics(
              textDirection:
                  widget.config.textDirection ?? Directionality.of(context),
              label: widget.config.semanticsLabel,
              child: ExcludeSemantics(child: result),
            );
          }

          return result;
        },
      ),
    );
  }
}

final class _Text extends LeafRenderObjectWidget {
  final List<_Line> data;
  final Animation<double> animation;
  final double delay;
  final double duration;
  final _NumericTextConfig config;
  final (Size, Size) sizes;
  final TextPainter oldPainter;
  final TextPainter newPainter;

  const _Text({
    required this.data,
    required this.animation,
    required this.delay,
    required this.duration,
    required this.config,
    required this.sizes,
    required this.oldPainter,
    required this.newPainter,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RB(
      data: data,
      animation: animation.value,
      delay: delay,
      duration: duration,
      config: config,
      sizes: sizes,
      oldPainter: oldPainter,
      newPainter: newPainter,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RB renderObject) {
    renderObject.data = data;
    renderObject.t = animation.value;
    renderObject.delay = delay;
    renderObject.duration = duration;
    renderObject.config = config;
    renderObject.sizes = sizes;
    renderObject.oldPainter = oldPainter;
    renderObject.newPainter = newPainter;
  }
}

final class _Line {
  final LineMetrics? oldLineMetrics;
  final LineMetrics? newLineMetrics;
  final List<String?> oldChars = [];
  final List<String?> newChars = [];

  _Line({this.oldLineMetrics, this.newLineMetrics});

  int get diffCount {
    int count = 0;
    for (var i = 0; i < newChars.length; i++) {
      if (oldChars.elementAt(i) != newChars.elementAt(i)) count++;
    }
    return count;
  }

  int get nullsCount {
    int count = 0;
    for (var i = 0; i < newChars.length; i++) {
      var a = oldChars.elementAt(i);
      var b = newChars.elementAt(i);
      if (a != b && (a == null || b == null)) {
        count++;
      }
    }
    return count;
  }

  @override
  operator ==(covariant _Line other) {
    return hashCode == other.hashCode;
  }

  @override
  int get hashCode =>
      oldLineMetrics.hashCode +
      newLineMetrics.hashCode +
      oldChars.hashCode +
      newChars.hashCode;
}
