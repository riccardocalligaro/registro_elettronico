import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';

class SrSearchEmptyView extends StatelessWidget {
  const SrSearchEmptyView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPlaceHolder(
      text: AppLocalizations.of(context).translate('search_no_results'),
      icon: Icons.search_off,
      showUpdate: false,
    );
  }
}
