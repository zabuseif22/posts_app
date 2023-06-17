import 'package:dartz/dartz.dart';
import 'package:mobile_number/sim_card.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/MapModel.dart';
import '../entites/map_entites.dart';
import '../repositores/map_repository.dart';

class GetMapAllInfoUseCase {
  late final MapRepository mapRepository;

  GetMapAllInfoUseCase(this.mapRepository);

  Future<Either<Failure, String>> call() async {
    return await mapRepository.getJsonByAssets();
  }

  Future<Either<Failure, List<MapEn>>> callProp() async {
    return await mapRepository.getJsonProp();
  }

  Future<Either<Failure, List<SimCard>>> callSimCard() async {
    return await mapRepository.getTypeSimCard();
  }
}
