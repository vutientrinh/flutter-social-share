import 'package:json_annotation/json_annotation.dart';

part 'picture.g.dart';

@JsonSerializable()
class Picture {
  @JsonKey(name: 'url', includeIfNull: false)
  final String? url;

  @JsonKey(name: 'org_width', includeIfNull: false)
  final int? orgWidth;

  @JsonKey(name: 'org_height', includeIfNull: false)
  final int? orgHeight;

  @JsonKey(name: 'org_url', includeIfNull: false)
  final String? orgUrl;

  @JsonKey(name: 'cloud_name', includeIfNull: false)
  final String? cloudName;

  Picture(
      {this.url, this.orgWidth, this.orgHeight, this.orgUrl, this.cloudName});

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);

  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
