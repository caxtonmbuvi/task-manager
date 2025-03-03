import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemedPage extends StatelessWidget {
  const ThemedPage({
    super.key,
    this.appBar,
    required this.body,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.automaticallyImplyLeading,
    this.leading,
    this.elevation,
    this.centerTitle,
    this.hasAppBarShadow = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool? automaticallyImplyLeading;
  final Widget? leading;
  final double? elevation;
  final bool? centerTitle;
  final bool hasAppBarShadow;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    final statusBarBrightness =
        ThemeData.estimateBrightnessForColor(effectiveBackgroundColor);
    final statusBarIconBrightness = statusBarBrightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: effectiveBackgroundColor,
      statusBarIconBrightness: statusBarIconBrightness,
      systemNavigationBarColor: effectiveBackgroundColor,
      systemNavigationBarIconBrightness: statusBarIconBrightness,
    );

    Widget? effectiveLeading;
    if (appBar is AppBar) {
      final appbarLeading = (appBar! as AppBar).leading;
      effectiveLeading = appbarLeading ?? leading;
    } else {
      effectiveLeading = leading;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        appBar: appBar != null
            ? (hasAppBarShadow
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: appBarBackgroundColor ??
                            Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: AppBar(
                        systemOverlayStyle: overlayStyle,
                        title: (appBar as AppBar?)?.title,
                        centerTitle: (appBar as AppBar?)?.centerTitle,
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: automaticallyImplyLeading ??
                            (appBar is AppBar &&
                                (appBar! as AppBar).automaticallyImplyLeading),
                        leading: effectiveLeading,
                        leadingWidth: (appBar as AppBar?)?.leadingWidth,
                        elevation: 0,
                        actions: (appBar as AppBar?)?.actions,
                      ),
                    ),
                  )
                : PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: AppBar(
                      systemOverlayStyle: overlayStyle,
                      title: (appBar as AppBar?)?.title,
                      centerTitle: (appBar as AppBar?)?.centerTitle,
                      backgroundColor:
                          appBarBackgroundColor ?? Theme.of(context).cardColor,
                      automaticallyImplyLeading: automaticallyImplyLeading ??
                          (appBar is AppBar &&
                              (appBar! as AppBar).automaticallyImplyLeading),
                      leading: effectiveLeading,
                      leadingWidth: (appBar as AppBar?)?.leadingWidth,
                      elevation: elevation ?? 0,
                      actions: (appBar as AppBar?)?.actions,
                    ),
                ))
            : null,
        body: SafeArea(child: body),
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation:
            floatingActionButtonLocation ?? FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
