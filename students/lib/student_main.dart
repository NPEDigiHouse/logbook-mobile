import 'package:common/features/auth/login_page.dart';
import 'package:common/features/history/history_page.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/delete_account_cubit/delete_account_cubit.dart';
import 'package:main/blocs/logout_cubit/logout_cubit.dart';
import 'package:main/blocs/profile_cubit/profile_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/custom_navigation_bar.dart';
import 'features/menu/history/history_page.dart';
import 'features/menu/profile/profile_page.dart';
import 'features/menu/home/student_home_page.dart';

class StudentMainMenu extends StatefulWidget {
  const StudentMainMenu({
    super.key,
  });

  @override
  State<StudentMainMenu> createState() => _StudentMainMenuState();
}

class _StudentMainMenuState extends State<StudentMainMenu> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    //Get User Creadential
    Future.microtask(
      () => BlocProvider.of<UserCubit>(context).getUserCredential(),
    );
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  List<Widget> _listMenu(UserCredential credential) {
    return [
      StudentHomePage(credential: credential),
      const HistoryView(
        role: UserHistoryRole.student,
      ),
      ProfilePage(credential: credential),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, deleteStatte) {
      if (deleteStatte is DeleteSuccess) {
        context.replace(const LoginPage());
      }
    }, builder: (context, logoutState) {
      return BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, logoutState) {
          if (logoutState is LogoutSuccess) {
            context.replace(const LoginPage());
          }
        },
        builder: (context, state) {
          return ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (context, value, _) {
              return BlocConsumer<UserCubit, UserState>(
                  listener: (context, ss) {
                if (ss.initState == RequestState.error) {
                  CustomAlert.error(
                    message: "Failed Load Credential",
                    context: context,
                  );
                }
              }, builder: (context, s) {
                if (s.initState == RequestState.data &&
                    s.userCredential != null) {
                  return Scaffold(
                    body: IndexedStack(
                      index: value,
                      children: _listMenu(s.userCredential!),
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      items: const [
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.home), label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.news), label: 'History'),
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.profile_circled),
                            label: 'Profile')
                      ],
                      onTap: (value) {
                        _selectedIndex.value = value;
                      },
                      currentIndex: value,
                    ),
                  );
                } else if (s.initState == RequestState.loading) {
                  return const Scaffold(
                    body: CustomLoading(),
                  );
                } else {
                  return const Scaffold(body: SizedBox.shrink());
                }
              });
            },
          );
        },
      );
    });
  }
}
