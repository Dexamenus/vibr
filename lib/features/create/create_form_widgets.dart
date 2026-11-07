part of 'create_screen.dart';

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      avatar: icon == null ? null : Icon(icon, size: 14),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.accent,
      side: BorderSide(color: selected ? AppColors.accent : AppColors.border),
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.muted,
        fontSize: 11,
      ),
      shape: const StadiumBorder(),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.surfaceRaised,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          textStyle: const TextStyle(fontSize: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
