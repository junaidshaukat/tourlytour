import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AnimatedText {
  final String text;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final Duration duration;
  final Characters textCharacters;

  AnimatedText({
    required this.text,
    this.textAlign = TextAlign.start,
    this.textStyle,
    required this.duration,
  }) : textCharacters = text.characters;

  Duration? get remaining => null;
  void initAnimation(AnimationController controller);
  Widget textWidget(String data) => Text(
        data,
        textAlign: textAlign,
        style: textStyle,
      );

  Widget completeText(BuildContext context) => textWidget(text);
  Widget animatedBuilder(BuildContext context, Widget? child);
}

class AnimatedTextKit extends StatefulWidget {
  final List<AnimatedText> animatedTexts;
  final Duration pause;
  final bool displayFullTextOnTap;
  final bool stopPauseOnTap;
  final VoidCallback? onTap;
  final VoidCallback? onFinished;
  final void Function(int, bool)? onNext;
  final void Function(int, bool)? onNextBeforePause;
  final bool isRepeatingAnimation;
  final bool repeatForever;
  final int totalRepeatCount;

  const AnimatedTextKit({
    super.key,
    required this.animatedTexts,
    this.pause = const Duration(milliseconds: 1000),
    this.displayFullTextOnTap = false,
    this.stopPauseOnTap = false,
    this.onTap,
    this.onNext,
    this.onNextBeforePause,
    this.onFinished,
    this.isRepeatingAnimation = true,
    this.totalRepeatCount = 3,
    this.repeatForever = false,
  })  : assert(animatedTexts.length > 0),
        assert(!isRepeatingAnimation || totalRepeatCount > 0 || repeatForever),
        assert(null == onFinished || !repeatForever);

  @override
  AnimatedTextKitState createState() => AnimatedTextKitState();
}

class AnimatedTextKitState extends State<AnimatedTextKit>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late AnimatedText _currentAnimatedText;

  int _currentRepeatCount = 0;

  int _index = 0;

  bool _isCurrentlyPausing = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completeText = _currentAnimatedText.completeText(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: _isCurrentlyPausing || !_controller.isAnimating
          ? completeText
          : AnimatedBuilder(
              animation: _controller,
              builder: _currentAnimatedText.animatedBuilder,
              child: completeText,
            ),
    );
  }

  bool get _isLast => _index == widget.animatedTexts.length - 1;

  void _nextAnimation() {
    final isLast = _isLast;

    _isCurrentlyPausing = false;

    widget.onNext?.call(_index, isLast);

    if (isLast) {
      if (widget.isRepeatingAnimation &&
          (widget.repeatForever ||
              _currentRepeatCount != (widget.totalRepeatCount - 1))) {
        _index = 0;
        if (!widget.repeatForever) {
          _currentRepeatCount++;
        }
      } else {
        widget.onFinished?.call();
        return;
      }
    } else {
      _index++;
    }

    if (mounted) setState(() {});

    _controller.dispose();

    _initAnimation();
  }

  void _initAnimation() {
    _currentAnimatedText = widget.animatedTexts[_index];

    _controller = AnimationController(
      duration: _currentAnimatedText.duration,
      vsync: this,
    );

    _currentAnimatedText.initAnimation(_controller);

    _controller
      ..addStatusListener(_animationEndCallback)
      ..forward();
  }

  void _setPause() {
    final isLast = _isLast;

    _isCurrentlyPausing = true;
    if (mounted) setState(() {});

    widget.onNextBeforePause?.call(_index, isLast);
  }

  void _animationEndCallback(AnimationStatus state) {
    if (state == AnimationStatus.completed) {
      _setPause();
      assert(null == _timer || !_timer!.isActive);
      _timer = Timer(widget.pause, _nextAnimation);
    }
  }

  void _onTap() {
    if (widget.displayFullTextOnTap) {
      if (_isCurrentlyPausing) {
        if (widget.stopPauseOnTap) {
          _timer?.cancel();
          _nextAnimation();
        }
      } else {
        final left =
            (_currentAnimatedText.remaining ?? _currentAnimatedText.duration)
                .inMilliseconds;

        _controller.stop();

        _setPause();

        assert(null == _timer || !_timer!.isActive);
        _timer = Timer(
          Duration(
            milliseconds: max(
              widget.pause.inMilliseconds,
              left,
            ),
          ),
          _nextAnimation,
        );
      }
    }

    widget.onTap?.call();
  }
}

class TyperAnimatedText extends AnimatedText {
  final Duration speed;
  final Curve curve;

