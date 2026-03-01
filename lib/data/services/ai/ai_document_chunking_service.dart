// Copyright (C) 2026 Víctor Carreras
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:quizdy/core/l10n/app_localizations.dart';
import 'package:quizdy/domain/models/quiz/source_reference.dart';

class _TextBatch {
  final String text;
  final int baseOffset;

  const _TextBatch({required this.text, required this.baseOffset});
}

/// Service responsible for parsing documents into semantic chunks locally.
class AiDocumentChunkingService {
  static AiDocumentChunkingService? _instance;

  /// Singleton instance
  static AiDocumentChunkingService get instance =>
      _instance ??= AiDocumentChunkingService._();

  AiDocumentChunkingService._();

  /// Identifies structural chunks within a document locally.
  ///
  /// Splits the text iteratively in ~3000 character bursts suitable for
  /// later Just-In-Time semantic processing while avoiding UI locks.
  ///
  /// - [documentText]: The full text extracted from the document.
  /// - [documentId]: A unique identifier for the document.
  /// - [localizations]: Localization bundle for default names.
  /// - Returns: A mapped global list of `SourceReference` indicating the text slices.
  Future<List<SourceReference>> chunkDocument(
    String documentText,
    String documentId,
    AppLocalizations localizations,
  ) async {
    const maxCharsPerBatch = 3000;
    List<SourceReference> allReferences = [];
    int currentGlobalOffset = 0;
    final int textLength = documentText.length;

    int currentIteration = 0;

    while (currentGlobalOffset < textLength) {
      currentIteration++;

      final batch = _getNextBatch(
        documentText,
        currentGlobalOffset,
        maxCharsPerBatch,
      );

      final reference = SourceReference(
        documentId: documentId,
        startOffset: batch.baseOffset,
        endOffset: batch.baseOffset + batch.text.length,
        startPage:
            1, // Will be mapped later if PDF layout is supported natively
        endPage: 1,
        blockType: 'Section $currentIteration', // Generic initial state
      );

      allReferences.add(reference);

      // Safety advance minimum 1 character to avoid infinite loops if breakIndex matches start
      currentGlobalOffset =
          batch.baseOffset + (batch.text.isNotEmpty ? batch.text.length : 1);
    }

    return allReferences;
  }

  _TextBatch _getNextBatch(String text, int startOffset, int maxChars) {
    final textLength = text.length;

    if (textLength - startOffset <= maxChars) {
      return _TextBatch(
        text: text.substring(startOffset),
        baseOffset: startOffset,
      );
    }

    int end = startOffset + maxChars;

    // Ensure we do not slice words or paragraphs aggressively if feasible
    int breakIndex = text.lastIndexOf('\n\n', end);
    if (breakIndex <= startOffset) breakIndex = text.lastIndexOf('\n', end);
    if (breakIndex <= startOffset) breakIndex = text.lastIndexOf('. ', end);
    if (breakIndex <= startOffset) breakIndex = text.lastIndexOf(' ', end);
    if (breakIndex <= startOffset) {
      breakIndex = end; // Last resort hard-cut limit
    }

    // In the case of paragraphs/sentences dot, we want to include the separator itself
    if (breakIndex != end &&
        text[breakIndex] == '.' &&
        text.length > breakIndex + 1 &&
        text[breakIndex + 1] == ' ') {
      breakIndex += 1; // Include the period
    } else if (breakIndex != end && text[breakIndex] == '\n') {
      breakIndex += 1; // Include newline
    }

    // Do NOT trim here. Trimming the front alters the relative offset index!
    return _TextBatch(
      text: text.substring(startOffset, breakIndex),
      baseOffset: startOffset,
    );
  }
}
