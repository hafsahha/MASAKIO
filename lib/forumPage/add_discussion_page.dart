import 'package:flutter/material.dart';
import '../components/custom_button.dart';

class AddDiscussionBottomSheet extends StatefulWidget {
  const AddDiscussionBottomSheet({super.key});

  @override
  State<AddDiscussionBottomSheet> createState() => _AddDiscussionBottomSheetState();
}

class _AddDiscussionBottomSheetState extends State<AddDiscussionBottomSheet> {
  final TextEditingController _discussionController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  void dispose() {
    _discussionController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Tuliskan hal yang anda ingin diskusikan',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Isi Diskusi label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                'Isi Diskusi',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ),
            
            // Textarea for details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _detailController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan detail hal yang ingin anda sampaikan',
                    hintStyle: TextStyle(
                      fontFamily: 'SF Pro Display',
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            
            // Add Discussion Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                text: 'Tambahkan Diskusi',
                onPressed: () {
                  // Save discussion logic here
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper method to show the bottom sheet
void showAddDiscussionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddDiscussionBottomSheet(),
  );
}