  TyperAnimatedText(
    String text, {
    super.textAlign,
    super.textStyle,
    this.speed = const Duration(milliseconds: 40),
    this.curve = Curves.linear,
  }) : super(
          text: text,
          duration: speed * text.characters.length,
        );

  late Animation<double> _typingText;

  @override
  Duration get remaining => speed * (textCharacters.length - _typingText.value);

  @override
  void initAnimation(AnimationController controller) {
    _typingText = CurveTween(
      curve: curve,
    ).animate(controller);
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final count =
        (_typingText.value.clamp(0, 1) * textCharacters.length).round();

    assert(count <= textCharacters.length);
    return textWidget(textCharacters.take(count).toString());
  }
}

class TyperAnimatedTextKit extends AnimatedTextKit {
  TyperAnimatedTextKit({
    super.key,
    required List<String> text,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    Duration speed = const Duration(milliseconds: 40),
    super.pause,
    super.displayFullTextOnTap,
    super.stopPauseOnTap,
    super.onTap,
    super.onNext,
    super.onNextBeforePause,
    super.onFinished,
    super.isRepeatingAnimation,
    super.repeatForever = true,
    super.totalRepeatCount,
    Curve curve = Curves.linear,
  }) : super(
          animatedTexts:
              _animatedTexts(text, textAlign, textStyle, speed, curve),
        );

  static List<AnimatedText> _animatedTexts(
    List<String> text,
    TextAlign textAlign,
    TextStyle? textStyle,
    Duration speed,
    Curve curve,
  ) =>
      text
          .map((a) => TyperAnimatedText(
                a,
                textAlign: textAlign,
                textStyle: textStyle,
                speed: speed,
                curve: curve,
              ))
          .toList();
}

class RotateAnimatedText extends AnimatedText {
  final double? transitionHeight;
  final AlignmentGeometry alignment;
  final TextDirection textDirection;
  final bool rotateOut;

  RotateAnimatedText(
    String text, {
    super.textAlign,
    super.textStyle,
    super.duration = const Duration(milliseconds: 2000),
    this.transitionHeight,
    this.alignment = Alignment.center,
    this.textDirection = TextDirection.ltr,
    this.rotateOut = true,
  }) : super(
          text: text,
        );

  late Animation<double> _fadeIn, _fadeOut;
  late Animation<Alignment> _slideIn, _slideOut;

  @override
  void initAnimation(AnimationController controller) {
    final direction = textDirection;

    final inIntervalEnd = rotateOut ? 0.4 : 1.0;

    _slideIn = AlignmentTween(
      begin: Alignment.topCenter.add(alignment).resolve(direction),
      end: Alignment.center.add(alignment).resolve(direction),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, inIntervalEnd, curve: Curves.linear),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, inIntervalEnd, curve: Curves.easeOut),
      ),
    );

    if (rotateOut) {
      _slideOut = AlignmentTween(
        begin: Alignment.center.add(alignment).resolve(direction),
        end: Alignment.bottomCenter.add(alignment).resolve(direction),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.7, 1.0, curve: Curves.linear),
        ),
      );

      _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
        ),
      );
    }
  }

  @override
  Widget completeText(BuildContext context) =>
      rotateOut ? const SizedBox.shrink() : super.completeText(context);

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final fontSize =
        textStyle?.fontSize ?? DefaultTextStyle.of(context).style.fontSize;

    return SizedBox(
      height: transitionHeight ?? (fontSize! * 10 / 3),
      child: AlignTransition(
        alignment: _slideIn.value.y != 0.0 || !rotateOut ? _slideIn : _slideOut,
        child: Opacity(
          opacity: _fadeIn.value != 1.0 || !rotateOut
              ? _fadeIn.value
              : _fadeOut.value,
          child: textWidget(text),
        ),
      ),
    );
  }
}

class RotateAnimatedTextKit extends AnimatedTextKit {
  RotateAnimatedTextKit({
    super.key,
    required List<String> text,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    double? transitionHeight,
    AlignmentGeometry alignment = Alignment.center,
    TextDirection textDirection = TextDirection.ltr,
    Duration duration = const Duration(milliseconds: 2000),
    super.pause = const Duration(milliseconds: 500),
    super.onTap,
    super.onNext,
    super.onNextBeforePause,
    super.onFinished,
    super.isRepeatingAnimation,
    super.totalRepeatCount,
    super.repeatForever,
    super.displayFullTextOnTap,
    super.stopPauseOnTap,
  }) : super(
          animatedTexts: _animatedTexts(
            text,
            textAlign,
            textStyle,
            duration,
            transitionHeight,
            alignment,
            textDirection,
          ),
        );

