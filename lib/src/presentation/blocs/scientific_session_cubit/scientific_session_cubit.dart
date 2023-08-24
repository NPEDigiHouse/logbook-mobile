import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/models/scientific_session/list_scientific_session_model.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_roles.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_post_model.dart';
import 'package:elogbook/src/data/models/scientific_session/session_types_model.dart';
import 'package:elogbook/src/domain/usecases/scientific_session_usecases/get_list_session_types_usecase.dart';
import 'package:elogbook/src/domain/usecases/scientific_session_usecases/get_scientific_roles_usecase.dart';
import 'package:elogbook/src/domain/usecases/scientific_session_usecases/upload_scientific_session_usecase.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'scientific_session_state.dart';

class ScientificSessionCubit extends Cubit<ScientifcSessionState> {
  final GetListSessionTypesUsecase getListSessionTypesUsecase;
  final GetScientificSessionRolesUsecase getScientificSessionRolesUsecase;
  final UploadScientificSessionUsecase uploadScientificSessionUsecase;

  ScientificSessionCubit({
    required this.getListSessionTypesUsecase,
    required this.getScientificSessionRolesUsecase,
    required this.uploadScientificSessionUsecase,
  }) : super(ScientifcSessionState());

  Future<void> getListSessionTypes() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await getListSessionTypesUsecase.execute();

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

  Future<void> getScientificSessionRoles() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await getScientificSessionRolesUsecase.execute();

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

      final result = await uploadScientificSessionUsecase.execute(model: model);

      result.fold(
          (l) => emit(
                state.copyWith(requestState: RequestState.error),
              ), (r) {
        print("disiini");
        return emit(state.copyWith(postSuccess: true));
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