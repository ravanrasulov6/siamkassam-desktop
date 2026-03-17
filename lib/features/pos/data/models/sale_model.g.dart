// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSaleModelCollection on Isar {
  IsarCollection<SaleModel> get saleModels => this.collection();
}

const SaleModelSchema = CollectionSchema(
  name: r'SaleModel',
  id: 8410161235942925352,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customerId': PropertySchema(
      id: 1,
      name: r'customerId',
      type: IsarType.string,
    ),
    r'customerName': PropertySchema(
      id: 2,
      name: r'customerName',
      type: IsarType.string,
    ),
    r'discount': PropertySchema(
      id: 3,
      name: r'discount',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'items': PropertySchema(
      id: 5,
      name: r'items',
      type: IsarType.objectList,
      target: r'SaleItemModel',
    ),
    r'paymentMethod': PropertySchema(
      id: 6,
      name: r'paymentMethod',
      type: IsarType.string,
    ),
    r'subtotal': PropertySchema(
      id: 7,
      name: r'subtotal',
      type: IsarType.double,
    ),
    r'syncStatus': PropertySchema(
      id: 8,
      name: r'syncStatus',
      type: IsarType.byte,
      enumMap: _SaleModelsyncStatusEnumValueMap,
    ),
    r'total': PropertySchema(
      id: 9,
      name: r'total',
      type: IsarType.double,
    )
  },
  estimateSize: _saleModelEstimateSize,
  serialize: _saleModelSerialize,
  deserialize: _saleModelDeserialize,
  deserializeProp: _saleModelDeserializeProp,
  idName: r'localId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'SaleItemModel': SaleItemModelSchema},
  getId: _saleModelGetId,
  getLinks: _saleModelGetLinks,
  attach: _saleModelAttach,
  version: '3.1.0+1',
);

int _saleModelEstimateSize(
  SaleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.customerId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.items.length * 3;
  {
    final offsets = allOffsets[SaleItemModel]!;
    for (var i = 0; i < object.items.length; i++) {
      final value = object.items[i];
      bytesCount +=
          SaleItemModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.paymentMethod.length * 3;
  return bytesCount;
}

void _saleModelSerialize(
  SaleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.customerId);
  writer.writeString(offsets[2], object.customerName);
  writer.writeDouble(offsets[3], object.discount);
  writer.writeString(offsets[4], object.id);
  writer.writeObjectList<SaleItemModel>(
    offsets[5],
    allOffsets,
    SaleItemModelSchema.serialize,
    object.items,
  );
  writer.writeString(offsets[6], object.paymentMethod);
  writer.writeDouble(offsets[7], object.subtotal);
  writer.writeByte(offsets[8], object.syncStatus.index);
  writer.writeDouble(offsets[9], object.total);
}

SaleModel _saleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SaleModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.customerId = reader.readStringOrNull(offsets[1]);
  object.customerName = reader.readStringOrNull(offsets[2]);
  object.discount = reader.readDouble(offsets[3]);
  object.id = reader.readString(offsets[4]);
  object.items = reader.readObjectList<SaleItemModel>(
        offsets[5],
        SaleItemModelSchema.deserialize,
        allOffsets,
        SaleItemModel(),
      ) ??
      [];
  object.localId = id;
  object.paymentMethod = reader.readString(offsets[6]);
  object.subtotal = reader.readDouble(offsets[7]);
  object.syncStatus =
      _SaleModelsyncStatusValueEnumMap[reader.readByteOrNull(offsets[8])] ??
          SyncStatus.synced;
  object.total = reader.readDouble(offsets[9]);
  return object;
}

P _saleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readObjectList<SaleItemModel>(
            offset,
            SaleItemModelSchema.deserialize,
            allOffsets,
            SaleItemModel(),
          ) ??
          []) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (_SaleModelsyncStatusValueEnumMap[reader.readByteOrNull(offset)] ??
          SyncStatus.synced) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SaleModelsyncStatusEnumValueMap = {
  'synced': 0,
  'pendingInsert': 1,
  'pendingUpdate': 2,
  'conflict': 3,
};
const _SaleModelsyncStatusValueEnumMap = {
  0: SyncStatus.synced,
  1: SyncStatus.pendingInsert,
  2: SyncStatus.pendingUpdate,
  3: SyncStatus.conflict,
};

