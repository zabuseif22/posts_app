class MapModel {
  String type;
  List<GeoJSONFeature> features;

  MapModel({
    required this.type,
    required this.features,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      type: json['type'],
      features: List<GeoJSONFeature>.from(
        json['features'].map((feature) => GeoJSONFeature.fromJson(feature)),
      ),
    );
  }
}

class GeoJSONFeature {
  String type;
  int id;
  Geometry geometry;
  Properties properties;

  GeoJSONFeature({
    required this.type,
    required this.id,
    required this.geometry,
    required this.properties,
  });

  factory GeoJSONFeature.fromJson(Map<String, dynamic> json) {
    return GeoJSONFeature(
      type: json['type'],
      id: json['id'],
      geometry: Geometry.fromJson(json['geometry']),
      properties: Properties.fromJson(json['properties']),
    );
  }
}

class Geometry {
  String type;
  List<List<List<double>>> coordinates;

  Geometry({
    required this.type,
    required this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: List<List<List<double>>>.from(
        json['coordinates'].map((coord) {
          return List<List<double>>.from(
            coord.map((subCoord) {
              return List<double>.from(
                subCoord.map((value) => value.toDouble()),
              );
            }),
          );
        }),
      ),
    );
  }
}

class Properties {
  int? oBJECTID;
  String? serviceProvider;
  int? inPolyFID;
  int? simPgnFlag;
  double? maxSimpTol;
  double? minSimpTol;
  double? shapeLength;
  double? shapeArea;

  Properties(
      {this.oBJECTID,
      this.serviceProvider,
      this.inPolyFID,
      this.simPgnFlag,
      this.maxSimpTol,
      this.minSimpTol,
      this.shapeLength,
      this.shapeArea});

  Properties.fromJson(Map<String, dynamic> json) {
    oBJECTID = json['OBJECTID'];
    serviceProvider = json['ServiceProvider'];
    inPolyFID = json['InPoly_FID'];
    simPgnFlag = json['SimPgnFlag'];
    maxSimpTol = json['MaxSimpTol'];
    minSimpTol = json['MinSimpTol'];
    shapeLength = json['Shape_Length'];
    shapeArea = json['Shape_Area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OBJECTID'] = this.oBJECTID;
    data['ServiceProvider'] = this.serviceProvider;
    data['InPoly_FID'] = this.inPolyFID;
    data['SimPgnFlag'] = this.simPgnFlag;
    data['MaxSimpTol'] = this.maxSimpTol;
    data['MinSimpTol'] = this.minSimpTol;
    data['Shape_Length'] = this.shapeLength;
    data['Shape_Area'] = this.shapeArea;
    return data;
  }
}
