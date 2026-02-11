import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../themes/app_spacing.dart';
import '../themes/app_theme.dart';
import '../themes/app_colors.dart';
import '../state/scan_controller.dart';
import '../state/scan_state.dart';

class EditableMessage {
  TextEditingController controller;
  bool isMe;
  EditableMessage({required String text, required this.isMe})
      : controller = TextEditingController(text: text);
}

class RefineTextPanel extends ConsumerStatefulWidget {
  const RefineTextPanel({super.key, required this.spacing, required this.result});
  final AppSpacing spacing;
  final ScanResult result;

  @override
  ConsumerState<RefineTextPanel> createState() => _RefineTextPanelState();
}

class _RefineTextPanelState extends ConsumerState<RefineTextPanel> {
  List<EditableMessage> messages = [];
  bool open = false; // ✅ Step 1: Default collapsed

  @override
  void initState() {
    super.initState();
    // Default data loading from OCR
    messages.add(EditableMessage(text: widget.result.extractedText, isMe: false));
  }

  void _addNewMessage() {
    setState(() {
      bool nextIsMe = messages.isEmpty ? false : !messages.last.isMe;
      messages.add(EditableMessage(text: "", isMe: nextIsMe));
    });
  }

  @override
  void dispose() {
    for (var m in messages) { m.controller.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = widget.spacing;
    final isLoading = ref.watch(scanControllerProvider).isLoading;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Step 2: Header with Toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  "REFINE CHAT LOG",
                  style: AppTheme.bebas(size: 22, letterSpacing: 1.2),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => open = !open),
                child: Text(
                  open ? "HIDE ▴" : "SHOW ▾",
                  style: AppTheme.bebas(
                    size: 16,
                    letterSpacing: 1.1,
                    color: AppColors.neonGreen,
                  ),
                ),
              ),
            ],
          ),

          Text(
            "Web pe sender split auto nahi hota. Edit karke accurate scan kar lo. ✅",
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
          ),

          // ✅ Optional Polish: Tip when collapsed
          if (!open) ...[
            const SizedBox(height: 8),
            Text(
              "Tip: Paste/clean the scammer’s messages in OTHER PERSON bubbles.",
              style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 11),
            ),
          ],

          SizedBox(height: spacing.gap16),

          // ✅ Step 3: Conditional Form Content
          if (open) ...[
            Column(
              children: List.generate(messages.length, (index) {
                return _ChatBubbleItem(
                  message: messages[index],
                  onDelete: () => setState(() => messages.removeAt(index)),
                  onToggleSender: () => setState(() => messages[index].isMe = !messages[index].isMe),
                );
              }),
            ),

            TextButton.icon(
              onPressed: _addNewMessage,
              icon: const Icon(Icons.add_circle_outline, color: AppColors.neonGreen, size: 18),
              label: Text("ADD MESSAGE", style: AppTheme.bebas(size: 14, color: AppColors.neonGreen)),
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleAnalyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonGreen,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  isLoading ? "RE-ANALYZING..." : "RE-ANALYZE",
                  style: AppTheme.bebas(size: 18, color: Colors.black, letterSpacing: 1.1),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleAnalyze() async {
    String youText = messages.where((m) => m.isMe).map((m) => m.controller.text).join("\n");
    String otherText = messages.where((m) => !m.isMe).map((m) => m.controller.text).join("\n");

    await ref.read(scanControllerProvider.notifier).scanText(
      youText: youText,
      otherText: otherText,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Re-analyzed ✅")),
      );
    }
  }
}

// _ChatBubbleItem widget same as before (as per instructions)
class _ChatBubbleItem extends StatelessWidget {
  final EditableMessage message;
  final VoidCallback onDelete;
  final VoidCallback onToggleSender;

  const _ChatBubbleItem({required this.message, required this.onDelete, required this.onToggleSender});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) _ToggleIcon(isMe: isMe, onTap: onToggleSender),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isMe ? AppColors.neonGreen.withOpacity(0.1) : AppColors.neonRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isMe ? AppColors.neonGreen.withOpacity(0.3) : AppColors.neonRed.withOpacity(0.3)),
              ),
              child: TextField(
                controller: message.controller,
                maxLines: null,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(border: InputBorder.none, isDense: true),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isMe) _ToggleIcon(isMe: isMe, onTap: onToggleSender),
          IconButton(
            icon: const Icon(Icons.close, size: 14, color: Colors.white24),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _ToggleIcon extends StatelessWidget {
  final bool isMe;
  final VoidCallback onTap;
  const _ToggleIcon({required this.isMe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 12,
        backgroundColor: isMe ? AppColors.neonGreen : AppColors.neonRed,
        child: Text(isMe ? "U" : "T", style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
      ),
    );
  }
}