  static List<AnimatedText> _animatedTexts(
    List<String> text,
    TextAlign textAlign,
    TextStyle? textStyle,
    Duration duration,
    double? transitionHeight,
    AlignmentGeometry alignment,
    TextDirection textDirection,
  ) =>
      text
          .map((a) => RotateAnimatedText(
                a,
                textAlign: textAlign,
                textStyle: textStyle,
                duration: duration,
                transitionHeight: transitionHeight,
                alignment: alignment,
                textDirection: textDirection,
              ))
          .toList();
}

class TypewriterAnimatedText extends AnimatedText {
  static const extraLengthForBlinks = 8;
  final Duration speed;
  final Curve curve;

  final String cursor;

  TypewriterAnimatedText(
    String text, {
    super.textAlign,
    super.textStyle,
    this.speed = const Duration(milliseconds: 30),
    this.curve = Curves.linear,
    this.cursor = '_',
  }) : super(
          text: text,
          duration: speed * (text.characters.length + extraLengthForBlinks),
        );

  late Animation<double> _typewriterText;

  @override
  Duration get remaining =>
      speed *
      (textCharacters.length + extraLengthForBlinks - _typewriterText.value);

  @override
  void initAnimation(AnimationController controller) {
    _typewriterText = CurveTween(
      curve: curve,
    ).animate(controller);
  }

  @override
  Widget completeText(BuildContext context) => RichText(
        text: TextSpan(
          children: [
            TextSpan(text: text),
            TextSpan(
              text: cursor,
              style: const TextStyle(color: Colors.transparent),
            )
          ],
          style: DefaultTextStyle.of(context).style.merge(textStyle),
        ),
        textAlign: textAlign,
      );

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final textLen = textCharacters.length;
    final typewriterValue = (_typewriterText.value.clamp(0, 1) *
            (textCharacters.length + extraLengthForBlinks))
        .round();

    var showCursor = true;
    var visibleString = text;
    if (typewriterValue == 0) {
      visibleString = '';
      showCursor = false;
    } else if (typewriterValue > textLen) {
      showCursor = (typewriterValue - textLen) % 2 == 0;
    } else {
      visibleString = textCharacters.take(typewriterValue).toString();
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: visibleString),
          TextSpan(
            text: cursor,
            style:
                showCursor ? null : const TextStyle(color: Colors.transparent),
          )
        ],
        style: DefaultTextStyle.of(context).style.merge(textStyle),
      ),
      textAlign: textAlign,
    );
  }
}

class TypewriterAnimatedTextKit extends AnimatedTextKit {
  TypewriterAnimatedTextKit({
    super.key,
    required List<String> text,
    TextAlign textAlign = TextAlign.start,
    required TextStyle textStyle,
    Duration speed = const Duration(milliseconds: 30),
    super.pause,
    super.displayFullTextOnTap,
    super.stopPauseOnTap,
    super.onTap,
    super.onNext,
    super.onNextBeforePause,
    super.onFinished,
    super.isRepeatingAnimation,
    super.repeatForever = true,
    super.totalRepeatCount,
    Curve curve = Curves.linear,
  }) : super(
          animatedTexts:
              _animatedTexts(text, textAlign, textStyle, speed, curve),
        );

  static List<AnimatedText> _animatedTexts(
    List<String> text,
    TextAlign textAlign,
    TextStyle textStyle,
    Duration speed,
    Curve curve,
  ) =>
      text
          .map((a) => TypewriterAnimatedText(
                a,
                textAlign: textAlign,
                textStyle: textStyle,
                speed: speed,
                curve: curve,
              ))
          .toList();
}

class ColorizeAnimatedText extends AnimatedText {
  /// The [Duration] of the delay between the apparition of each characters
  ///
  /// By default it is set to 200 milliseconds.
  final Duration speed;

  /// Set the colors for the gradient animation of the text.
  ///
  /// The [List] should contain at least two values of [Color] in it.
  final List<Color> colors;

  /// Specifies the [TextDirection] for animation direction.
  ///
  /// By default it is set to [TextDirection.ltr]
  final TextDirection textDirection;

  ColorizeAnimatedText(
    String text, {
    super.textAlign,
    required TextStyle super.textStyle,
    this.speed = const Duration(milliseconds: 200),
    required this.colors,
    this.textDirection = TextDirection.ltr,
  })  : assert(null != textStyle.fontSize),
        assert(colors.length > 1),
        super(
          text: text,
          duration: speed * text.characters.length,
        );

