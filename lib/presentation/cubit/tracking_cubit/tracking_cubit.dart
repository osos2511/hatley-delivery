import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/data/model/traking_response.dart';
import 'tracking_state.dart';
import '../../../core/api_manager/api_manager.dart';

class TrackingCubit extends Cubit<TrackingState> {
  final TrakingApiManager trakingApiManager;

  TrackingCubit({required this.trakingApiManager}) : super(TrackingInitial());

  Future<void> getTrackingData([int? orderId, bool showLoading = true]) async {
    if (showLoading) emit(TrackingLoading());

    final result = await trakingApiManager.getAllTrackingData();

    result.fold(
      (failure) {
        // لو في فشل نعرض رسالة الخطأ مباشرة
        emit(TrackingError(message: failure.message));
      },
      (allTrackingData) {
        if (allTrackingData is List<TrakingResponse>) {
          if (allTrackingData.isEmpty) {
            // لو القائمة فاضية نرسل حالة فارغة
            emit(TrackingEmpty());
          } else {
            // لو في بيانات، نرتبها نزولياً حسب orderId وبعدين نرسل الحالة
            allTrackingData.sort((a, b) => b.orderId.compareTo(a.orderId));
            emit(TrackingLoaded(trackingData: allTrackingData));
          }
        } else {
          // لو البيانات مش List<TrakingResponse> أي نوع آخر
          emit(TrackingError(message: 'Unexpected data format'));
        }
      },
    );
  }

  Future<void> changeOrderStatusOnServer({required int orderId}) async {
    final result = await trakingApiManager.triggerOrderStatusChange(
      orderId: orderId,
    );
    result.fold(
      (failure) {
        // يمكنك هنا إظهار Toast أو Snackbar فقط إذا أردت
      },
      (success) async {
        // بعد نجاح التغيير على السيرفر، أعد جلب بيانات التتبع بدون لودنج
        await getTrackingData(null, false);
      },
    );
  }

  void updateOrderStatus({
    required int orderId,
    required int newStatus,
    required String userEmail,
    required String userType,
  }) {
    if (state is TrackingLoaded) {
      final currentState = state as TrackingLoaded;
      final List<TrakingResponse> currentOrders = List.from(
        currentState.trackingData,
      );

      final int index = currentOrders.indexWhere(
        (order) => order.orderId == orderId,
      );

      if (index != -1) {
        final TrakingResponse oldOrder = currentOrders[index];
        final TrakingResponse updatedOrder = oldOrder.copyWith(
          status: newStatus,
        );

        currentOrders[index] = updatedOrder;
        emit(TrackingLoaded(trackingData: currentOrders));
        print('Cubit: Order $orderId status updated to $newStatus');
      } else {
        print(
          'Cubit: Order $orderId not found in current tracking list. Cannot update.',
        );
      }
    } else {
      print(
        'Cubit: Cannot update order status, current state is not TrackingLoaded. Ignoring update.',
      );
    }
  }
}
