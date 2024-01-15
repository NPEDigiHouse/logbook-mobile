import 'package:data/datasources/remote_datasources/scientific_session_datasource.dart';
import 'package:data/models/scientific_session/scientific_roles.dart';
import 'package:data/models/scientific_session/scientific_session_post_model.dart';
import 'package:data/models/scientific_session/session_types_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

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
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> resetAttachment() async {
    emit(state.copyWith(
      attachState: RequestState.init,
      attachment: null,
    ));
  }

  Future<void> uploadAttachment({required String path}) async {
    try {
      emit(state.copyWith(
        attachState: RequestState.loading,
        attachment: null,
      ));

      final result = await ds.uploadScientificSessionAttachment(filePath: path);

      result.fold(
          (l) => emit(state.copyWith(attachState: RequestState.error)),
          (r) => emit(state.copyWith(
                attachment: r,
                attachState: RequestState.data,
              )));
    } catch (e) {
      emit(
        state.copyWith(
          attachState: RequestState.error,
        ),
      );
    }
  }

  Future<void> deleteScientificSessionById({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await ds.deleteScientificSession(id);
      emit(state.copyWith(
          requestState: RequestState.data, isDeleteScientificSession: true));
    } catch (e) {
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
        emit(state.copyWith(scientificRoles: r));
      });
    } catch (e) {
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
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> updateScientificSession(
      {required ScientificSessionPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await ds.updateScientificSession(scientificSessionPostModel: model);

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
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