  late Animation<double> _colorShifter, _fadeIn, _fadeOut;
  // Copy of colors that may be reversed when RTL.
  late List<Color> _colors;

  @override
  void initAnimation(AnimationController controller) {
    // Note: This calculation is the only reason why [textStyle] is required
    final tuning = (300.0 * colors.length) *
        (textStyle!.fontSize! / 24.0) *
        0.75 *
        (textCharacters.length / 15.0);

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.1, curve: Curves.easeOut),
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.9, 1.0, curve: Curves.easeIn),
      ),
    );

    final colorShift = colors.length * tuning;
    final colorTween = textDirection == TextDirection.ltr
        ? Tween<double>(
            begin: 0.0,
            end: colorShift,
          )
        : Tween<double>(
            begin: colorShift,
            end: 0.0,
          );
    _colorShifter = colorTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
      ),
    );

    // With RTL, colors need to be reversed to compensate for colorTween
    // counting down instead of up.
    _colors = textDirection == TextDirection.ltr
        ? colors
        : colors.reversed.toList(growable: false);
  }

  @override
  Widget completeText(BuildContext context) {
    final linearGradient = LinearGradient(colors: _colors).createShader(
      Rect.fromLTWH(0.0, 0.0, _colorShifter.value, 0.0),
    );

    return DefaultTextStyle.merge(
      style: textStyle,
      child: Text(
        text,
        style: TextStyle(foreground: Paint()..shader = linearGradient),
        textAlign: textAlign,
      ),
    );
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return Opacity(
      opacity: _fadeIn.value != 1.0 ? _fadeIn.value : _fadeOut.value,
      child: completeText(context),
    );
  }
}

/// Animation that displays [text] elements, shimmering transition between [colors].
///
/// ![Colorize example](https://raw.githubusercontent.com/aagarwal1012/Animated-Text-Kit/master/display/colorize.gif)
@Deprecated('Use AnimatedTextKit with ColorizeAnimatedText instead.')
class ColorizeAnimatedTextKit extends AnimatedTextKit {
  ColorizeAnimatedTextKit({
    super.key,
    required List<String> text,
    TextAlign textAlign = TextAlign.start,
    TextDirection textDirection = TextDirection.ltr,
    required TextStyle textStyle,
    required List<Color> colors,
    Duration speed = const Duration(milliseconds: 200),
    super.pause,
    super.onTap,
    super.onNext,
    super.onNextBeforePause,
    super.onFinished,
    super.isRepeatingAnimation,
    super.totalRepeatCount,
    super.repeatForever,
    super.displayFullTextOnTap,
    super.stopPauseOnTap,
  }) : super(
          animatedTexts: _animatedTexts(
            text,
            textAlign,
            textStyle,
            speed,
            colors,
            textDirection,
          ),
        );

  static List<AnimatedText> _animatedTexts(
    List<String> text,
    TextAlign textAlign,
    TextStyle textStyle,
    Duration speed,
    List<Color> colors,
    TextDirection textDirection,
  ) =>
      text
          .map((a) => ColorizeAnimatedText(
                a,
                textAlign: textAlign,
                textStyle: textStyle,
                speed: speed,
                colors: colors,
                textDirection: textDirection,
              ))
          .toList();
}

class ScaleAnimatedText extends AnimatedText {
  /// Set the scaling factor of the text for the animation.
  ///
  /// By default it is set to [double] value 0.5
  final double scalingFactor;

  ScaleAnimatedText(
    String text, {
    super.textAlign,
    super.textStyle,
    super.duration = const Duration(milliseconds: 2000),
    this.scalingFactor = 0.5,
  }) : super(
          text: text,
        );

  late Animation<double> _fadeIn, _fadeOut, _scaleIn, _scaleOut;

