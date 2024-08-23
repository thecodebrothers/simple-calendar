import 'package:flutter_bloc/flutter_bloc.dart';

const double kMinRowHeight = 20;

class ScaleHeightState {
  final double height;
  final double baseHeight;

  ScaleHeightState(this.height, this.baseHeight);
}

class ScaleRowHeightCubit extends Cubit<ScaleHeightState> {
  ScaleRowHeightCubit(double initialHeight)
      : super(ScaleHeightState(initialHeight, initialHeight));

  void setRowHeight(double height) {
    emit(ScaleHeightState(
        height < kMinRowHeight ? kMinRowHeight : height, state.baseHeight));
    print(height);
  }

  void onScaleEnd() {
    emit(ScaleHeightState(state.height, state.height));
  }
}
