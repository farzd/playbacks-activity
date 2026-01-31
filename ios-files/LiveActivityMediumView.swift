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

// MARK: - Preview

#if DEBUG
@available(iOS 16.2, *)
struct LiveActivityMediumView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      // Recording state
      LiveActivityMediumView(
        contentState: .init(
          title: "Recording...",
          subtitle: "Save",
          imageName: "logo_live_activity_image",
          elapsedTimerStartDateInMilliseconds: Date().addingTimeInterval(-754).timeIntervalSince1970 * 1000
        ),
        attributes: .init(
          name: "Preview",
          backgroundColor: "#faf9f6",
          titleColor: "#000000",
          progressViewLabelColor: "#000000",
          deepLinkUrl: "/liveactivity/save",
          buttonBackgroundColor: "#fe5b25",
          buttonTextColor: "#ffffff"
        ),
        imageContainerSize: .constant(nil),
        alignedImage: { _, _, _ in AnyView(EmptyView()) }
      )
      .background(Color(hex: "#faf9f6"))
      .previewDisplayName("Recording")

      // Paused state
      LiveActivityMediumView(
        contentState: .init(
          title: "Paused",
          subtitle: "Save",
          imageName: "logo_live_activity_image",
          elapsedTimerStartDateInMilliseconds: Date().addingTimeInterval(-1234).timeIntervalSince1970 * 1000,
          pausedAtInMilliseconds: Date().timeIntervalSince1970 * 1000,
          totalPausedDurationInMilliseconds: 60000
        ),
        attributes: .init(
          name: "Preview",
          backgroundColor: "#faf9f6",
          titleColor: "#000000",
          progressViewLabelColor: "#000000",
          deepLinkUrl: "/liveactivity/save",
          buttonBackgroundColor: "#fe5b25",
          buttonTextColor: "#ffffff"
        ),
        imageContainerSize: .constant(nil),
        alignedImage: { _, _, _ in AnyView(EmptyView()) }
      )
      .background(Color(hex: "#faf9f6"))
      .previewDisplayName("Paused")

      // Limit reached state
      LiveActivityMediumView(
        contentState: .init(
          title: "Paused",
          subtitle: "Save",
          imageName: "logo_live_activity_image",
          elapsedTimerStartDateInMilliseconds: Date().addingTimeInterval(-3600).timeIntervalSince1970 * 1000,
          pausedAtInMilliseconds: Date().timeIntervalSince1970 * 1000,
          limitText: "1 hour limit reached!"
        ),
        attributes: .init(
          name: "Preview",
          backgroundColor: "#faf9f6",
          titleColor: "#000000",
          progressViewLabelColor: "#000000",
          deepLinkUrl: "/liveactivity/save",
          buttonBackgroundColor: "#fe5b25",
          buttonTextColor: "#ffffff"
        ),
        imageContainerSize: .constant(nil),
        alignedImage: { _, _, _ in AnyView(EmptyView()) }
      )
      .background(Color(hex: "#faf9f6"))
      .previewDisplayName("Limit Reached")
    }
    .previewLayout(.fixed(width: 360, height: 160))
  }
}
#endif
