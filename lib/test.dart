// import 'package:flutter/material.dart';

// class test extends StatelessWidget {
//   final List<SpendingLimit> limits = [
//     SpendingLimit(category: 'Food', spent: 60000, limit: 100000),
//     SpendingLimit(category: 'Food', spent: 60000, limit: 100000),
//     SpendingLimit(category: 'Food', spent: 60000, limit: 100000),
//     SpendingLimit(category: 'Food', spent: 60000, limit: 100000),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5), // Soft off-white
//       appBar: AppBar(
//         title: const Text('Spending Limits'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF6C3EFF),
//         child: const Icon(Icons.add),
//         onPressed: () {},
//       ),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: limits.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 16),
//         itemBuilder: (context, index) {
//           return SpendingLimitCard(limit: limits[index]);
//         },
//       ),
//     );
//   }
// }

// class SpendingLimit {
//   final String category;
//   final double spent;
//   final double limit;

//   SpendingLimit({
//     required this.category,
//     required this.spent,
//     required this.limit,
//   });
// }

// class SpendingLimitCard extends StatelessWidget {
//   final String limitName;
//   final double totalAmount;
//   final double spendAmount;
//   final double remainedAmount;

//   const SpendingLimitCard({
//     required this.limitName,
//     required this.totalAmount,
//     required this.spendAmount,
//     required this.remainedAmount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final remaining = totalAmount - spendAmount;
//     final progress = (spendAmount / totalAmount).clamp(0.0, 1.0);

//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFE8E5FF), // Improved inner container color
//         borderRadius: BorderRadius.circular(16),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: const Color(0xFFD8D0FF),
//                 child: const Icon(Icons.restaurant, color: Color(0xFF4B39EF)),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(limitName,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16)),
//                     Text('You spent \$${spendAmount.toStringAsFixed(0)}'),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text('\$${totalAmount.toStringAsFixed(0)}',
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16)),
//                   Text('\$${remaining.toStringAsFixed(0)} left to spend',
//                       style: const TextStyle(fontSize: 12)),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           LinearProgressIndicator(
//             value: progress,
//             minHeight: 6,
//             backgroundColor: const Color(0xFFD6CCFA),
//             valueColor: const AlwaysStoppedAnimation(Color(0xFF4B39EF)),
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ],
//       ),
//     );
//   }
// }
