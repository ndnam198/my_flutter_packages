import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get soemthingWentWrong => 'Something went wrong';

  @override
  String get failureOperation => 'Operation failed';

  @override
  String get failureUnknown => 'Unknown failure';

  @override
  String get failureSystem => 'System failure';

  @override
  String get failureOperationNotSupported => 'Operation not supported';

  @override
  String get failureOperationTimeout => 'Operation timeout';

  @override
  String get failureNetwork => 'Network failure';

  @override
  String get failureFetchDataFromInternet => 'Failed to fetch data from internet';

  @override
  String get failureResourceNotFound => 'Resource not found';

  @override
  String get successAny => 'Successful operation';
}
