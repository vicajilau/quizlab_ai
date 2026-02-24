import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizlab_ai/core/l10n/app_localizations.dart';
import 'package:quizlab_ai/presentation/blocs/onboarding_cubit/onboarding_cubit.dart';
import 'package:quizlab_ai/presentation/blocs/onboarding_cubit/onboarding_state.dart';
import 'package:quizlab_ai/presentation/screens/onboarding/widgets/onboarding_nav_buttons.dart';
import 'package:quizlab_ai/presentation/screens/onboarding/widgets/onboarding_page_data.dart';
import 'package:quizlab_ai/presentation/screens/onboarding/widgets/onboarding_page_indicator.dart';

class OnboardingMobileLayout extends StatelessWidget {
  final OnboardingState state;
  final List<OnboardingPageData> pages;
  final PageController pageController;
  final OnboardingCubit cubit;
  final VoidCallback onFinish;

  const OnboardingMobileLayout({
    super.key,
    required this.state,
    required this.pages,
    required this.pageController,
    required this.cubit,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        children: [
          // Page content with floating Skip button
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  onPageChanged: cubit.setPage,
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return OnboardingMobilePageContent(page: page);
                  },
                ),
                if (!state.isLastPage)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: TextButton(
                      onPressed: onFinish,
                      child: Text(
                        AppLocalizations.of(context)!.skip,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Page indicator
          OnboardingPageIndicator(
            currentPage: state.currentPage,
            totalPages: state.totalPages,
          ),

          const SizedBox(height: 24),

          // Nav buttons
          OnboardingNavButtons(
            isFirstPage: state.isFirstPage,
            isLastPage: state.isLastPage,
            onBack: cubit.previousPage,
            onNext: cubit.nextPage,
            onFinish: onFinish,
          ),
        ],
      ),
    );
  }
}

class OnboardingMobilePageContent extends StatelessWidget {
  final OnboardingPageData page;

  const OnboardingMobilePageContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Icon or Image
          if (page.imagePath != null)
            Image.asset(page.imagePath!, width: 250, height: 250)
          else
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(page.icon, color: theme.primaryColor, size: 56),
            ),

          const SizedBox(height: 32),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                height: 1.5,
                color: theme.hintColor,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Content
          page.contentBuilder(context),
        ],
      ),
    );
  }
}
