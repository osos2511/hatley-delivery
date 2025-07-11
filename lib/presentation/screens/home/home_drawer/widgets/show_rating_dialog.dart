// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:hatley/core/colors_manager.dart';
// import 'package:hatley/presentation/screens/auth/widgets/custom_toast.dart';
// import '../../../../cubit/feedback_cubit/feedback_cubit.dart';
// import '../../../../cubit/feedback_cubit/feedback_state.dart';
//
// class RatingReviewDialog extends StatefulWidget {
//   final int orderId;
//
//   const RatingReviewDialog({Key? key, required this.orderId}) : super(key: key);
//
//   @override
//   State<RatingReviewDialog> createState() => _RatingReviewDialogState();
// }
//
// class _RatingReviewDialogState extends State<RatingReviewDialog> {
//   late final TextEditingController _reviewController;
//   double _ratingValue = 0;
//   bool _isSubmitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _reviewController = TextEditingController();
//     context.read<FeedbackCubit>().loadFeedback(widget.orderId);
//   }
//
//   @override
//   void dispose() {
//     _reviewController.dispose();
//     super.dispose();
//   }
//
//   bool get _isInputValid =>
//       _ratingValue >= 1 && _reviewController.text.trim().isNotEmpty;
//
//   Future<void> _submit() async {
//     setState(() => _isSubmitting = true);
//
//     final cubit = context.read<FeedbackCubit>();
//     final currentState = cubit.state;
//
//     if (currentState is FeedbackLoadSuccess) {
//       final oldRating = currentState.rating?.rating?.toDouble() ?? 0;
//       final oldReview = currentState.review?.review ?? '';
//       if (_ratingValue == oldRating &&
//           _reviewController.text.trim() == oldReview.trim()) {
//         CustomToast.show(message:'No changes to update');
//         setState(() => _isSubmitting = false);
//         return;
//       }
//       await cubit.addOrUpdateRating(widget.orderId, _ratingValue.toInt());
//       await cubit.addOrUpdateReview(widget.orderId, _reviewController.text.trim());
//     }
//
//     setState(() => _isSubmitting = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<FeedbackCubit, FeedbackState>(
//       listener: (context, state) {
//         if (state is FeedbackFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: ${state.message}')),
//           );
//         } else if (state is FeedbackAddSuccess || state is FeedbackUpdateSuccess) {
//           CustomToast.show(message: 'Review & Rating submitted successfully');
//           Navigator.of(context).pop();
//         } else if (state is FeedbackLoadSuccess) {
//           if (!_isSubmitting) {
//             _ratingValue = state.rating?.rating?.toDouble() ?? 0;
//             _reviewController.text = state.review?.review ?? '';
//           }
//         }
//       },
//       builder: (context, state) {
//         if (state is FeedbackLoading) {
//           return  Center(
//             child: CircularProgressIndicator(color: ColorsManager.white),
//           );
//         }
//
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           title:  Center(
//             child: Text(
//               'Rate & Review',
//               style: TextStyle(color: ColorsManager.primaryColorApp, fontWeight: FontWeight.bold),
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 RatingBar.builder(
//                   initialRating: _ratingValue,
//                   minRating: 1,
//                   maxRating: 5,
//                   allowHalfRating: false,
//                   itemCount: 5,
//                   itemBuilder: (context, _) =>
//                   const Icon(Icons.star, color: Colors.yellow),
//                   onRatingUpdate: (rating) {
//                     setState(() => _ratingValue = rating);
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _reviewController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     hintText: 'Write your review here...',
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide:  BorderSide(color: Colors.grey, width: 2),
//                     ),
//                   ),
//                   onChanged: (_) => setState(() {}),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.grey,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//
//               ),
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(color: Colors.white),
//
//               ),
//             ),
//
//             ElevatedButton(
//               onPressed: _isInputValid && !_isSubmitting ? _submit : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorsManager.buttonColorApp,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: _isSubmitting
//                   ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               )
//                   : Text(
//                 (_ratingValue > 0 && _reviewController.text.trim().isNotEmpty)
//                     ? 'Save'
//                     : 'Add Review',
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
