import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARViewWidget extends StatelessWidget {
  final String alt, modelUrl;
  ARViewWidget({super.key, required this.alt, required this.modelUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ModelViewer(
        backgroundColor: Colors.transparent,
        src: 'assets/images/old_chair.glb',
        alt: alt,
        ar: true,
        autoRotate: true,
        iosSrc: 'assets/images/old_chair.glb',
        disableZoom: true,
      ),
    );
  }
}
