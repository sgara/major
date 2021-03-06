import 'package:major_graphql_generator/src/builders/schema/print_type.dart';
import 'package:major_graphql_generator/src/schema/schema.dart';
import 'package:major_graphql_generator/src/builders/schema/print_enums.dart';
import 'package:major_graphql_generator/src/builders/schema/print_interface.dart';
import 'package:major_graphql_generator/src/builders/schema/print_object_type.dart';
import 'package:major_graphql_generator/src/builders/schema/print_input_type.dart';
import 'package:major_graphql_generator/src/builders/schema/print_union.dart';
import 'package:major_graphql_generator/src/builders/utils.dart';

String printSchema(GraphQLSchema schema, String serializersUniqueName) {
  final serializables = schema.typeMap.values
      .map((t) => className(t.name))
      .where((name) => !typeConfig.scalars.keys.map(className).contains(name));
  return format('''
  // Enums
  ${schema.enums.map(printEnum).join('\n')}

  // Interfaces
  ${schema.interaces.map((i) => printInterface(i, schema.getPossibleTypes(i))).join('\n')}

  // Object Types
  ${schema.objectTypes.map(printObjectType).join('\n')}

  // Unions
  ${schema.unions.map(printUnion).join('\n')}

  // Inputs
  ${schema.inputObjectTypes.map(printInputObjectType).join('\n')}


  const ${serializersUniqueName} = <Type>[${serializables.toSet().join(',')}];

  ${moduleSerializers(serializersUniqueName)}

  ${ignoreLints}
  ''');
}
