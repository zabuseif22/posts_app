import 'package:dartz/dartz.dart';
import 'package:mobile_number/sim_card.dart';
import '../../../../core/errors/failures.dart';
import '../entites/map_entites.dart';

abstract class MapRepository {
  Future<Either<Failure, String>> getJsonByAssets();
  Future<Either<Failure, List<MapEn>>> getJsonProp();
  Future<Either<Failure, List<SimCard>>> getTypeSimCard();
}