  @override
  void initAnimation(AnimationController controller) {
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _scaleIn = Tween<double>(begin: scalingFactor, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _scaleOut = Tween<double>(begin: 1.0, end: scalingFactor).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  Widget completeText(BuildContext context) => const SizedBox.shrink();

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return ScaleTransition(
      scale: _scaleIn.value != 1.0 ? _scaleIn : _scaleOut,
      child: Opacity(
        opacity: _fadeIn.value != 1.0 ? _fadeIn.value : _fadeOut.value,
        child: textWidget(text),
      ),
    );
  }
}

/// Animation that displays [text] elements, scaling them up and then out, one at a time.
///
/// ![Scale example](https://raw.githubusercontent.com/aagarwal1012/Animated-Text-Kit/master/display/scale.gif)
@Deprecated('Use AnimatedTextKit with ScaleAnimatedText instead.')
class ScaleAnimatedTextKit extends AnimatedTextKit {
  ScaleAnimatedTextKit({
    super.key,
    required List<String> text,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    double scalingFactor = 0.5,
    Duration duration = const Duration(milliseconds: 2000),
    super.pause = const Duration(milliseconds: 500),
    super.onTap,
    super.onNext,
    super.onNextBeforePause,
    super.onFinished,
    super.isRepeatingAnimation,
    super.totalRepeatCount,
    super.repeatForever,
    super.displayFullTextOnTap,
    super.stopPauseOnTap,
  }) : super(
          animatedTexts: _animatedTexts(
            text,
            textAlign,
            textStyle,
            duration,
            scalingFactor,
          ),
        );

  static List<AnimatedText> _animatedTexts(
    List<String> text,
    TextAlign textAlign,
    TextStyle? textStyle,
    Duration duration,
    double scalingFactor,
  ) =>
      text
          .map((a) => ScaleAnimatedText(
                a,
                textAlign: textAlign,
                textStyle: textStyle,
                duration: duration,
                scalingFactor: scalingFactor,
              ))
          .toList();
}

class TextLiquidFill extends StatefulWidget {
  /// Gives [TextStyle] to the text string.
  ///
  /// By default it is `TextStyle(fontSize: 140, fontWeight: FontWeight.bold)`
  final TextStyle textStyle;

  /// Gives [TextAlign] to the text string.
  ///
  /// By default it is [TextAlign.left].
  final TextAlign textAlign;

  /// Specifies the duration the text should fill with liquid.
  ///
  /// By default it is set to 6 seconds.
  final Duration loadDuration;

  /// Specifies the duration that one wave takes to pass the screen.
  ///
  /// By default it is set to 2 seconds.
  final Duration waveDuration;

  /// Specifies the height of the box around text
  ///
  /// By default it is set to 250
  final double boxHeight;

  /// Specifies the width of the box around text
  ///
  /// By default it is set to 400
  final double boxWidth;

  /// String which would be filled by liquid animation
  final String text;

  /// Specifies the backgroundColor of the box
  ///
  /// By default it is set to black color
  final Color boxBackgroundColor;

  /// Specifies the color of the wave
  ///
  /// By default it is set to blueAccent color
  final Color waveColor;

  /// Specifies the load limit: (0, 1.0].  This may be used to limit the liquid
  /// fill effect to less than 100%.
  ///
  /// By default, the animation will load to 1.0 (100%).
  final double loadUntil;

  const TextLiquidFill({
    super.key,
    required this.text,
    this.textStyle =
        const TextStyle(fontSize: 140, fontWeight: FontWeight.bold),
    this.textAlign = TextAlign.left,
    this.loadDuration = const Duration(seconds: 6),
    this.waveDuration = const Duration(seconds: 2),
    this.boxHeight = 250,
    this.boxWidth = 400,
    this.boxBackgroundColor = Colors.black,
    this.waveColor = Colors.blueAccent,
    this.loadUntil = 1.0,
  }) : assert(loadUntil > 0 && loadUntil <= 1.0);

  /// Creates the mutable state for this widget. See [StatefulWidget.createState].
  @override
  TextLiquidFillState createState() => TextLiquidFillState();
}

class TextLiquidFillState extends State<TextLiquidFill>
    with TickerProviderStateMixin {
  final _textKey = GlobalKey();

  late AnimationController _waveController, _loadController;

  late Animation<double> _loadValue;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );

    _loadController = AnimationController(
      vsync: this,
      duration: widget.loadDuration,
    );
    _loadValue = Tween<double>(
      begin: 0.0,
      end: widget.loadUntil,
    ).animate(_loadController);
    if (1.0 == widget.loadUntil) {
      _loadValue.addStatusListener((status) {
        if (AnimationStatus.completed == status) {
          // Stop the repeating wave when the load has completed to 100%
          _waveController.stop();
        }
      });
    }

