class TypeModel {
  bool? fix;
  bool? notFix;
  TypeModel({this.fix, this.notFix});

  TypeModel fromJson(json) =>
      TypeModel(fix: json["fix"], notFix: json["not-fix"]);
}
