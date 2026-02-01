import SwiftUI
import WidgetKit

struct LiveActivityMediumView: View {
  let contentState: LiveActivityAttributes.ContentState
  let attributes: LiveActivityAttributes
  @Binding var imageContainerSize: CGSize?
  let alignedImage: (String, HorizontalAlignment, Bool) -> AnyView

  private var hasButton: Bool {
    contentState.subtitle != nil && (attributes.buttonBackgroundColor != nil || attributes.deepLinkUrl != nil)
  }

  private var timerColor: Color {
    Color(hex: "ff3b30")
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // White header with logo
      HStack {
        Image("logo_live_activity_image")
          .resizable()
          .scaledToFit()
          .frame(height: 26)
        Spacer()
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(Color.white)

      // Main content area
      VStack(alignment: .leading, spacing: 8) {
        // Row 1: Timer (with dot) + Save button
        HStack(alignment: .center, spacing: 16) {
          // Timer with red dot
          HStack(spacing: 8) {
            Circle()
              .fill(timerColor)
              .frame(width: 10, height: 10)

            if let startDate = contentState.elapsedTimerStartDateInMilliseconds {
              ElapsedTimerText(
                startTimeMilliseconds: startDate,
                color: timerColor,
                pausedAtInMilliseconds: contentState.pausedAtInMilliseconds,
                totalPausedDurationInMilliseconds: contentState.totalPausedDurationInMilliseconds
              )
              .font(.system(size: 32, weight: .medium, design: .monospaced))
            }
          }

          Spacer()

          // Save button
          if let subtitle = contentState.subtitle, hasButton {
            Link(destination: makeDeepLinkURL(attributes.deepLinkUrl) ?? URL(string: "about:blank")!) {
              Text(subtitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.white)
                .padding(.horizontal, 36)
                .padding(.vertical, 14)
                .background(Color(hex: attributes.buttonBackgroundColor ?? "fe5b25"))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
          }
        }

        // Row 2: "Recording..." label or warning message
        if let limitText = contentState.limitText {
          Text(limitText)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(timerColor)
        } else {
          Text(contentState.title)
            .font(.system(size: 16))
            .foregroundStyle(Color(hex: "6A6A69"))
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 14)
    }
  }

  private func makeDeepLinkURL(_ urlString: String?) -> URL? {
    guard let urlString = urlString else { return nil }
    // If the string already contains a scheme (full URL), use it directly
    if urlString.contains("://") {
      return URL(string: urlString)
    }
    // Otherwise, prefix with the app's URL scheme
    guard
      let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
      let schemes = urlTypes.first?["CFBundleURLSchemes"] as? [String],
      let scheme = schemes.first
    else {
      return nil
    }
    return URL(string: scheme + "://" + urlString)
  }
}
