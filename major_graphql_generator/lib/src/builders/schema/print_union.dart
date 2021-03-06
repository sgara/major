import 'package:major_graphql_generator/src/schema/schema.dart';
import 'package:major_graphql_generator/src/builders/schema/print_type.dart';
import 'package:major_graphql_generator/src/builders/utils.dart';

String printUnion(UnionTypeDefinition unionType) {
  if (!shouldGenerate(unionType.name)) {
    return '';
  }

  final optionsTemplate = ListPrinter(items: unionType.typeNames);

  final GETTERS = optionsTemplate
      .map((option) => [
            nullable(),
            printType(option).type,
            'get',
            dartName('as ' + option.name),
          ])
      .semicolons;

  final VALUE = optionsTemplate
      .map((option) => [dartName('as ' + option.name)])
      .copyWith(divider: '??');

  /*
  final ARGUMENTS = fieldsTemplate
      .map((field) => [
            if (field.type.isNonNull) '@required',
            printType(field.type),
            dartName(field.name),
          ])
  */

  final built = builtClass(className(unionType.name), body: '''
      $GETTERS

      Object get value => $VALUE;
  ''');

  return format('''

    ${docstring(unionType.description, '')}
    /// Union Type of${optionsTemplate.map((o) => [' [${printType(o)}]'])}
    ${built}
  ''');
}
