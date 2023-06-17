import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_number/sim_card.dart';
import 'package:posts_app/core/errors/failures.dart';
import 'package:posts_app/features/map/data/datasources/geo_json_datasource.dart';
import 'package:posts_app/features/map/domain/entites/map_entites.dart';
import 'package:posts_app/features/map/domain/repositores/map_repository.dart';
import '../../../../core/errors/exception.dart';
import '../models/MapModel.dart';

class MapRepositoryImp implements MapRepository {
  late final GeoJsonDataSource geoJsonDataSource;
  MapRepositoryImp({required this.geoJsonDataSource});

  @override
  Future<Either<Failure, String>> getJsonByAssets() async {
    try {
      final getJsonData = await geoJsonDataSource.getGeoJsonDataAssets();

      return Right(getJsonData);
    } on ServerException {
      return Left(FileFailure());
    }
  }

  @override
  Future<Either<Failure, List<MapEn>>> getJsonProp() async {
    try {
      final getJsonData = await geoJsonDataSource.getGeoJsonDataProp();

      return Right(getJsonData);
    } on ServerException {
      return Left(FileFailure());
    }
  }

  @override
  Future<Either<Failure, List<SimCard>>> getTypeSimCard()async {

    try {
      final getSimCard = await geoJsonDataSource.getSimCardType();

      return Right(getSimCard);
    } on ServerException {
      return Left(FileFailure());
    }
  }
}
