import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'models.dart';
import 'models/data.dart';
import 'views.dart';
import 'widgets.dart';
import 'widgets/transitions/list_detail_transition.dart';
import 'widgets/animated_floating_action_button.dart';
import 'widgets/disappearing_bottom_navigation_bar.dart';
import 'widgets/disappearing_navigation_rail.dart';
import 'widgets/email_list_view.dart';
import 'widgets/reply_list_view.dart';

const minWindowSize = Size(400.0, 600.0);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('MOSS');
    setWindowMinSize(minWindowSize);
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          theme: ThemeData.from(
            colorScheme: lightDynamic ??
                ColorScheme.fromSeed(
                  brightness: Brightness.light,
                  seedColor: Colors.red,
                ),
          ).customize(),
          darkTheme: ThemeData.from(
            colorScheme: lightDynamic ??
                ColorScheme.fromSeed(
                  brightness: Brightness.light,
                  seedColor: Colors.red,
                ),
          ).customize(),
          home: const HomeView(),
          // home: Feed(currentUser: user_0),
          debugShowCheckedModeBanner: false,
          // debugShowMaterialGrid: true,
        );
      },
    );
  }
}

extension on ThemeData {
  ThemeData customize() {
    return copyWith(
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        // border: OutlineInputBorder(),
        border: OutlineInputBorder(),
        // fillColor: colorScheme.surface,
        // filled: true,
      ),
    );
  }
}

class Feed extends StatefulWidget {
  const Feed({
    super.key,
    required this.currentUser,
  });

  final User currentUser;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);
  late final _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1250),
      value: 0,
      vsync: this);
  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);
  late final _barAnimation = BarAnimation(parent: _controller);

  int selectedIndex = 0;
  bool controllerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = _controller.status;
    if (width > 600) {
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      _controller.value = width > 600 ? 1 : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: Row(
            children: [
              DisappearingNavigationRail(
                railAnimation: _railAnimation,
                railFabAnimation: _railFabAnimation,
                selectedIndex: selectedIndex,
                backgroundColor: _backgroundColor,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              Expanded(
                child: Container(
                  color: _backgroundColor,
                  child: ListDetailTransition(
                    animation: _railAnimation,
                    one: EmailListView(
                      selectedIndex: selectedIndex,
                      onSelected: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      currentUser: widget.currentUser,
                    ),
                    two: const ReplyListView(),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: AnimatedFloatingActionButton(
            animation: _barAnimation,
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: DisappearingBottomNavigationBar(
            barAnimation: _barAnimation,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
