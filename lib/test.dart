import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SpendingLimitDetailsPage extends StatefulWidget {
  const SpendingLimitDetailsPage({super.key});

  @override
  State<SpendingLimitDetailsPage> createState() =>
      _SpendingLimitDetailsPageState();
}

class _SpendingLimitDetailsPageState extends State<SpendingLimitDetailsPage> {
  bool showDetails = false;

  final List<Map<String, String>> recentExpenses = [
    {'name': 'McDonald\'s', 'amount': '\$12.00'},
    {'name': 'Supermarket', 'amount': '\$75.00'},
    {'name': 'Coffee Shop', 'amount': '\$6.00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                BounceInDown(
                  duration: const Duration(milliseconds: 800),
                  child: const Icon(Icons.account_balance_wallet_rounded,
                      size: 80, color: Colors.orangeAccent),
                ),
                const SizedBox(height: 10),
                FadeIn(
                  duration: const Duration(milliseconds: 900),
                  child: Text(
                    "Track your budget smartly.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SlideInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: _BlurCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Food",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 16),
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            minHeight: 10,
                            backgroundColor: Colors.grey[800],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.orange),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("60% used",
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14)),
                        const SizedBox(height: 20),
                        // Values
                        _InfoRow(label: "Limit Balance", value: "\$50,000"),
                        _InfoRow(label: "Spending Amount", value: "\$30,000"),
                        _InfoRow(label: "Remaining", value: "\$20,000"),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 10),
                        _InfoRow(label: "Start", value: "2/2/2025"),
                        _InfoRow(label: "End", value: "2/3/2025"),
                        const SizedBox(height: 10),

                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                showDetails = !showDetails;
                              });
                            },
                            icon: Icon(
                              showDetails
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.orangeAccent,
                            ),
                            label: Text(
                              showDetails ? "Hide Details" : "More Details",
                              style:
                                  const TextStyle(color: Colors.orangeAccent),
                            ),
                          ),
                        ),

                        AnimatedCrossFade(
                          firstChild: const SizedBox(),
                          secondChild: Column(
                            children: recentExpenses.map((expense) {
                              return FadeInUp(
                                delay: const Duration(milliseconds: 100),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.receipt_long,
                                      color: Colors.orangeAccent, size: 20),
                                  title: Text(expense['name']!,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  trailing: Text(expense['amount']!,
                                      style: TextStyle(
                                          color: Colors.grey[300],
                                          fontWeight: FontWeight.bold)),
                                ),
                              );
                            }).toList(),
                          ),
                          crossFadeState: showDetails
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 400),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BlurCard extends StatelessWidget {
  final Widget child;
  const _BlurCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 16)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }
}
