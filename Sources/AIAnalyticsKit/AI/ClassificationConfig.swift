// MARK: - Classification Configuration

/// Single source of truth for all classification thresholds and confidence values.
/// Both `FoundationPredictionEngine` and `CoreMLPredictionEngine` reference these
/// constants so threshold changes are applied consistently across all engines.
///
/// Integrators can read these values to display thresholds in their own UI
/// without duplicating magic numbers.
public enum ClassificationConfig {

    // MARK: - Heuristic Thresholds

    /// Error rate above this value classifies a user as At-Risk.
    public static let atRiskErrorRate: Double = 0.3

    /// Minimum total event count for a Power User classification.
    public static let powerUserMinEvents: Int = 50

    /// Minimum analysis event count for a Power User classification.
    public static let powerUserMinAnalyses: Int = 10

    /// Minimum unique screen count for an Explorer classification.
    public static let explorerMinScreens: Int = 5

    // MARK: - Prediction Confidence

    /// Confidence assigned to predictions from the Foundation Models engine
    /// (on-device LLM response). Reflects the model's general language capability
    /// applied to a structured classification task.
    public static let foundationModelConfidence: Double = 0.85

    /// Confidence assigned to heuristic fallback predictions used when the
    /// Foundation Models or CoreML engine is unavailable (e.g., on Simulator).
    public static let heuristicFallbackConfidence: Double = 0.60

    /// Confidence assigned to CoreML model predictions. Update when you have
    /// real model accuracy metrics from evaluation.
    public static let coreMLModelConfidence: Double = 0.75
}
