import 'package:encrypt/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External packages
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefs);

  // Encryption config
  sl.registerLazySingleton(() => EncryptionConfig(sl()));

  // Encryption components
  final encryptionConfig = sl<EncryptionConfig>();
  final key = await encryptionConfig.getOrCreateKey();
  final iv = await encryptionConfig.getOrCreateIV();
  final encrypter = encryptionConfig.createEncrypter(key);

  sl.registerLazySingleton<Key>(() => key);
  sl.registerLazySingleton<IV>(() => iv);
  sl.registerLazySingleton<Encrypter>(() => encrypter);

  // Services
  sl.registerLazySingleton<EncryptionService>(
    () => EncryptAdapter(sl<Encrypter>(), sl<IV>()),
  );

  // Data sources
  sl.registerLazySingleton<AssetLocalDatasource>(() => AssetLocalDatasource(sl(), sl()));

  // Repositories
  sl.registerLazySingleton<AssetRepository>(() => AssetRepositoryImpl(sl()));

  // Strategies
  sl.registerFactory<HighValueStrategy>(() => HighValueStrategy());
  sl.registerFactory<LowValueStrategy>(() => LowValueStrategy());

  sl.registerFactory<ValidationStrategyFactory>(() => ValidationStrategyFactory(sl(), sl()));

  // Use cases
  sl.registerFactory<CreateAssetUsecase>(() => CreateAssetUsecase(sl(), sl()));
  sl.registerFactory<DeleteAssetUsecase>(() => DeleteAssetUsecase(sl()));
  sl.registerFactory<GetAssetsUsecase>(() => GetAssetsUsecase(sl()));

  // Notifiers
  sl.registerFactory<CreateAssetNotifier>(() => CreateAssetNotifier(sl()));
  sl.registerFactory<GetAssetListNotifier>(() => GetAssetListNotifier(sl(), sl()));
}