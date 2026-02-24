import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:quizlab_ai/core/l10n/app_localizations.dart';
import 'package:quizlab_ai/presentation/widgets/quizlab_ai_button.dart';

class OnboardingNavButtons extends StatelessWidget {
  final bool isFirstPage;
  final bool isLastPage;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const OnboardingNavButtons({
    super.key,
    required this.isFirstPage,
    required this.isLastPage,
    required this.onBack,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (isFirstPage) {
      return QuizLabAIButton(
        title: localizations.next,
        icon: LucideIcons.arrowRight,
        expanded: true,
        onPressed: onNext,
      );
    }

    return Row(
      children: [
        Expanded(
          child: QuizLabAIButton(
            type: QuizlabAIButtonType.secondary,
            title: localizations.onboardingBack,
            icon: LucideIcons.arrowLeft,
            expanded: true,
            onPressed: onBack,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: QuizLabAIButton(
            title: isLastPage
                ? localizations.onboardingGetStarted
                : localizations.next,
            icon: isLastPage ? LucideIcons.rocket : LucideIcons.arrowRight,
            expanded: true,
            onPressed: isLastPage ? onFinish : onNext,
          ),
        ),
      ],
    );
  }
}
