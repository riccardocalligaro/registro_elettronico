import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';

class SRAlternativeLoadingView extends StatelessWidget {
  final String? text;

  const SRAlternativeLoadingView({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text ??
              AppLocalizations.of(context)!.translate('loading_new_data')!),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: LinearProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
