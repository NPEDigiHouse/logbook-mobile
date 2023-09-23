import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/self_reflection_datasource.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'self_reflection_state.dart';

class SelfReflectionCubit extends Cubit<SelfReflectionState> {
  final SelfReflectionDataSource ds;
  SelfReflectionCubit({
    required this.ds,
  }) : super(SelfReflectionState());

  Future<void> uploadSelfReflection(
      {required SelfReflectionPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await ds.uploadSelfReflection(
        selfReflectionPostModel: model,
      );

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(isSelfReflectionPostSuccess: true)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
