import 'package:flutter/material.dart';
import '../models/dog_profile.dart';
import '../theme/app_theme.dart';

/// A card representing a single dog with a Check-In button.
class DogProfileCard extends StatelessWidget {
  const DogProfileCard({
    super.key,
    required this.profile,
    required this.onCheckIn,
  });

  final DogProfile profile;
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            _DogAvatar(profile: profile),
            const SizedBox(width: 14),
            // Name & details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profile.breed,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  Text(
                    profile.ownerName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Check-In button
            profile.isCheckedIn
                ? const _CheckedInBadge()
                : _CheckInButton(onPressed: onCheckIn),
          ],
        ),
      ),
    );
  }
}

class _DogAvatar extends StatelessWidget {
  const _DogAvatar({required this.profile});
  final DogProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.oceanBlue.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.oceanBlue.withOpacity(0.30),
          width: 2,
        ),
      ),
      child: Center(
        child: profile.imageAsset != null
            ? ClipOval(
                child: Image.asset(
                  profile.imageAsset!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallbackIcon(),
                ),
              )
            : _fallbackIcon(),
      ),
    );
  }

  Widget _fallbackIcon() {
    return Text(
      profile.name.substring(0, 1).toUpperCase(),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.oceanBlue,
      ),
    );
  }
}

class _CheckInButton extends StatelessWidget {
  const _CheckInButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.seafoam,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 2,
      ),
      child: const Text(
        'Check In',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _CheckedInBadge extends StatelessWidget {
  const _CheckedInBadge();
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.seafoam.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.seafoam, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: AppColors.seafoam, size: 16),
          SizedBox(width: 4),
          Text(
            'Checked In',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.seafoam,
            ),
          ),
        ],
      ),
    );
  }
}
