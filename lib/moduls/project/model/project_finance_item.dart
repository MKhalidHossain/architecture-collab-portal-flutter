class ProjectFinanceItem {
  String? id;
  String? type;
  String? customId;
  ProjectFinanceClient? client;
  String? createdBy;
  List<ProjectFinanceLineItem> lineItems;
  num? subtotal;
  num? taxRate;
  num? taxAmount;
  num? discount;
  num? totalAmount;
  DateTime? issueDate;
  DateTime? dueDate;
  String? status;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProjectFinanceItem({
    this.id,
    this.type,
    this.customId,
    this.client,
    this.createdBy,
    this.lineItems = const <ProjectFinanceLineItem>[],
    this.subtotal,
    this.taxRate,
    this.taxAmount,
    this.discount,
    this.totalAmount,
    this.issueDate,
    this.dueDate,
    this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory ProjectFinanceItem.fromJson(Map<String, dynamic> json) {
    return ProjectFinanceItem(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      customId: json['customId'] as String?,
      client: json['client'] is Map
          ? ProjectFinanceClient.fromJson(
              Map<String, dynamic>.from(json['client'] as Map),
            )
          : null,
      createdBy: json['createdBy'] as String?,
      lineItems: ProjectFinanceLineItem.fromJsonList(json['lineItems']),
      subtotal: json['subtotal'] as num?,
      taxRate: json['taxRate'] as num?,
      taxAmount: json['taxAmount'] as num?,
      discount: json['discount'] as num?,
      totalAmount: json['totalAmount'] as num?,
      issueDate: _parseDateValue(json, const ['issueDate', 'issuedDate', 'issue_date']),
      dueDate: _parseDateValue(json, const ['dueDate', 'due_date']),
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'customId': customId,
      'client': client?.toJson(),
      'createdBy': createdBy,
      'lineItems': lineItems.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'discount': discount,
      'totalAmount': totalAmount,
      'issueDate': issueDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'status': status,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static List<ProjectFinanceItem> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .whereType<Map>()
          .map(
            (item) => ProjectFinanceItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }
    return <ProjectFinanceItem>[];
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.tryParse(value.toString());
  }

  static DateTime? _parseDateValue(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      if (json.containsKey(key)) {
        final parsed = _parseDate(json[key]);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return null;
  }
}

class ProjectFinanceClient {
  String? id;
  String? name;
  String? email;

  ProjectFinanceClient({this.id, this.name, this.email});

  factory ProjectFinanceClient.fromJson(Map<String, dynamic> json) {
    return ProjectFinanceClient(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}

class ProjectFinanceLineItem {
  String? description;
  num? quantity;
  num? rate;
  num? amount;

  ProjectFinanceLineItem({
    this.description,
    this.quantity,
    this.rate,
    this.amount,
  });

  factory ProjectFinanceLineItem.fromJson(Map<String, dynamic> json) {
    return ProjectFinanceLineItem(
      description: json['description'] as String?,
      quantity: json['quantity'] as num?,
      rate: json['rate'] as num?,
      amount: json['amount'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'rate': rate,
      'amount': amount,
    };
  }

  static List<ProjectFinanceLineItem> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .whereType<Map>()
          .map(
            (item) => ProjectFinanceLineItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }
    return <ProjectFinanceLineItem>[];
  }
}
