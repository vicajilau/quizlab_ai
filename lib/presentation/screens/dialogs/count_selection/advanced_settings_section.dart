import 'package:flutter/material.dart';
import 'package:quiz_app/core/l10n/app_localizations.dart';
import 'package:quiz_app/core/theme/app_theme.dart';
import 'package:quiz_app/domain/models/quiz/question_order.dart';
import 'package:quiz_app/presentation/screens/dialogs/count_selection/widgets/max_incorrect_limit_input.dart';
import 'package:quiz_app/presentation/screens/dialogs/count_selection/widgets/max_incorrect_toggle.dart';
import 'package:quiz_app/presentation/screens/dialogs/count_selection/widgets/penalty_amount_input.dart';
import 'package:quiz_app/presentation/screens/dialogs/count_selection/widgets/subtract_points_toggle.dart';

class AdvancedSettingsSection extends StatefulWidget {
  final bool isStudyMode;
  final bool isDark;
  final Color textColor;
  final Color subTextColor;
  final Color borderColor;
  final Color primaryColor;
  final Color controlBgColor;
  final Color controlIconColor;

  final bool subtractPoints;
  final double penaltyAmount;
  final TextEditingController penaltyController;
  final FocusNode penaltyFocusNode;
  final ValueChanged<bool> onSubtractPointsChanged;
  final ValueChanged<double> onPenaltyAmountChanged;
  final VoidCallback onIncrementPenalty;
  final VoidCallback onDecrementPenalty;

  final bool enableMaxIncorrectAnswers;
  final int maxIncorrectAnswersLimit;
  final TextEditingController maxIncorrectAnswersController;
  final FocusNode maxIncorrectAnswersFocusNode;
  final ValueChanged<bool> onEnableMaxIncorrectAnswersChanged;
  final ValueChanged<int> onMaxIncorrectAnswersLimitChanged;
  final VoidCallback onIncrementMaxIncorrect;
  final VoidCallback onDecrementMaxIncorrect;

  final QuestionOrder questionOrder;
  final ValueChanged<QuestionOrder> onQuestionOrderChanged;
  final bool randomizeAnswers;
  final ValueChanged<bool> onRandomizeAnswersChanged;
  final bool showCorrectAnswerCount;
  final ValueChanged<bool> onShowCorrectAnswerCountChanged;
  final bool examTimeEnabled;
  final ValueChanged<bool> onExamTimeEnabledChanged;
  final int examTimeMinutes;
  final ValueChanged<int> onExamTimeMinutesChanged;

  const AdvancedSettingsSection({
    super.key,
    required this.isStudyMode,
    required this.isDark,
    required this.textColor,
    required this.subTextColor,
    required this.borderColor,
    required this.primaryColor,
    required this.controlBgColor,
    required this.controlIconColor,
    required this.subtractPoints,
    required this.penaltyAmount,
    required this.penaltyController,
    required this.penaltyFocusNode,
    required this.onSubtractPointsChanged,
    required this.onPenaltyAmountChanged,
    required this.onIncrementPenalty,
    required this.onDecrementPenalty,
    required this.enableMaxIncorrectAnswers,
    required this.maxIncorrectAnswersLimit,
    required this.maxIncorrectAnswersController,
    required this.maxIncorrectAnswersFocusNode,
    required this.onEnableMaxIncorrectAnswersChanged,
    required this.onMaxIncorrectAnswersLimitChanged,
    required this.onIncrementMaxIncorrect,
    required this.onDecrementMaxIncorrect,
    required this.questionOrder,
    required this.onQuestionOrderChanged,
    required this.randomizeAnswers,
    required this.onRandomizeAnswersChanged,
    required this.showCorrectAnswerCount,
    required this.onShowCorrectAnswerCountChanged,
    required this.examTimeEnabled,
    required this.onExamTimeEnabledChanged,
    required this.examTimeMinutes,
    required this.onExamTimeMinutesChanged,
  });

  @override
  State<AdvancedSettingsSection> createState() =>
      _AdvancedSettingsSectionState();
}

