import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/authentication/domain/model/profile_domain_model.dart';
import 'package:registro_elettronico/feature/authentication/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/authentication/presentation/login_page.dart';

class ChangeAccountDialog extends StatefulWidget {
  ChangeAccountDialog({Key key}) : super(key: key);

  @override
  _ChangeAccountDialogState createState() => _ChangeAccountDialogState();
}

class _ChangeAccountDialogState extends State<ChangeAccountDialog> {
  final AuthenticationRepository authenticationRepository = sl();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(AppLocalizations.of(context).translate('change_profile_title')),
      content: FutureBuilder<Either<Failure, List<ProfileDomainModel>>>(
        future: authenticationRepository.getNonActiveAccounts(),
        initialData: null,
        builder: (
          BuildContext context,
          AsyncSnapshot<Either<Failure, List<ProfileDomainModel>>> snapshot,
        ) {
          if (snapshot.data != null) {
            return snapshot.data.fold(
              (l) => Text(
                AppLocalizations.of(context).translate('generic_failure'),
              ),
              (profiles) {
                if (profiles.isEmpty) {
                  return Text(
                    AppLocalizations.of(context).translate('no_profiles'),
                  );
                }
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(
                        profiles.length,
                        (int index) {
                          final profile = profiles[index];
                          return ListTile(
                            title: Text(
                              '${profile.firstName} ${profile.lastName}',
                            ),
                            subtitle: Text(profile.ident),
                            onTap: () async {
                              final switchProfile =
                                  await authenticationRepository
                                      .switchToAccount(
                                profileDomainModel: profile,
                              );

                              switchProfile.fold(
                                (l) {
                                  Navigator.pop(context);
                                },
                                (r) => null,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return CircularProgressIndicator();
        },
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppLocalizations.of(context).translate('cancel').toUpperCase(),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginPage(
                  fromChangeAccount: true,
                ),
              ),
            );
          },
          child: Text(AppLocalizations.of(context)
              .translate('add_account')
              .toUpperCase()),
        ),
      ],
    );
  }
}