Id _saleModelGetId(SaleModel object) {
  return object.localId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _saleModelGetLinks(SaleModel object) {
  return [];
}

void _saleModelAttach(IsarCollection<dynamic> col, Id id, SaleModel object) {
  object.localId = id;
}

extension SaleModelByIndex on IsarCollection<SaleModel> {
  Future<SaleModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  SaleModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<SaleModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<SaleModel?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(SaleModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(SaleModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<SaleModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<SaleModel> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension SaleModelQueryWhereSort
    on QueryBuilder<SaleModel, SaleModel, QWhere> {
  QueryBuilder<SaleModel, SaleModel, QAfterWhere> anyLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SaleModelQueryWhere
    on QueryBuilder<SaleModel, SaleModel, QWhereClause> {
  QueryBuilder<SaleModel, SaleModel, QAfterWhereClause> localIdEqualTo(
      Id localId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: localId,
        upper: localId,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterWhereClause> localIdNotEqualTo(
      Id localId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: localId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: localId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: localId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: localId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterWhereClause> localIdGreaterThan(
      Id localId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: localId, includeLower: include),
      );
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterWhereClause> localIdLessThan(
      Id localId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: localId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterWhereClause> localIdBetween(
    Id lowerLocalId,
    Id upperLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerLocalId,
        includeLower: includeLower,
        upper: upperLocalId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SaleModelQueryFilter
    on QueryBuilder<SaleModel, SaleModel, QFilterCondition> {
  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerId',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerId',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerId',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerName',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerName',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> customerNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> discountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> discountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> discountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> discountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> itemsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> itemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> itemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> itemsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      itemsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> itemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> localIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localId',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> localIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localId',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> localIdEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> localIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> localIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> localIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      paymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> subtotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> subtotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> subtotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> subtotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> syncStatusEqualTo(
      SyncStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition>
      syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> totalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> totalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> totalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> totalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'total',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension SaleModelQueryObject
    on QueryBuilder<SaleModel, SaleModel, QFilterCondition> {
  QueryBuilder<SaleModel, SaleModel, QAfterFilterCondition> itemsElement(
      FilterQuery<SaleItemModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'items');
    });
  }
}

extension SaleModelQueryLinks
    on QueryBuilder<SaleModel, SaleModel, QFilterCondition> {}

extension SaleModelQuerySortBy on QueryBuilder<SaleModel, SaleModel, QSortBy> {
  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension SaleModelQuerySortThenBy
    on QueryBuilder<SaleModel, SaleModel, QSortThenBy> {
  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QAfterSortBy> thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension SaleModelQueryWhereDistinct
    on QueryBuilder<SaleModel, SaleModel, QDistinct> {
  QueryBuilder<SaleModel, SaleModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SaleModel, SaleModel, QDistinct> distinctByCustomerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QDistinct> distinctByCustomerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QDistinct> distinctByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discount');
    });
  }

  QueryBuilder<SaleModel, SaleModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QDistinct> distinctByPaymentMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleModel, SaleModel, QDistinct> distinctBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtotal');
    });
  }

  QueryBuilder<SaleModel, SaleModel, QDistinct> distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<SaleModel, SaleModel, QDistinct> distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }
}

extension SaleModelQueryProperty
    on QueryBuilder<SaleModel, SaleModel, QQueryProperty> {
  QueryBuilder<SaleModel, int, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<SaleModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SaleModel, String?, QQueryOperations> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<SaleModel, String?, QQueryOperations> customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<SaleModel, double, QQueryOperations> discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discount');
    });
  }

  QueryBuilder<SaleModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SaleModel, List<SaleItemModel>, QQueryOperations>
      itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'items');
    });
  }

  QueryBuilder<SaleModel, String, QQueryOperations> paymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMethod');
    });
  }

  QueryBuilder<SaleModel, double, QQueryOperations> subtotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtotal');
    });
  }

  QueryBuilder<SaleModel, SyncStatus, QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<SaleModel, double, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SaleItemModelSchema = Schema(
  name: r'SaleItemModel',
  id: -7082026101599657679,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.string,
    ),
    r'price': PropertySchema(
      id: 1,
      name: r'price',
      type: IsarType.double,
    ),
    r'productId': PropertySchema(
      id: 2,
      name: r'productId',
      type: IsarType.string,
    ),
    r'productName': PropertySchema(
      id: 3,
      name: r'productName',
      type: IsarType.string,
    ),
    r'quantity': PropertySchema(
      id: 4,
      name: r'quantity',
      type: IsarType.double,
    ),
    r'total': PropertySchema(
      id: 5,
      name: r'total',
      type: IsarType.double,
    )
  },
  estimateSize: _saleItemModelEstimateSize,
  serialize: _saleItemModelSerialize,
  deserialize: _saleItemModelDeserialize,
  deserializeProp: _saleItemModelDeserializeProp,
);

int _saleItemModelEstimateSize(
  SaleItemModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.productId.length * 3;
  bytesCount += 3 + object.productName.length * 3;
  return bytesCount;
}

void _saleItemModelSerialize(
  SaleItemModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.id);
  writer.writeDouble(offsets[1], object.price);
  writer.writeString(offsets[2], object.productId);
  writer.writeString(offsets[3], object.productName);
  writer.writeDouble(offsets[4], object.quantity);
  writer.writeDouble(offsets[5], object.total);
}

SaleItemModel _saleItemModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SaleItemModel();
  object.id = reader.readString(offsets[0]);
  object.price = reader.readDouble(offsets[1]);
  object.productId = reader.readString(offsets[2]);
  object.productName = reader.readString(offsets[3]);
  object.quantity = reader.readDouble(offsets[4]);
  object.total = reader.readDouble(offsets[5]);
  return object;
}

P _saleItemModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SaleItemModelQueryFilter
    on QueryBuilder<SaleItemModel, SaleItemModel, QFilterCondition> {
  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      productNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      quantityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      quantityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      quantityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      quantityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      totalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      totalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      totalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleItemModel, SaleItemModel, QAfterFilterCondition>
      totalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'total',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension SaleItemModelQueryObject
    on QueryBuilder<SaleItemModel, SaleItemModel, QFilterCondition> {}
