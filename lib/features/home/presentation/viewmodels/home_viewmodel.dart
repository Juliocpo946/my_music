import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/usecases/get_home_data.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<HomeData> homeViewModel(HomeViewModelRef ref) async {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['DEEZER_BASE_URL']!));
  final dataSource = HomeRemoteDataSourceImpl(dio: dio);
  final repository = HomeRepositoryImpl(remoteDataSource: dataSource);
  final getHomeData = GetHomeData(repository);
  return getHomeData();
}