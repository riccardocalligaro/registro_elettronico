import 'package:flutter_test/flutter_test.dart';
import 'package:registro_elettronico/data/repository/mapper/note_mapper.dart';
import 'package:registro_elettronico/domain/entity/api_responses/notes_response.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';

void main() {
  group('Notes', () {
    final note1 = Note(
      authorName: "John Doe",
      evtDate: '2019-11-24',
      readStatus: false,
      evtId: 1,
      warningType: "Not happy",
      extText: "Bad student!",
    );

    test('conversion to db entity', () {
      final note = NoteMapper().convertNotetEntityToInsertable(
          note1, RegistroConstants.DISCIPLINARY_NOTE);
      expect(note1.authorName, note.author);
      expect(RegistroConstants.DISCIPLINARY_NOTE, note.type);
      expect(DateTime.utc(2019, 11, 24), note.date);
    });
  });
}
