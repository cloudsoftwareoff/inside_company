import 'package:flutter/material.dart';

import 'package:inside_company/model/region.dart';
import 'package:inside_company/services/firestore/regiondb.dart';

class RegionListView extends StatefulWidget {
  final void Function(Region?) onRegionSelected;

  const RegionListView({Key? key, required this.onRegionSelected})
      : super(key: key);

  @override
  _RegionListViewState createState() => _RegionListViewState();
}

class _RegionListViewState extends State<RegionListView> {
  Region? selectedRegion;
  List<Region> regions = []; // Store the Regions list locally

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Region>?>(
      future: RegionDB().fetchRegion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('No Regions found.'),
          );
        } else {
          regions =
              snapshot.data!; // Assign the Regions list from the snapshot data
          return Center(
            child: DropdownButton<String>(
              value: selectedRegion?.id,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRegion =
                      regions.firstWhere((Region) => Region.id == newValue);
                });
                widget.onRegionSelected(
                    selectedRegion); // Notify the parent widget about the selected Region
              },
              items: regions.map((Region region) {
                return DropdownMenuItem<String>(
                  value: region.id,
                  child: Text(
                    region.name,
                    style: TextStyle(
                        color: Colors.black, backgroundColor: Colors.white38),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
