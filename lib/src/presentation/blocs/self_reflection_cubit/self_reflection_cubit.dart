import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';
import 'package:elogbook/src/domain/usecases/self_reflection_usecases/upload_self_reflection_usecase.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'self_reflection_state.dart';

class SelfReflectionCubit extends Cubit<SelfReflectionState> {
  final UploadSelfReflectionUsecase selfReflectionUsecase;
  SelfReflectionCubit({
    required this.selfReflectionUsecase,
  }) : super(SelfReflectionState());

  Future<void> uploadSelfReflection({required SelfReflectionPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await selfReflectionUsecase.execute(
        model: model,
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
