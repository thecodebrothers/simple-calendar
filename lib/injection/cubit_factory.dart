import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class CubitFactory {
  final GetIt injector;
  
  const CubitFactory({
    required this.injector,
  });
  
  T get<T extends Cubit>() => injector.get<T>();
  
  static CubitFactory of(BuildContext context, {bool listen = true}) =>
      Provider.of<CubitFactory>(context, listen: listen);
}