class _AdvancedSettingsSectionState extends State<AdvancedSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToggleRow(
            title: AppLocalizations.of(context)!.questionOrderRandom,
            subtitle: widget.questionOrder == QuestionOrder.random
                ? AppLocalizations.of(context)!.questionOrderRandomDesc
                : AppLocalizations.of(context)!.questionOrderAscendingDesc,
            value: widget.questionOrder == QuestionOrder.random,
            onChanged: (value) {
              widget.onQuestionOrderChanged(
                value ? QuestionOrder.random : QuestionOrder.ascending,
              );
            },
          ),
          const SizedBox(height: 12),
          _buildToggleRow(
            title: AppLocalizations.of(context)!.randomizeAnswersTitle,
            subtitle: widget.randomizeAnswers
                ? AppLocalizations.of(context)!.randomizeAnswersDescription
                : AppLocalizations.of(context)!.randomizeAnswersOffDescription,
            value: widget.randomizeAnswers,
            onChanged: widget.onRandomizeAnswersChanged,
          ),
          const SizedBox(height: 12),
          _buildToggleRow(
            title: AppLocalizations.of(context)!.showCorrectAnswerCountTitle,
            subtitle: widget.showCorrectAnswerCount
                ? AppLocalizations.of(
                    context,
                  )!.showCorrectAnswerCountDescription
                : AppLocalizations.of(
                    context,
                  )!.showCorrectAnswerCountOffDescription,
            value: widget.showCorrectAnswerCount,
            onChanged: widget.onShowCorrectAnswerCountChanged,
          ),

          if (!widget.isStudyMode) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(
              AppLocalizations.of(context)!.examTimeLimitTitle,
            ),
            const SizedBox(height: 12),
            _buildToggleRow(
              title: AppLocalizations.of(context)!.enableTimeLimit,
              subtitle: AppLocalizations.of(context)!.examTimeLimitDescription,
              value: widget.examTimeEnabled,
              onChanged: widget.onExamTimeEnabledChanged,
            ),
            if (widget.examTimeEnabled) ...[
              const SizedBox(height: 12),
              _buildTimeLimitInput(),
            ],
          ],

          if (!widget.isStudyMode) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(
              AppLocalizations.of(context)!.scoringAndLimitsTitle,
            ),
            const SizedBox(height: 12),
            SubtractPointsToggle(
              isDark: widget.isDark,
              textColor: widget.textColor,
              primaryColor: widget.primaryColor,
              subtractPoints: widget.subtractPoints,
              penaltyAmount: widget.penaltyAmount,
              onSubtractPointsChanged: widget.onSubtractPointsChanged,
            ),
            if (widget.subtractPoints) ...[
              const SizedBox(height: 12),
              PenaltyAmountInput(
                textColor: widget.textColor,
                subTextColor: widget.subTextColor,
                primaryColor: widget.primaryColor,
                controlBgColor: widget.controlBgColor,
                controlIconColor: widget.controlIconColor,
                penaltyController: widget.penaltyController,
                penaltyFocusNode: widget.penaltyFocusNode,
                onPenaltyAmountChanged: widget.onPenaltyAmountChanged,
                onIncrementPenalty: widget.onIncrementPenalty,
                onDecrementPenalty: widget.onDecrementPenalty,
              ),
            ],
            const SizedBox(height: 16),
            MaxIncorrectToggle(
              isDark: widget.isDark,
              textColor: widget.textColor,
              subTextColor: widget.subTextColor,
              primaryColor: widget.primaryColor,
              enableMaxIncorrectAnswers: widget.enableMaxIncorrectAnswers,
              onEnableMaxIncorrectAnswersChanged:
                  widget.onEnableMaxIncorrectAnswersChanged,
            ),
            if (widget.enableMaxIncorrectAnswers) ...[
              const SizedBox(height: 12),
              MaxIncorrectLimitInput(
                isDark: widget.isDark,
                textColor: widget.textColor,
                subTextColor: widget.subTextColor,
                primaryColor: widget.primaryColor,
                controlBgColor: widget.controlBgColor,
                borderColor: widget.borderColor,
                maxIncorrectAnswersController:
                    widget.maxIncorrectAnswersController,
                maxIncorrectAnswersFocusNode:
                    widget.maxIncorrectAnswersFocusNode,
                onMaxIncorrectAnswersLimitChanged:
                    widget.onMaxIncorrectAnswersLimitChanged,
                onIncrementMaxIncorrect: widget.onIncrementMaxIncorrect,
                onDecrementMaxIncorrect: widget.onDecrementMaxIncorrect,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: widget.textColor,
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.controlBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.borderColor, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: widget.textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: widget.subTextColor,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: widget.primaryColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: widget.isDark
                ? AppTheme.zinc600
                : AppTheme.zinc300,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLimitInput() {
    return TextFormField(
      initialValue: widget.examTimeMinutes.toString(),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.timeLimitMinutes,
        labelStyle: TextStyle(fontFamily: 'Inter', color: widget.subTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.primaryColor),
        ),
        suffixText: AppLocalizations.of(context)!.minutesAbbreviation,
        suffixStyle: TextStyle(color: widget.subTextColor),
        filled: true,
        fillColor: widget.controlBgColor,
      ),
      style: TextStyle(fontFamily: 'Inter', color: widget.textColor),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final newMinutes = int.tryParse(value);
        if (newMinutes != null && newMinutes > 0) {
          widget.onExamTimeMinutesChanged(newMinutes);
        }
      },
    );
  }
}
