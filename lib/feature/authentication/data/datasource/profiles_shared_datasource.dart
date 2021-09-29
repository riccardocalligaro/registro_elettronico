import 'dart:convert';

import 'package:registro_elettronico/feature/authentication/data/model/profile_local_model.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilesLocalDatasource {
  final SharedPreferences? sharedPreferences;

  ProfilesLocalDatasource({
    required this.sharedPreferences,
  });

  Future<List<ProfileLocalModel>> getAllProfiles() async {
    final profilesBody =
        sharedPreferences!.getString(PrefsConstants.profilesList);

    if (profilesBody != null) {
      List<ProfileLocalModel> profiles = List<ProfileLocalModel>.from(
        json.decode(profilesBody).map(
              (i) => ProfileLocalModel.fromJson(jsonDecode(i)),
            ),
      );

      return profiles;
    } else {
      return [];
    }
  }

  List<ProfileLocalModel> _getAllProfilesSync() {
    final profilesBody =
        sharedPreferences!.getString(PrefsConstants.profilesList);

    if (profilesBody != null) {
      List<ProfileLocalModel> profiles = List<ProfileLocalModel>.from(
        json.decode(profilesBody).map(
              (i) => ProfileLocalModel.fromJson(jsonDecode(i)),
            ),
      );

      return profiles;
    } else {
      return [];
    }
  }

  Future insertProfile(ProfileLocalModel profile) async {
    final profilesList = await getAllProfiles();
    profilesList.add(profile);
    await sharedPreferences!
        .setString(PrefsConstants.profilesList, jsonEncode(profilesList));
  }

  Future deleteWithIdent(String? ident) async {
    final profilesList = await getAllProfiles();

    profilesList.removeWhere((p) => p.ident == ident);

    await sharedPreferences!.setString(
      PrefsConstants.profilesList,
      jsonEncode(profilesList),
    );
  }

  Future updateProfile(ProfileLocalModel profile) async {
    final profilesList = await getAllProfiles();
    profilesList.removeWhere((element) => element.ident == profile.ident);
    profilesList.add(profile);
    await sharedPreferences!
        .setString(PrefsConstants.profilesList, jsonEncode(profilesList));
  }

  Future deleteAllProfiles() async {
    await sharedPreferences!
        .setString(PrefsConstants.profilesList, jsonEncode([]));
  }

  Future<List<ProfileLocalModel>> getLoggedInUser() async {
    final profilesList = await getAllProfiles();
    final loggedProfiles =
        profilesList.where((p) => p.currentlyLoggedIn!).toList();
    return loggedProfiles;
  }

  ProfileLocalModel getLoggedInUserSync() {
    final profilesList = _getAllProfilesSync();
    final profile = profilesList.where((p) => p.currentlyLoggedIn!).first;
    return profile;
  }

  Future<List<ProfileLocalModel>> getOtherUsers(String? ident) async {
    final profilesList = await getAllProfiles();
    final otherProfiles = profilesList.where((p) => p.ident != ident).toList();
    return otherProfiles;
  }

  Future<List<ProfileLocalModel>> getInactiveUsers() async {
    final profilesList = await getAllProfiles();
    final notLoggedProfiles =
        profilesList.where((p) => !p.currentlyLoggedIn!).toList();
    return notLoggedProfiles;
  }
}
