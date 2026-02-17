import SwiftUI
import WidgetKit

struct LiveActivityMediumView: View {
  let contentState: LiveActivityAttributes.ContentState
  let attributes: LiveActivityAttributes
  var isStale: Bool = false
  @Binding var imageContainerSize: CGSize?
  let alignedImage: (String, HorizontalAlignment, Bool) -> AnyView

  private var showInterrupted: Bool {
    isStale || contentState.isInterrupted == true
  }

  private var hasButton: Bool {
    contentState.subtitle != nil && (attributes.buttonBackgroundColor != nil || attributes.deepLinkUrl != nil || contentState.deepLinkUrl != nil)
  }

  private var timerColor: Color {
    Color(hex: "000000")
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // White header with logo
      HStack {
        Image.dynamic(assetNameOrPath: "live_activity_image")
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
        // Row 1: Timer (or Interrupted text) + button
        HStack(alignment: .center, spacing: 16) {
          if showInterrupted {
            Text("Interrupted")
              .font(.system(size: 24, weight: .medium, design: .monospaced))
              .foregroundStyle(timerColor)
          } else {
            // Timer
            HStack(spacing: 8) {
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
          }

          Spacer()

          // Button: no deep link when interrupted (tap just opens app)
          if let subtitle = contentState.subtitle, hasButton {
            if showInterrupted {
              Text("Back")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(Color(hex: attributes.buttonBackgroundColor ?? "fe5b25"))
                .cornerRadius(12)
            } else {
              Link(destination: makeDeepLinkURL(contentState.deepLinkUrl ?? attributes.deepLinkUrl) ?? URL(string: "about:blank")!) {
                Text(subtitle)
                  .font(.system(size: 18, weight: .semibold))
                  .foregroundStyle(Color.white)
                  .padding(.horizontal, 32)
                  .padding(.vertical, 12)
                  .background(Color(hex: attributes.buttonBackgroundColor ?? "fe5b25"))
                  .cornerRadius(12)
              }
              .buttonStyle(.plain)
            }
          }
        }

        // Row 2: label
        if let limitText = contentState.limitText {
          Text(limitText)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(Color(hex: "6A6A69"))
        } else {
          HStack(spacing: 6) {
            if contentState.pausedAtInMilliseconds == nil && !showInterrupted {
              Circle()
                .fill(Color(hex: "ff3b30"))
                .frame(width: 9, height: 9)
            }
            Text(showInterrupted ? "Recording stopped unexpectedly" : contentState.title)
              .font(.system(size: 16))
              .foregroundStyle(Color(hex: "6A6A69"))
          }
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
