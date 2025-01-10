import 'package:ckoitgrol/provider/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ckoitgrol/utils/dialog/share_dialog.dart';

class UserPost extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String image;
  final double grolPercentage;
  final String date;
  final String author;
  final String authorProfilePicture;
  final List<String> likes;
  final String currentUserId;

  const UserPost({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.grolPercentage,
    required this.date,
    required this.author,
    this.authorProfilePicture = '',
    required this.likes,
    required this.currentUserId,
  });

  void _handleLike(BuildContext context) {
    context.read<PostsProvider>().toggleLike(id, currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLiked = likes.contains(currentUserId);

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
                  foregroundImage: authorProfilePicture.isNotEmpty
                      ? NetworkImage(authorProfilePicture)
                      : null,
                  child: const Icon(Icons.person, size: 20),
                ),
                const SizedBox(width: 12),
                // Author name and date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(DateTime.parse(date)),
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 400, // Maximum height allowed
                minHeight: 300, // Minimum height to maintain
              ),
              child: CachedNetworkImage(
                imageUrl: image,
                width: double.infinity,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  height: 300, // Default placeholder height
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          // Post content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                // Action buttons
                Row(
                  children: [
                    _buildActionButton(
                      context,
                      isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                      () => _handleLike(context),
                      '${likes.length} ${Translate.of(context).like}',
                      color: isLiked
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    _buildActionButton(
                      context,
                      Icons.share_outlined,
                      () {
                        showDialog(
                          context: context,
                          builder: (context) => ShareDialog(
                            postId: id,
                            currentUserId: currentUserId,
                          ),
                        );
                      },
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
      BuildContext context, IconData icon, VoidCallback onTap, String label,
      {Color? color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        color ?? Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
