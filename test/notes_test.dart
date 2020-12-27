import 'package:flutter_test/flutter_test.dart';
import 'package:registro_elettronico/feature/notes/data/model/note_mapper.dart';
import 'package:registro_elettronico/feature/notes/data/model/remote/note_remote_model.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';

void main() {
  group('Notes', () {
    final note1 = NoteRemoteModel(
      authorName: "John Doe",
      evtDate: '2019-11-24',
      readStatus: false,
      evtId: 1,
      warningType: "Not happy",
      extText: "Bad student!",
    );

    test('conversion to db entity', () {
      final note = NoteMapper.convertNotetEntityToInsertable(
          note1, RegistroConstants.DISCIPLINARY_NOTE);
      expect(note1.authorName, note.author);
      expect(RegistroConstants.DISCIPLINARY_NOTE, note.type);
      expect(DateTime.utc(2019, 11, 24), note.date);
    });
  });
}