    _waveController.repeat();
    _loadController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _loadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: widget.boxHeight,
          width: widget.boxWidth,
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: _WavePainter(
                  textKey: _textKey,
                  waveValue: _waveController.value,
                  loadValue: _loadValue.value,
                  boxHeight: widget.boxHeight,
                  waveColor: widget.waveColor,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: widget.boxHeight,
          width: widget.boxWidth,
          child: ShaderMask(
            blendMode: BlendMode.srcOut,
            shaderCallback: (bounds) => LinearGradient(
              colors: [widget.boxBackgroundColor],
              stops: const [0.0],
            ).createShader(bounds),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Text(
                  widget.text,
                  key: _textKey,
                  style: widget.textStyle,
                  textAlign: widget.textAlign,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  static const _pi2 = 2 * pi;
  final GlobalKey textKey;
  final double waveValue;
  final double loadValue;
  final double boxHeight;
  final Color waveColor;

  _WavePainter({
    required this.textKey,
    required this.waveValue,
    required this.loadValue,
    required this.boxHeight,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RenderBox textBox =
        textKey.currentContext!.findRenderObject() as RenderBox;
    final textHeight = textBox.size.height;
    final baseHeight =
        (boxHeight / 2) + (textHeight / 2) - (loadValue * textHeight);

    final width = size.width;
    final height = size.height;
    final path = Path();
    path.moveTo(0.0, baseHeight);
    for (var i = 0.0; i < width; i++) {
      path.lineTo(i, baseHeight + sin(_pi2 * (i / width + waveValue)) * 8);
    }

    path.lineTo(width, height);
    path.lineTo(0.0, height);
    path.close();
    final wavePaint = Paint()..color = waveColor;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class WavyAnimatedText extends AnimatedText {
  /// The [Duration] of the motion of each character
  ///
  /// By default it is set to 300 milliseconds.
  final Duration speed;

  WavyAnimatedText(
    String text, {
    super.textAlign,
    super.textStyle,
    this.speed = const Duration(milliseconds: 300),
  }) : super(
          text: text,
          duration: speed * text.characters.length,
        );

  late Animation<double> _waveAnim;

  @override
  void initAnimation(AnimationController controller) {
    _waveAnim = Tween<double>(begin: 0, end: textCharacters.length / 2 + 0.52)
        .animate(controller);
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final defaultTextStyle = DefaultTextStyle.of(context).style;
    final textScaler = MediaQuery.of(context).textScaler;
    return RepaintBoundary(
      child: CustomPaint(
        painter: _WTextPainter(
          progress: _waveAnim.value,
          text: text,
          textStyle: defaultTextStyle.merge(textStyle),
          textScaler: textScaler,
        ),
        child: Text(
          text,
          style: defaultTextStyle
              .merge(textStyle)
              .merge(const TextStyle(color: Colors.transparent)),
          textScaler: textScaler,
        ),
      ),
    );
  }
}

/// Animation that displays [text] elements, with each text animated with its
/// characters popping like a stadium wave.
///
/// ![Wavy example](https://raw.githubusercontent.com/aagarwal1012/Animated-Text-Kit/master/display/wavy.gif)
@Deprecated('Use AnimatedTextKit with WavyAnimatedText instead.')
class WavyAnimatedTextKit extends AnimatedTextKit {
  WavyAnimatedTextKit({
    super.key,
    required List<String> text,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    Duration speed = const Duration(milliseconds: 300),
    super.pause,
    super.onTap,
    super.onNext,
    super.onNextBeforePause,
    super.onFinished,
    super.isRepeatingAnimation,
    super.totalRepeatCount,
    super.repeatForever = true,
    super.displayFullTextOnTap,
    super.stopPauseOnTap,
  }) : super(
          animatedTexts: _animatedTexts(text, textAlign, textStyle, speed),
        );

  static List<AnimatedText> _animatedTexts(
    List<String> text,
    TextAlign textAlign,
    TextStyle? textStyle,
    Duration speed,
  ) =>
      text
          .map((a) => WavyAnimatedText(
                a,
                textAlign: textAlign,
                textStyle: textStyle,
                speed: speed,
              ))
          .toList();
}

class _WTextPainter extends CustomPainter {
  _WTextPainter({
    required this.progress,
    required this.text,
    required this.textStyle,
    required this.textScaler,
  });

  final double progress;
  final TextScaler textScaler;
  final String text;
  // Private class to store text information
  final _textLayoutInfo = <_TextLayoutInfo>[];
  final TextStyle textStyle;
  @override
  void paint(Canvas canvas, Size size) {
    if (_textLayoutInfo.isEmpty) {
      // calculate the initial position of each char
      calculateLayoutInfo(text, _textLayoutInfo);
    }
    canvas.save();

    for (var textLayout in _textLayoutInfo) {
      // offset required to center the characters
      final centerOffset =
          Offset(size.width / 2, (size.height / 2 - textLayout.height / 2));

      if (textLayout.isMoving) {
        final p = min(progress * 2, 1.0);
        // drawing the char if the text is moving
        drawText(
            canvas,
            textLayout.text,
            Offset(
                  textLayout.offsetX,
                  (textLayout.offsetY -
                      (textLayout.offsetY - textLayout.riseHeight) * p),
                ) +
                centerOffset,
            textLayout);
      } else {
        // drawing the char if text is not moving
        drawText(
          canvas,
          textLayout.text,
          Offset(textLayout.offsetX, textLayout.offsetY) + centerOffset,
          textLayout,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WTextPainter oldDelegate) {
    if (oldDelegate.progress != progress) {
      // calulate layout of text and movement of moving chars
      calculateLayoutInfo(text, _textLayoutInfo);
      calculateMove();
      return true;
    }
    return false;
  }

  void calculateMove() {
    final height = _textLayoutInfo[0].height;
    final txtInMoInd = progress.floor();
    final percent = progress - txtInMoInd;
    final txtInMoOdd = (progress - .5).floor();
    final txtInMoEven = txtInMoInd * 2;

    // Calculating movement of the char at odd place
    if (txtInMoOdd < (text.length - 1) / 2 && !txtInMoOdd.isNegative) {
      _textLayoutInfo[txtInMoOdd + (txtInMoOdd + 1)].isMoving = true;
      // percent < .5 creates an phase difference between odd and even chars
      _textLayoutInfo[txtInMoOdd + (txtInMoOdd + 1)].riseHeight =
          progress < .5 ? 0 : -1.3 * height * sin((progress - .5) * pi).abs();
    }

    // Calculating movement of the char at even place
    if (txtInMoEven < text.length) {
      _textLayoutInfo[txtInMoEven].isMoving = true;
      _textLayoutInfo[txtInMoEven].riseHeight =
          -1.3 * height * sin(percent * pi);
    }
  }

  void drawText(Canvas canvas, String text, Offset offset,
      _TextLayoutInfo textLayoutInfo) {
    var textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        offset.dx - textLayoutInfo.width / 2,
        offset.dy + (textLayoutInfo.height - textPainter.height) / 2,
      ),
    );
  }

  void calculateLayoutInfo(String text, List<_TextLayoutInfo> list) {
    list.clear();

    // creating a textPainter to get data about location and offset for chars
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      textScaler: textScaler,
    );

    textPainter.layout();
    for (var i = 0; i < text.length; i++) {
      var forCaret = textPainter.getOffsetForCaret(
        TextPosition(offset: i),
        Rect.zero,
      );
      var offsetX = forCaret.dx;
      if (i > 0 && offsetX == 0) {
        break;
      }

      // creating layout for each char
      final textLayoutInfo = _TextLayoutInfo(
        text: text[i],
        offsetX: offsetX,
        offsetY: forCaret.dy,
        width: textPainter.width,
        height: textPainter.height,
        baseline: textPainter
            .computeDistanceToActualBaseline(TextBaseline.ideographic),
      );

      list.add(textLayoutInfo);
    }
  }
}

class _TextLayoutInfo {
  final String text;
  final double offsetX;
  final double offsetY;
  final double width;
  final double height;
  final double baseline;
  late double riseHeight;
  bool isMoving = false;

  _TextLayoutInfo({
    required this.text,
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
    required this.baseline,
  });
}

class FlickerAnimatedText extends AnimatedText {
  /// Marks ending of flickering entry interval of text
  final double entryEnd;
  final Duration speed;

  FlickerAnimatedText(
    String text, {
    TextAlign textAlign = TextAlign.start,
    super.textStyle,
    this.speed = const Duration(milliseconds: 1600),
    this.entryEnd = 0.5,
  }) : super(
          text: text,
          duration: speed,
        );

  late Animation<double> _entry;

  @override
  void initAnimation(AnimationController controller) {
    _entry = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, entryEnd, curve: Curves.bounceIn),
      ),
    );
  }

  @override
  Widget completeText(BuildContext context) => const SizedBox.shrink();

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return Opacity(
      opacity: _entry.value != 1.0 ? _entry.value : _entry.value,
      child: textWidget(text),
    );
  }
}

@Deprecated('Use AnimatedTextKit with FlickerAnimatedText instead.')
class FlickerAnimatedTextKit extends AnimatedTextKit {
  FlickerAnimatedTextKit({
    super.key,
    required List<String> text,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    TextDirection textDirection = TextDirection.ltr,
    Duration speed = const Duration(milliseconds: 1600),
    double entryEnd = 0.5,
    super.onTap,
    super.onNext,
    super.onNextBeforePause,
    super.onFinished,
    super.isRepeatingAnimation,
    super.totalRepeatCount,
    super.repeatForever,
    super.displayFullTextOnTap,
    super.stopPauseOnTap,
  }) : super(
          animatedTexts:
              _animatedTexts(text, textAlign, textStyle, speed, entryEnd),
        );

  static List<AnimatedText> _animatedTexts(
    List<String> text,
    TextAlign textAlign,
    TextStyle? textStyle,
    Duration speed,
    double entryEnd,
  ) =>
      text
          .map((a) => FlickerAnimatedText(
                a,
                textAlign: textAlign,
                textStyle: textStyle,
                speed: speed,
                entryEnd: entryEnd,
              ))
          .toList();
}

class FadeAnimatedText extends AnimatedText {
  /// Marks ending of fade-in interval, default value = 0.5
  final double fadeInEnd;

  /// Marks the beginning of fade-out interval, default value = 0.8
  final double fadeOutBegin;
  FadeAnimatedText(
    String text, {
    super.textAlign,
    super.textStyle,
    super.duration = const Duration(milliseconds: 2000),
    this.fadeInEnd = 0.5,
    this.fadeOutBegin = 0.8,
  })  : assert(fadeInEnd < fadeOutBegin,
            'The "fadeInEnd" argument must be less than "fadeOutBegin"'),
        super(
          text: text,
        );

  late Animation<double> _fadeIn, _fadeOut;

  @override
  void initAnimation(AnimationController controller) {
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, fadeInEnd, curve: Curves.linear),
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(fadeOutBegin, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  Widget completeText(BuildContext context) => const SizedBox.shrink();

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return Opacity(
      opacity: _fadeIn.value != 1.0 ? _fadeIn.value : _fadeOut.value,
      child: textWidget(text),
    );
  }
}

class FadeAnimatedTextKit extends AnimatedTextKit {
  FadeAnimatedTextKit({
    super.key,
    required List<String> text,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    Duration duration = const Duration(milliseconds: 2000),
    super.pause = const Duration(milliseconds: 500),
    double fadeInEnd = 0.5,
    double fadeOutBegin = 0.8,
    super.onTap,
    super.onNext,
    super.onNextBeforePause,
    super.onFinished,
    super.isRepeatingAnimation,
    super.totalRepeatCount,
    super.repeatForever,
    super.displayFullTextOnTap,
    super.stopPauseOnTap,
  }) : super(
          animatedTexts: _animatedTexts(
              text, textAlign, textStyle, duration, fadeInEnd, fadeOutBegin),
        );

  static List<AnimatedText> _animatedTexts(
    List<String> text,
    TextAlign textAlign,
    TextStyle? textStyle,
    Duration duration,
    double fadeInEnd,
    double fadeOutBegin,
  ) =>
      text
          .map((a) => FadeAnimatedText(
                a,
                textAlign: textAlign,
                textStyle: textStyle,
                duration: duration,
                fadeInEnd: fadeInEnd,
                fadeOutBegin: fadeOutBegin,
              ))
          .toList();
}

class TextRich extends StatelessWidget {
  const TextRich(
    this.textSpan, {
    super.key,
    this.locale,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign = TextAlign.left,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
  });

  final InlineSpan textSpan;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textSpan,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class Texts extends StatelessWidget {
  const Texts(
    this.data, {
    super.key,
    this.padding = EdgeInsets.zero,
    this.fontWeight = FontWeight.w500,
    this.color = const Color(0xFF757575),
    this.textAlign = TextAlign.center,
    this.overflow,
    this.maxLines,
    this.fontSize,
    this.textScaler,
  });

  final String? data;
  final EdgeInsetsGeometry padding;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextScaler? textScaler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        '$data',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
        textAlign: textAlign,
        textScaler: textScaler,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
}

InlineSpan span({
  String? text,
  List<InlineSpan>? children,
  GestureRecognizer? recognizer,
  MouseCursor? mouseCursor,
  void Function(PointerEnterEvent)? onEnter,
  void Function(PointerExitEvent)? onExit,
  String? semanticsLabel,
  bool inherit = true,
  Color? color = const Color(0xFF757575),
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight = FontWeight.w500,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  TextLeadingDistribution? leadingDistribution,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  String? debugLabel,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  String? package,
}) {
  return TextSpan(
    text: text,
    children: children,
    recognizer: recognizer,
    onEnter: onEnter,
    onExit: onExit,
    semanticsLabel: semanticsLabel,
    style: TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
    ),
  );
}
