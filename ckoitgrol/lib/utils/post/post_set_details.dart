import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class UserPostSetDetails extends StatelessWidget {
  final String? title;
  final String? description;
  final Image? image;
  final double grolPercentage;
  final String? date;
  final String? author;
  final String? authorProfilePicture;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onDescriptionChanged;

  const UserPostSetDetails({
    super.key,
    this.title,
    this.description,
    required this.image,
    required this.grolPercentage,
    this.date,
    this.author,
    this.authorProfilePicture = '',
    this.onTitleChanged,
    this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Author avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHigh,
                  foregroundImage: authorProfilePicture?.isNotEmpty ?? false
                      ? NetworkImage(authorProfilePicture!)
                      : null,
                  child: const Icon(Icons.person, size: 20),
                ),
                const SizedBox(width: 12),
                // Author name and date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(DateTime.parse(date ?? '')),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                // Grol percentage indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(grolPercentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Post image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: SizedBox(
              width: double.infinity,
              height: 400,
              child: FittedBox(
                fit: BoxFit.contain,
                child: image ??
                    Container(
                      height: 400,
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
              ),
            ),
          ),
          // Post content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    hintText: 'Enter your title',
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  onChanged: onTitleChanged,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: title ?? '',
                      selection:
                          TextSelection.collapsed(offset: title?.length ?? 0),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLength: 50,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter description',
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  onChanged: onDescriptionChanged,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: description ?? '',
                      selection: TextSelection.collapsed(
                          offset: description?.length ?? 0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Action buttons
                Row(
                  children: [
                    _buildActionButton(
                      context,
                      Icons.favorite_border_rounded,
                      Translate.of(context).like,
                    ),
                    _buildActionButton(
                      context,
                      Icons.share_outlined,
                      Translate.of(context).share,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
