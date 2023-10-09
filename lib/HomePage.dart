import 'package:flutter/material.dart';
import 'package:jweltryapp/face_mesh_detector_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "JwelTry",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 1,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FaceMeshDetectorView(),
                    ),
                  );
                },
                child: const Text("Try Jewellery on",style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}
