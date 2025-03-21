import 'package:baixa_tube/ui/controllers/home_controller.dart';
import 'package:elevarm_ui/elevarm_ui.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 400,
            height: 400,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Baixa Tube',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Digite a URL',
                  ),
                  controller: controller.urlController,
                ),
                const SizedBox(height: 20),
                ElevarmPrimaryButton.icon(
                  onPressed: () {
                    controller.download();
                  },
                  text: 'Baixar',
                  leadingIconAssetName: HugeIcons.strokeRoundedDownload01,
                  trailingIconAssetName: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
