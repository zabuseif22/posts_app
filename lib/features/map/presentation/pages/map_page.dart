import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:posts_app/core/errors/failures.dart';
import 'package:posts_app/features/map/data/models/MapModel.dart';
import 'package:posts_app/features/map/presentation/cubit/propart_cubit.dart';
import 'package:posts_app/features/map/presentation/cubit/sim_card_cubit.dart';
import 'package:posts_app/features/map/presentation/widgets/flutter_map_widget.dart';
import 'package:posts_app/features/posts/presentation/widgets/loading_widget.dart';
import '../cubit/map_cubit.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String selectedItem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text('Map Compass Coverage'),
    );
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(builder: (context, state) {
      if (state is LoadingMapState) {
        return const LoadingWidget();
      } else if (state is LoadedMapState) {
        return Center(
            child: _buildMap(
                state.myGeoJson,
                state.currentLocation!,
                state.distanceUnit!,
                state.nearestLatitude,
                state.nearestLongitude,
                state.nearestDistance,
                state.previousLocation));
      } else if (state is ErrorMapState) {
        return Center(
          child: Text(state.message),
        );
      }

      return Text(ServerFailure().toString());
    });
  }

  _buildMap(
      dynamic myGeoJson,
      Position currentLocation,
      String distanceUnit,
      double? nearestLatitude,
      double? nearestLongitude,
      double? nearestDistance,
      Position? previousLocation) {
    return Column(
      children: [
        _dropdownNetworkPlayer(),
        _cardDetails(previousLocation, nearestDistance, distanceUnit),
        AspectRatio(
          aspectRatio: 0.77,
          child: MapWidget(
            myGeoJson: myGeoJson,
            nearestLatitude: nearestLatitude!,
            nearestLongitude: nearestLongitude!,
            currentLocation: currentLocation,
          ),
        ),

      ],
    );
  }

  _cardDetails(Position? previousLocation, double? nearestDistance,
      String distanceUnit) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 12,
          child: Card(
            color: Colors.white,
            elevation: 1,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'OldLoc ${previousLocation!.latitude} ${previousLocation.longitude}',
                  style:
                      const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                ),
                Text('Distance: $nearestDistance/$distanceUnit',
                    style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.bold))
              ],
            )),
          )),
    );
  }

  _dropdownNetworkPlayer() {
    return BlocBuilder<SimCardCubit, SimCardState>(
      builder: (context, simCardState) {
        if (simCardState is LoadedSimCardState) {
          return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 12,
                  color: Colors.white,
                  child: DropdownButton<String>(
                    value: selectedItem,
                    hint: const Text(
                      'Select Provider Network',
                      style: TextStyle(color: Colors.blue),
                    ),

                    onChanged: (newValue) {
                      selectedItem = newValue!;
                      List<String> providers = ['stc', 'mobily', 'zain'];
                      Random random = Random();
                      String randomProvider =
                          providers[random.nextInt(providers.length)];
                      BlocProvider.of<MapCubit>(context).myString =
                          randomProvider;

                    },
                    items: simCardState.list.map((item) {
                      return DropdownMenuItem<String>(
                        value: selectedItem,
                        child: Text(
                          item.carrierName.toString(),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      );
                    }).toList(),

                    style: const TextStyle(
                      fontSize: 16.0, // Adjust the font size
                      color: Colors.black, // Adjust the font color
                    ),
                    // Customize the dropdown button's underline
                    underline: Container(
                      height: 1.0, // Adjust the underline height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.redAccent,
                      ), // Adjust the underline color
                    ),

                    // Customize the dropdown button's border radius
                    icon: const Icon(
                        Icons.arrow_drop_down), // Customize the dropdown icon
                    dropdownColor:
                        Colors.white, // Customize the dropdown menu color
                    elevation: 2,
                  )));
        }
        return const Text('no data dropdown ');
      },
    );
  }
}
// this is callback that gets executed when user taps the marker
