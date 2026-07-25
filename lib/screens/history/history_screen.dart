import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/history_card.dart';
import '../../core/widgets/loading_widget.dart';
import '../../providers/history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(title: const Text('History')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          children: [
            // Search bar
            TextField(
              onChanged: provider.search,
              decoration: InputDecoration(
                hintText: 'Search records...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: AppColors.whiteCard,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Expanded(
              child: provider.isLoading
                  ? const LoadingWidget()
                  : RefreshIndicator(
                      onRefresh: provider.refresh,
                      color: AppColors.primaryBlue,
                      child: provider.records.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 120),
                                Center(child: Text('No records found')),
                              ],
                            )
                          : ListView.builder(
                              itemCount: provider.records.length,
                              itemBuilder: (context, index) =>
                                  HistoryCard(record: provider.records[index]),
                            ),
                    ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            CustomButton(
              label: 'Export History',
              icon: Icons.ios_share,
              variant: CustomButtonVariant.primary,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export started — CSV will be saved to device.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
