import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/scientific_session_datasource.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_roles.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_post_model.dart';
import 'package:elogbook/src/data/models/scientific_session/session_types_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'scientific_session_state.dart';

class ScientificSessionCubit extends Cubit<ScientifcSessionState> {
  final ScientificSessionDataSource ds;

  ScientificSessionCubit({
    required this.ds,
  }) : super(ScientifcSessionState());

  void reset() {
    emit(state.copyWith(attachment: null));
  }

  Future<void> getListSessionTypes() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await ds.getListSessionTypes();

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(listSessionTypes: r)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> uploadAttachment({required String path}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await ds.uploadScientificSessionAttachment(filePath: path);

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(attachment: r)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> downloadAttachment(
      {required String id, required String filename}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await ds.downloadFile(crId: id, filename: filename);

      emit(state.copyWith(attachment: result));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getScientificSessionRoles() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await ds.getListScientificRoles();

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) {
        print(r.length);
        emit(state.copyWith(scientificRoles: r));
      });
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> uploadScientificSession(
      {required ScientificSessionPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await ds.uploadScientificSession(scientificSessionPostModel: model);

      result.fold(
          (l) => emit(
                state.copyWith(requestState: RequestState.error),
              ), (r) {
        return emit(
          state.copyWith(
            postSuccess: true,
          ),
        );
      });
    } catch (e) {
      print("iniasd");
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
