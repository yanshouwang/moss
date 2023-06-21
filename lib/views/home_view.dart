import 'dart:convert';

import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import '../view_models.dart';
import '../views.dart';
import '../widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final HomeViewModel viewModel;
  late final AnimationController xsToSController;
  late final AnimationController sToMController;
  late final Animation<double> topAnimation;
  late final Animation<double> bottomLeftAnimation;
  late final Animation<double> topWriteAnimation;
  late final Animation<double> bottomWriteAnimation;

  @override
  void initState() {
    super.initState();

    viewModel = HomeViewModel();
    xsToSController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1250),
    );
    sToMController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1250),
    );
    topAnimation = CurvedAnimation(
      parent: xsToSController,
      // 0ms -> 400ms
      curve: const Interval(0 / 5, 2 / 5),
      // 0ms -> 750ms
      reverseCurve: const Interval(0 / 5, 3 / 5),
    );
    bottomLeftAnimation = CurvedAnimation(
      parent: xsToSController,
      // 400ms -> 1000ms
      curve: const Interval(2 / 5, 5 / 5),
      // 750ms -> 1250ms
      reverseCurve: const Interval(3 / 5, 5 / 5),
    );
    topWriteAnimation = CurvedAnimation(
      parent: sToMController,
      curve: const Interval(2 / 5, 5 / 5),
    );
    bottomWriteAnimation = CurvedAnimation(
      parent: sToMController,
      curve: const Interval(0 / 5, 2 / 5),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // TODO: 目前为 Material 2 定义，需要等待官方 M3 插件或使用 MediaQuery 实现
    // https://m2.material.io/design/layout/responsive-layout-grid.html#breakpoints
    // https://m3.material.io/foundations/layout/applying-layout/window-size-classes
    // https://github.com/material-foundation/flutter-packages/issues/402

    // XS -> 0-599
    // S -> 600-1023
    // M -> 1024-1439
    // L -> 1440-1919
    // XL -> 1920+

    final windowType = getWindowType(context);
    // XS -> S
    final xsToSStatus = xsToSController.status;
    if (windowType > AdaptiveWindowType.xsmall) {
      if (xsToSStatus != AnimationStatus.forward &&
          xsToSStatus != AnimationStatus.completed) {
        xsToSController.forward();
      }
    } else {
      if (xsToSStatus != AnimationStatus.reverse &&
          xsToSStatus != AnimationStatus.dismissed) {
        xsToSController.reverse();
      }
    }
    // S -> M
    final sToMStatus = sToMController.status;
    if (windowType > AdaptiveWindowType.small) {
      if (sToMStatus != AnimationStatus.forward &&
          sToMStatus != AnimationStatus.completed) {
        sToMController.forward();
      }
    } else {
      if (sToMStatus != AnimationStatus.reverse &&
          sToMStatus != AnimationStatus.dismissed) {
        sToMController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTopView(context),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildBottomLeftView(context),
                  Expanded(
                    child: buildBottomRightView(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopView(BuildContext context) {
    final theme = Theme.of(context);
    return TopTransition(
      timeline: topAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: spacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: buildCommunicationTypeView(context),
            ),
            const SizedBox(width: spacing),
            Row(
              children: [
                ValueListenableBuilder<CommunicationState>(
                  valueListenable: viewModel.communicationState,
                  builder: (context, state, child) {
                    final isConnected = state == CommunicationState.connected;
                    return FilledButton(
                      onPressed: () {
                        if (isConnected) {
                          viewModel.disconnect();
                        } else {
                          viewModel.connect();
                        }
                      },
                      style: FilledButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(16.0),
                            right: Radius.circular(4.0),
                          ),
                        ),
                        backgroundColor: isConnected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceVariant,
                        foregroundColor: isConnected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      child: Icon(
                        isConnected
                            ? Icons.sentiment_satisfied_outlined
                            : Icons.sentiment_dissatisfied_outlined,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 2.0),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(4.0),
                        right: Radius.circular(16.0),
                      ),
                    ),
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    foregroundColor: theme.colorScheme.onSurfaceVariant,
                  ),
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomLeftView(BuildContext context) {
    final theme = Theme.of(context);
    final direction = Directionality.of(context);
    return BottomLeftTransition(
      timeline: bottomLeftAnimation,
      child: Container(
        margin: direction == TextDirection.ltr
            ? const EdgeInsets.only(right: spacing)
            : const EdgeInsets.only(left: spacing),
        width: 200.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildCommunicationTypeView(context),
            const SizedBox(height: spacing),
            buildCommunicationSettingsView(context),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: viewModel.communicationState,
              builder: (context, state, child) {
                final isConnected = state == CommunicationState.connected;
                return OutlinedButton(
                  onPressed: () {
                    if (isConnected) {
                      viewModel.disconnect();
                    } else {
                      viewModel.connect();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        isConnected ? theme.colorScheme.primary : null,
                    foregroundColor:
                        isConnected ? theme.colorScheme.onPrimary : null,
                  ),
                  child: Text(isConnected ? '断开' : '连接'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomRightView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: buildLogsView(context),
        ),
        buildWirteView(context),
      ],
    );
  }

  Widget buildCommunicationTypeView(BuildContext context) {
    final items = viewModel.communicationTypes.map((type) {
      return DropdownMenuItem(
        value: type,
        child: Text(type.text),
      );
    }).toList();
    return Form(
      child: ValueListenableBuilder<CommunicationType>(
        valueListenable: viewModel.communicationType,
        builder: (context, communicationType, child) {
          return DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: '通讯方式',
            ),
            items: items,
            value: communicationType,
            onChanged: (value) {},
          );
        },
      ),
    );
  }

  Widget buildCommunicationSettingsView(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel.communicationType,
      builder: (context, communicationType, child) {
        switch (communicationType) {
          case CommunicationType.udp:
            return const UdpSettingsView();
          default:
            throw ArgumentError.value(communicationType);
        }
      },
    );
  }

  Widget buildLogsView(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: '日志',
      ),
      child: ValueListenableBuilder<List<String>>(
        valueListenable: viewModel.receivedMessages,
        builder: (context, notifiedMessages, child) {
          return ListView.builder(
            itemBuilder: (context, i) {
              final message = notifiedMessages[i];
              return Text(message);
            },
            itemCount: notifiedMessages.length,
          );
        },
      ),
    );
  }

  Widget buildWirteView(BuildContext context) {
    final direction = Directionality.of(context);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                // controller: writeMessageController,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  labelText: '输入指令',
                ),
              ),
            ),
            TopWriteTransition(
              animation: topWriteAnimation,
              child: Container(
                margin: direction == TextDirection.ltr
                    ? const EdgeInsets.only(top: spacing, left: spacing)
                    : const EdgeInsets.only(top: spacing, right: spacing),
                width: 400.0,
                child: buildWriteControllerView(context),
              ),
            ),
          ],
        ),
        BottomWriteTransition(
          animation: bottomWriteAnimation,
          child: Container(
            margin: const EdgeInsets.only(top: spacing),
            child: buildWriteControllerView(context),
          ),
        ),
      ],
    );
  }

  Widget buildWriteControllerView(BuildContext context) {
    final encodings = viewModel.encodings.map((encoding) {
      return DropdownMenuItem(
        value: encoding,
        child: Text(encoding.name),
      );
    }).toList();
    final endSymbols = viewModel.endSymbols.map((endSymbol) {
      return DropdownMenuItem(
        value: endSymbol,
        child: Text(endSymbol.text),
      );
    }).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ValueListenableBuilder<Encoding>(
            valueListenable: viewModel.encoding,
            builder: (context, encoding, child) {
              return DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: '编码方式',
                ),
                items: encodings,
                value: encoding,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  viewModel.setEncoding(value);
                },
              );
            },
          ),
        ),
        const SizedBox(width: spacing),
        Expanded(
          child: ValueListenableBuilder<EndSymbol>(
            valueListenable: viewModel.endSymbol,
            builder: (context, endSymbol, child) {
              return DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: '结束符',
                ),
                items: endSymbols,
                value: endSymbol,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  viewModel.setEndSymbol(value);
                },
              );
            },
          ),
        ),
        const SizedBox(width: spacing),
        FilledButton(
          onPressed: () {
            // final message = writeMessageController.text;
            // viewModel.write(message);
          },
          child: Text('发送'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    xsToSController.dispose();
    sToMController.dispose();
    super.dispose();
  }
}

extension on CommunicationType {
  String get text {
    switch (this) {
      case CommunicationType.udp:
        return 'UDP';
      case CommunicationType.tcp:
        return 'TCP';
      case CommunicationType.serial:
        return '串口';
      case CommunicationType.bluetoothLowEnergy:
        return '低功耗蓝牙';
      default:
        throw ArgumentError.value(this);
    }
  }
}

extension on EndSymbol {
  String get text {
    switch (this) {
      case EndSymbol.none:
        return '';
      case EndSymbol.cr:
        return r'\r';
      case EndSymbol.lf:
        return r'\n';
      case EndSymbol.crLF:
        return r'\r\n';
      case EndSymbol.nul:
        return r'\0';
      default:
        throw ArgumentError.value(this);
    }
  }
}
