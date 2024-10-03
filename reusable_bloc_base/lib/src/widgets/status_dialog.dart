import 'package:flutter/material.dart';

import 'theme.dart';

enum DialogType {
  none,
  success,
  failure,
}

class StatusDialog extends StatelessWidget {
  final String title;
  final String description;
  final DialogType type;

  const StatusDialog.failure({
    required this.title,
    required this.description,
    super.key,
  }) : type = DialogType.failure;

  const StatusDialog.success({
    required this.title,
    required this.description,
    super.key,
  }) : type = DialogType.success;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: Paddings.dialog,
      content: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              gapH24,
              Text(
                title,
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: type == DialogType.success
                      ? AC.success
                      : type == DialogType.failure
                          ? AC.error
                          : null,
                ),
              ),
              gapH16,
              Text(
                description,
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  height: 21 / 16,
                  fontSize: 16,
                ),
              ),
              gapH24,
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: type == DialogType.success
                            ? AC.success.withOpacity(.6)
                            : type == DialogType.failure
                                ? AC.error
                                : null,
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (type != DialogType.none)
            Transform.translate(
              offset: const Offset(0, -80),
              child: Container(
                width: 99,
                height: 99,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: CircleBorder(),
                ),
                child: Center(
                  child: buildIcon(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildIcon() {
    switch (type) {
      case DialogType.success:
        return const Icon(
          Icons.check_circle,
          size: 100,
          color: AC.success,
        );
      case DialogType.failure:
        return const Icon(
          Icons.cancel_rounded,
          size: 100,
          color: AC.error,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> show(BuildContext context) {
    return showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => this,
    );
  }
}
