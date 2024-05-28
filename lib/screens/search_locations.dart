import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchLocations extends StatefulWidget {
  const SearchLocations({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SearchLocations();
  }
}

class _SearchLocations extends State<SearchLocations> {
  late GoogleMapController mapController;
  TextEditingController addressController = TextEditingController();
  LatLng _center = const LatLng(37.7749, -122.4194); // Default to San Francisco

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Address Input'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
              });
            },
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              color: Colors.white,
              child: TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Enter Address',
                  contentPadding: const EdgeInsets.all(12.0),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      String address = addressController.text;
                      List<Location> locations =
                          await locationFromAddress(address);
                      if (locations.isNotEmpty) {
                        setState(() {
                          _center = LatLng(
                              locations[0].latitude, locations[0].longitude);
                        });
                        mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(_center, 15.0),
                        );
                      } else {
                        // Handle invalid address or no results
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'No results found for the address.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
