import 'package:data/datasources/remote_datasources/auth_datasource.dart';
import 'package:data/datasources/remote_datasources/competence_datasource.dart';
import 'package:data/datasources/remote_datasources/sglcst_datasource.dart';
import 'package:data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:data/datasources/remote_datasources/unit_datasource.dart';
import 'package:data/datasources/remote_datasources/user_datasource.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data/repository/repository_data.dart';
import 'package:main/helpers/helper.dart';

part 'wrapper_state.dart';

class WrapperCubit extends Cubit<WrapperState> {
  final AuthDataSource authDataSource;
  final UserDataSource userDataSource;
  final SupervisorsDataSource supervisorsDataSource;
  final SglCstDataSource sglCstdataSource;
  final CompetenceDataSource competenceDataSource;
  final DepartmentDatasource departmentDatasource;

  WrapperCubit({
    required this.authDataSource,
    required this.userDataSource,
    required this.supervisorsDataSource,
    required this.sglCstdataSource,
    required this.competenceDataSource,
    required this.departmentDatasource,
  }) : super(WrapperInitial());

  Future<void> isSignIn() async {
    try {
      emit(WrapperLoading());
      final result = await authDataSource.isSignIn();
      result.fold(
        (l) => emit(WrapperFailed(message: l.message)),
        (r) async {
          if (r) {
            final credentialResult = await authDataSource.getUserCredential();
            credentialResult.fold(
              (l) => emit(CredentialNotExist()),
              (r) {
                if (r.role == "STUDENT") {
                  _fetchStaticData(r);
                } else {
                  emit(CredentialExist(credential: r));
                }
              },
            );
          } else {
            emit(CredentialNotExist());
          }
        },
      );
    } catch (e) {
      emit(WrapperFailed(message: e.toString()));
    }
  }

  void _fetchStaticData(UserCredential credential) async {
    RepositoryData.allClear();
    final supervisor = await supervisorsDataSource.getAllSupervisors();
    final department = await departmentDatasource.getActiveDepartment();
    department.fold((l) => null, (r) async {
      final sglcst = await sglCstdataSource.getTopicsByDepartmentId(
          unitId: r.unitId ?? '');
      final cases =
          await competenceDataSource.getStudentCases(unitId: r.unitId ?? '');
      final skills =
          await competenceDataSource.getStudentSkills(unitId: r.unitId ?? '');
      sglcst.fold((l) => null, (it) {
        RepositoryData.sglTopics.clear();
        RepositoryData.sglTopics
            .addAll(ParseHelper.filterTopic(listData: it, isSGL: true));
        RepositoryData.cstTopics.clear();
        RepositoryData.cstTopics
            .addAll(ParseHelper.filterTopic(listData: it, isSGL: false));
      });
      RepositoryData.cases = cases;
      RepositoryData.skills = skills;
    });
    supervisor.fold((l) => null, (r) => RepositoryData.supervisors = r);
    emit(CredentialExist(credential: credential));
  }

  void reset() {
    emit(WrapperInitial());
  }
}
