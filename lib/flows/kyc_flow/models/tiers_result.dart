import 'dart:convert';
import 'dart:typed_data';

class Tier {
  Tier({
    this.id,
    this.level,
    this.name,
    this.status,
    this.requirements,
  });

  int id;
  int level;
  String name;
  RequirementStatus status;
  List<Requirement> requirements;

  factory Tier.fromRawJson(String str) => Tier.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static List<Tier> listFromJson(List<dynamic> list) =>
      list.map((json) => Tier.fromJson(json)).toList();

  static Tier fromJson(Map<String, dynamic> json) => Tier(
        id: json["id"] == null ? null : json["id"],
        level: json["level"] == null ? null : json["level"],
        name: json["name"] == null ? null : json["name"],
        status:
            json["status"] == null ? null : requirementStatus[json["status"]],
        requirements: json["requirements"] == null
            ? null
            : List<Requirement>.from(
                json["requirements"].map((x) => Requirement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "level": level == null ? null : level,
        "name": name == null ? null : name,
        "status": status == null
            ? null
            : requirementStatus.keys
                .firstWhere((k) => requirementStatus[k] == status),
        "requirements": requirements == null
            ? null
            : List<dynamic>.from(requirements.map((x) => x.toJson())),
      };
}

enum RequirementStatus {
  notFilled,
  approved,
  notAvailable,
  canceled,
  waiting,
  pending,
}

final Map<String, RequirementStatus> requirementStatus = {
  'not-filled': RequirementStatus.notFilled,
  'approved': RequirementStatus.approved,
  'not-available': RequirementStatus.notAvailable,
  'canceled': RequirementStatus.canceled,
  'waiting': RequirementStatus.waiting,
  'pending': RequirementStatus.pending,
};

class Requirement {
  Requirement({
    this.id,
    this.name,
    this.status,
    this.elements,
  });

  int id;
  String name;
  RequirementStatus status;
  List<Element> elements;

  factory Requirement.fromRawJson(String str) =>
      Requirement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Requirement.fromJson(Map<String, dynamic> json) => Requirement(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        status:
            json["status"] == null ? null : requirementStatus[json["status"]],
        elements: json["elements"] == null
            ? null
            : List<Element>.from(
                json["elements"].map((x) => Element.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "status": status == null
            ? null
            : requirementStatus.keys
                .firstWhere((k) => requirementStatus[k] == status),
        "elements": elements == null
            ? null
            : List<dynamic>.from(elements.map((x) => x.toJson())),
      };
}

enum ElementIndex {
  email,
  fullName,
  phone,
  dateBirth,
  motherMaidenMame,
  type,
  selfiePhoto,
  scanned,
  number,
  scannedIdentification,
  identificationType,
  identificationNumber
}

final Map<String, ElementIndex> elementIndexs = {
  'email': ElementIndex.email,
  'full_name': ElementIndex.fullName,
  'phone': ElementIndex.phone,
  'date_birth': ElementIndex.dateBirth,
  'mother_maiden_mame': ElementIndex.motherMaidenMame,
  'type': ElementIndex.type,
  'selfie_photo': ElementIndex.selfiePhoto,
  'scanned': ElementIndex.scanned,
  'number': ElementIndex.number,
  'identification_scanned': ElementIndex.scannedIdentification,
  'identification_type': ElementIndex.identificationType,
  'identification_number': ElementIndex.identificationNumber,
};

enum ElementType {
  input,
  date,
  options,
}

final Map<String, ElementType> elementTypes = {
  'input': ElementType.input,
  'date': ElementType.date,
  'options': ElementType.options,
};

class Element {
  Element({
    this.index,
    this.name,
    this.type,
    this.value,
    this.options,
    this.bytes,
  });

  ElementIndex index;
  String name;
  ElementType type;
  String value;
  Uint8List bytes;
  List<Option> options;

  factory Element.fromRawJson(String str) => Element.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        index: json["index"] == null ? null : elementIndexs[json["index"]],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : elementTypes[json["type"]],
        value: json["value"] == null ? null : json["value"],
        options: json["options"] == null
            ? null
            : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "index": index == null
            ? null
            : elementIndexs.keys.firstWhere((k) => elementIndexs[k] == index),
        "name": name == null ? null : name,
        "type": type == null
            ? null
            : elementTypes.keys.firstWhere((k) => elementTypes[k] == type),
        "value": value == null ? null : value,
        "options": options == null
            ? null
            : List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  Option({
    this.name,
    this.value,
  });

  String name;
  String value;

  factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        name: json["name"] == null ? null : json["name"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "value": value == null ? null : value,
      };
}
