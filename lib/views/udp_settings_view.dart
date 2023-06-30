import 'package:flutter/material.dart';
import 'package:moss/styles.dart';
import 'package:moss/view_models.dart';

class UdpSettingsView extends StatefulWidget {
  const UdpSettingsView({super.key});

  @override
  State<UdpSettingsView> createState() => _UdpSettingsViewState();
}

class _UdpSettingsViewState extends State<UdpSettingsView> {
  late final UdpSettingsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = UdpSettingsViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: kViewSpacing),
            child: ValueListenableBuilder<String>(
              valueListenable: viewModel.remoteHost,
              builder: (context, remoteHost, child) {
                return TextFormField(
                  decoration: InputDecoration(
                    labelText: '远程地址',
                  ),
                  initialValue: remoteHost,
                  onChanged: (value) {},
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: kViewSpacing),
            child: ValueListenableBuilder<int>(
              valueListenable: viewModel.remotePort,
              builder: (context, remotePort, child) {
                return TextFormField(
                  decoration: InputDecoration(
                    labelText: '远程端口',
                  ),
                  initialValue: remotePort.toString(),
                  onChanged: (value) {},
                );
              },
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: viewModel.localPort,
            builder: (context, localPort, child) {
              return TextFormField(
                decoration: InputDecoration(
                  labelText: '本地端口',
                ),
                initialValue: localPort.toString(),
                onChanged: (value) {},
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
