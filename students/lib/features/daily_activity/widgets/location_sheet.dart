import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/activity/activity_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/activity_cubit/activity_cubit.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

class LocationSheet extends StatefulWidget {
  final ActivityModel model;
  final bool isActive;
  final dynamic Function(ActivityModel activity) onTap;
  const LocationSheet({
    super.key,
    required this.isActive,
    required this.onTap,
    required this.model,
  });

  @override
  State<LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<LocationSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ActivityCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: BlocSelector<ActivityCubit, ActivityState,
          (LocationStatus, RequestState)>(
        selector: (state) => (state.locationStatus, state.checkState),
        builder: (context, state) {
          final value = state.$1;
          return Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AssetPath.getImage('map.png'),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.pin_drop,
                                color: errorColor,
                              ),
                              const SizedBox(width: 8),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        AppSize.getAppWidth(context) - 110),
                                child: Text(
                                  widget.model.name ?? '',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: primaryTextColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: value == LocationStatus.notChecked
                                      ? onFormDisableColor.withOpacity(.8)
                                      : value == LocationStatus.insideArea
                                          ? successColor.withOpacity(.8)
                                          : errorColor.withOpacity(.8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      value == LocationStatus.notChecked
                                          ? Icons.hourglass_top_rounded
                                          : value == LocationStatus.insideArea
                                              ? Icons.check_rounded
                                              : Icons.error_rounded,
                                      size: 14,
                                      color: scaffoldBackgroundColor,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      value == LocationStatus.notChecked
                                          ? 'Not Checked'
                                          : value == LocationStatus.insideArea
                                              ? 'Inside Area'
                                              : 'Outside Area',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: state.$2 == RequestState.init
                                    ? secondaryColor
                                    : state.$2 == RequestState.loading
                                        ? onFormDisableColor
                                        : LocationStatus.outsideArea == state.$1
                                            ? errorColor
                                            : primaryColor,
                                foregroundColor: scaffoldBackgroundColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                if (state.$2 == RequestState.init) {
                                  context
                                      .read<ActivityCubit>()
                                      .checkLocation(widget.model);
                                }
                                if (state.$2 == RequestState.data) {
                                  if (LocationStatus.outsideArea == state.$1) {
                                    context
                                        .read<ActivityCubit>()
                                        .checkLocation(widget.model);
                                    return;
                                  }
                                  widget.onTap.call(widget.model);
                                  context.back();
                                }
                              },
                              child: state.$2 == RequestState.init
                                  ? const Text('Check Location')
                                  : state.$2 == RequestState.loading
                                      ? const Text('Loading ...')
                                      : LocationStatus.outsideArea == state.$1
                                          ? const Text('Recheck Location')
                                          : const Text('Submit'),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                context.back();
                              },
                              child: Text(
                                'Cancel',
                                style: textTheme.titleMedium?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [backgroundColor.withOpacity(.2), backgroundColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 120,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: primaryColor),
                        color: primaryColor.withOpacity(.5)),
                    child: const Icon(
                      CupertinoIcons.location_fill,
                      color: scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
