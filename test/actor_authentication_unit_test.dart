import 'package:filmpal/utilities/actor_validation.dart';
import 'package:test/test.dart';

void main() {
  group('isActorValid', () {
    test('Returns true when actor is valid', () {
      // Arrange
      String? knownForDepartment = 'Acting';
      String? actorName = 'Johnny Depp';
      String? query = 'Tom Hanks';

      // Act
      bool result = isActorValid(knownForDepartment, actorName, query);

      // Assert
      expect(result, true);
      if (result) {
        print('Test passed: Actor is valid.');
      }
    });

    test('Returns false when knownForDepartment is not Acting', () {
      // Arrange
      String? knownForDepartment = 'Directing';
      String? actorName = 'Christopher Nolan';
      String? query = 'Christopher Nolan';

      // Act
      bool result = isActorValid(knownForDepartment, actorName, query);

      // Assert
      expect(result, false);
      if (!result) {
        print('Test passed: Known for department is not Acting.');
      }
    });

    test('Returns false when actorName is null', () {
      // Arrange
      String? knownForDepartment = 'Acting';
      String? actorName = null;
      String? query = 'Meryl Streep';

      // Act
      bool result = isActorValid(knownForDepartment, actorName, query);

      // Assert
      expect(result, false);
      if (!result) {
        print('Test passed: Actor name is null.');
      }
    });

    test('Returns false when actorName is same as query', () {
      // Arrange
      String? knownForDepartment = 'Acting';
      String? actorName = 'Leonardo DiCaprio';
      String? query = 'Leonardo DiCaprio';

      // Act
      bool result = isActorValid(knownForDepartment, actorName, query);

      // Assert
      expect(result, false);
      if (!result) {
        print('Test passed: Actor name is same as query.');
      }
    });
  });
}
