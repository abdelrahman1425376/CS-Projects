import 'package:class_manager/core/utils/enums.dart';

class Resource {
  final String url;
  final String title;
  final ResourceTypeEnum type;

  Resource({required this.url, required this.title, required this.type});

  factory Resource.fromJson(Map<String, dynamic> json) {
    ResourceTypeEnum resourceType;
    final typeString = (json['type'] as String? ?? '').toLowerCase();
    switch (typeString) {
      case 'photo':
        resourceType = ResourceTypeEnum.photo;
        break;
      case 'video':
        resourceType = ResourceTypeEnum.video;
        break;
      case 'website':
        resourceType = ResourceTypeEnum.website;
        break;
      default:
        resourceType = ResourceTypeEnum.photo;
    }

    return Resource(
      url: json['url'] ?? '',
      title: json['title'] ?? '',
      type: resourceType,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'title': title, 'type': type.name};
  }

  Resource copyWith({String? url, String? title, ResourceTypeEnum? type}) {
    return Resource(
      url: url ?? this.url,
      title: title ?? this.title,
      type: type ?? this.type,
    );
  }
}
