import SwiftUI
import WidgetKit

struct LiveActivityMediumView: View {
  let contentState: LiveActivityAttributes.ContentState
  let attributes: LiveActivityAttributes
  @Binding var imageContainerSize: CGSize?
  let alignedImage: (String, HorizontalAlignment, Bool) -> AnyView

  private var hasImage: Bool {
    contentState.imageName != nil
  }

  private var progressViewTint: Color? {
    attributes.progressViewTint.map { Color(hex: $0) }
  }

  private var hasButton: Bool {
    contentState.subtitle != nil && (attributes.buttonBackgroundColor != nil || attributes.deepLinkUrl != nil)
  }

  var body: some View {
    let padding = attributes.resolvedPadding(defaultPadding: 16)

    let _ = contentState.logSegmentedProgressWarningIfNeeded()

    HStack(alignment: .center, spacing: 12) {
      // Left column: Logo, Title, Timer, Warnings
      VStack(alignment: .leading, spacing: 4) {
        // Logo at top
        if let imageName = contentState.imageName {
          Image.dynamic(assetNameOrPath: imageName)
            .resizable()
            .scaledToFit()
            .frame(height: 24)
        }

        // Title
        Text(contentState.title)
          .font(.title3)
          .fontWeight(.semibold)
          .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))

        // Timer
        if let startDate = contentState.elapsedTimerStartDateInMilliseconds {
          ElapsedTimerText(
            startTimeMilliseconds: startDate,
            color: attributes.progressViewLabelColor.map { Color(hex: $0) },
            pausedAtInMilliseconds: contentState.pausedAtInMilliseconds,
            totalPausedDurationInMilliseconds: contentState.totalPausedDurationInMilliseconds
          )
          .font(.title2)
          .fontWeight(.semibold)
        } else if contentState.hasSegmentedProgress,
                  let currentStep = contentState.currentStep,
                  let totalSteps = contentState.totalSteps,
                  totalSteps > 0 {
          SegmentedProgressView(
            currentStep: currentStep,
            totalSteps: totalSteps,
            activeColor: attributes.segmentActiveColor,
            inactiveColor: attributes.segmentInactiveColor
          )
        } else if let date = contentState.timerEndDateInMilliseconds {
          Text(timerInterval: Date.toTimerInterval(miliseconds: date))
            .font(.title2)
            .fontWeight(.semibold)
            .monospacedDigit()
            .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
        } else if let progress = contentState.progress {
          ProgressView(value: progress)
            .tint(progressViewTint)
            .modifier(ConditionalForegroundViewModifier(color: attributes.progressViewLabelColor))
        }

        // Warning/limit message
        if let limitText = contentState.limitText {
          Text(limitText)
            .font(.system(size: 14))
            .foregroundStyle(Color(hex: "ff3b30"))
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      // Right column: Save button (vertically centered)
      if let subtitle = contentState.subtitle, hasButton {
        SubtitleButtonView(
          subtitle: subtitle,
          deepLinkUrl: attributes.deepLinkUrl,
          buttonBackgroundColor: attributes.buttonBackgroundColor,
          buttonTextColor: attributes.buttonTextColor
        )
      } else if let subtitle = contentState.subtitle {
        Text(subtitle)
          .font(.title3)
          .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
      }
    }
    .padding(padding)
  }
}
