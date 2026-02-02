import ActivityKit
import SwiftUI
import WidgetKit

public struct LiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var title: String
    var subtitle: String?
    var timerEndDateInMilliseconds: Double?
    var progress: Double?
    var imageName: String?
    var dynamicIslandImageName: String?
    var smallImageName: String?
    var elapsedTimerStartDateInMilliseconds: Double?
    var currentStep: Int?
    var totalSteps: Int?
    var pausedAtInMilliseconds: Double?
    var totalPausedDurationInMilliseconds: Double?
    var limitText: String?

    public init(
      title: String,
      subtitle: String? = nil,
      timerEndDateInMilliseconds: Double? = nil,
      progress: Double? = nil,
      imageName: String? = nil,
      dynamicIslandImageName: String? = nil,
      smallImageName: String? = nil,
      elapsedTimerStartDateInMilliseconds: Double? = nil,
      currentStep: Int? = nil,
      totalSteps: Int? = nil,
      pausedAtInMilliseconds: Double? = nil,
      totalPausedDurationInMilliseconds: Double? = nil,
      limitText: String? = nil
    ) {
      self.title = title
      self.subtitle = subtitle
      self.timerEndDateInMilliseconds = timerEndDateInMilliseconds
      self.progress = progress
      self.imageName = imageName
      self.dynamicIslandImageName = dynamicIslandImageName
      self.smallImageName = smallImageName
      self.elapsedTimerStartDateInMilliseconds = elapsedTimerStartDateInMilliseconds
      self.currentStep = currentStep
      self.totalSteps = totalSteps
      self.pausedAtInMilliseconds = pausedAtInMilliseconds
      self.totalPausedDurationInMilliseconds = totalPausedDurationInMilliseconds
      self.limitText = limitText
    }
  }

  var name: String
  var backgroundColor: String?
  var titleColor: String?
  var subtitleColor: String?
  var progressViewTint: String?
  var progressViewLabelColor: String?
  var deepLinkUrl: String?
  var timerType: DynamicIslandTimerType?
  var padding: Int?
  var paddingDetails: PaddingDetails?
  var imagePosition: String?
  var imageWidth: Int?
  var imageHeight: Int?
  var imageWidthPercent: Double?
  var imageHeightPercent: Double?
  var smallImageWidth: Int?
  var smallImageHeight: Int?
  var smallImageWidthPercent: Double?
  var smallImageHeightPercent: Double?
  var imageAlign: String?
  var contentFit: String?
  var progressSegmentActiveColor: String?
  var progressSegmentInactiveColor: String?
  var buttonBackgroundColor: String?
  var buttonTextColor: String?

  public init(
    name: String,
    backgroundColor: String? = nil,
    titleColor: String? = nil,
    subtitleColor: String? = nil,
    progressViewTint: String? = nil,
    progressViewLabelColor: String? = nil,
    deepLinkUrl: String? = nil,
    timerType: DynamicIslandTimerType? = nil,
    padding: Int? = nil,
    paddingDetails: PaddingDetails? = nil,
    imagePosition: String? = nil,
    imageWidth: Int? = nil,
    imageHeight: Int? = nil,
    imageWidthPercent: Double? = nil,
    imageHeightPercent: Double? = nil,
    smallImageWidth: Int? = nil,
    smallImageHeight: Int? = nil,
    smallImageWidthPercent: Double? = nil,
    smallImageHeightPercent: Double? = nil,
    imageAlign: String? = nil,
    contentFit: String? = nil,
    progressSegmentActiveColor: String? = nil,
    progressSegmentInactiveColor: String? = nil,
    buttonBackgroundColor: String? = nil,
    buttonTextColor: String? = nil
  ) {
    self.name = name
    self.backgroundColor = backgroundColor
    self.titleColor = titleColor
    self.subtitleColor = subtitleColor
    self.progressViewTint = progressViewTint
    self.progressViewLabelColor = progressViewLabelColor
    self.deepLinkUrl = deepLinkUrl
    self.timerType = timerType
    self.padding = padding
    self.paddingDetails = paddingDetails
    self.imagePosition = imagePosition
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
    self.imageWidthPercent = imageWidthPercent
    self.imageHeightPercent = imageHeightPercent
    self.smallImageWidth = smallImageWidth
    self.smallImageHeight = smallImageHeight
    self.smallImageWidthPercent = smallImageWidthPercent
    self.smallImageHeightPercent = smallImageHeightPercent
    self.imageAlign = imageAlign
    self.contentFit = contentFit
    self.progressSegmentActiveColor = progressSegmentActiveColor
    self.progressSegmentInactiveColor = progressSegmentInactiveColor
    self.buttonBackgroundColor = buttonBackgroundColor
    self.buttonTextColor = buttonTextColor
  }

  public enum DynamicIslandTimerType: String, Codable {
    case circular
    case digital
  }

  public struct PaddingDetails: Codable, Hashable {
    var top: Int?
    var bottom: Int?
    var left: Int?
    var right: Int?
    var vertical: Int?
    var horizontal: Int?

    public init(
      top: Int? = nil,
      bottom: Int? = nil,
      left: Int? = nil,
      right: Int? = nil,
      vertical: Int? = nil,
      horizontal: Int? = nil
    ) {
      self.top = top
      self.bottom = bottom
      self.left = left
      self.right = right
      self.vertical = vertical
      self.horizontal = horizontal
    }
  }
}

// MARK: - Dynamic Island Save Button

@available(iOS 16.1, *)
struct DynamicIslandSaveButton: View {
  let subtitle: String
  let deepLinkUrl: String?
  let buttonBackgroundColor: String?
  let buttonTextColor: String?

  private var backgroundColor: Color {
    buttonBackgroundColor.map { Color(hex: $0) } ?? Color(hex: "fe5b25")
  }

  private var textColor: Color {
    buttonTextColor.map { Color(hex: $0) } ?? .white
  }

  private func makeDeepLinkURL(_ urlString: String?) -> URL? {
    guard let urlString = urlString else { return nil }
    if urlString.contains("://") {
      return URL(string: urlString)
    }
    guard
      let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
      let schemes = urlTypes.first?["CFBundleURLSchemes"] as? [String],
      let scheme = schemes.first
    else {
      return nil
    }
    return URL(string: scheme + "://" + urlString)
  }

  var body: some View {
    if let url = makeDeepLinkURL(deepLinkUrl) {
      Link(destination: url) {
        buttonContent
      }
      .buttonStyle(.plain)
    } else {
      buttonContent
    }
  }

  private var buttonContent: some View {
    Text(subtitle)
      .font(.system(size: 14, weight: .semibold))
      .foregroundStyle(textColor)
      .padding(.horizontal, 20)
      .padding(.vertical, 8)
      .background(backgroundColor)
      .cornerRadius(8)
  }
}

@available(iOS 16.1, *)
public struct LiveActivityWidget: Widget {
  public var body: some WidgetConfiguration {
    let baseConfiguration = ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      LiveActivityView(contentState: context.state, attributes: context.attributes)
        .activityBackgroundTint(
          context.attributes.backgroundColor.map { Color(hex: $0) }
        )
        .activitySystemActionForegroundColor(Color.black)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Image.dynamic(assetNameOrPath: "dynamic_island_expanded_image")
            .resizable()
            .scaledToFit()
            .frame(height: 20)
            .padding(.leading, 5)
        }
        DynamicIslandExpandedRegion(.trailing) {
          EmptyView()
        }
        DynamicIslandExpandedRegion(.bottom) {
          VStack(alignment: .leading, spacing: 8) {
            // Row 1: Timer + Save button
            HStack(alignment: .center, spacing: 12) {
              // Timer
              HStack(spacing: 6) {
                if let startDate = context.state.elapsedTimerStartDateInMilliseconds {
                  ElapsedTimerText(
                    startTimeMilliseconds: startDate,
                    color: .white,
                    pausedAtInMilliseconds: context.state.pausedAtInMilliseconds,
                    totalPausedDurationInMilliseconds: context.state.totalPausedDurationInMilliseconds
                  )
                  .font(.system(size: 24, weight: .medium, design: .monospaced))
                } else if let date = context.state.timerEndDateInMilliseconds {
                  Text(timerInterval: Date.toTimerInterval(miliseconds: date))
                    .font(.system(size: 24, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white)
                }
              }

              Spacer()

              // Save button
              if let subtitle = context.state.subtitle,
                 context.attributes.buttonBackgroundColor != nil || context.attributes.deepLinkUrl != nil {
                DynamicIslandSaveButton(
                  subtitle: subtitle,
                  deepLinkUrl: context.attributes.deepLinkUrl,
                  buttonBackgroundColor: context.attributes.buttonBackgroundColor,
                  buttonTextColor: context.attributes.buttonTextColor
                )
              }
            }

            // Row 2: "Recording..." label or warning message
            if let limitText = context.state.limitText {
              Text(limitText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
            } else {
              HStack(spacing: 5) {
                if context.state.pausedAtInMilliseconds == nil {
                  Circle()
                    .fill(Color(hex: "ff3b30"))
                    .frame(width: 8, height: 8)
                }
                Text(context.state.title)
                  .font(.system(size: 14))
                  .foregroundStyle(.white)
              }
            }
          }
          .padding(.horizontal, 5)
          .padding(.top, 5)
        }
      } compactLeading: {
        Image.dynamic(assetNameOrPath: "dynamic_island_image")
          .resizable()
          .scaledToFit()
          .frame(maxWidth: 23, maxHeight: 23)
      } compactTrailing: {
        if let startDate = context.state.elapsedTimerStartDateInMilliseconds {
          ElapsedTimerText(
            startTimeMilliseconds: startDate,
            color: nil,
            pausedAtInMilliseconds: context.state.pausedAtInMilliseconds,
            totalPausedDurationInMilliseconds: context.state.totalPausedDurationInMilliseconds
          )
          .font(.system(size: 15))
          .minimumScaleFactor(0.8)
          .fontWeight(.semibold)
          .frame(maxWidth: 60)
          .multilineTextAlignment(.trailing)
        } else if let date = context.state.timerEndDateInMilliseconds {
          compactTimer(
            endDate: date,
            timerType: context.attributes.timerType ?? .circular,
            progressViewTint: context.attributes.progressViewTint
          )
        } else if let progress = context.state.progress {
          compactProgress(
            progress: progress,
            progressViewTint: context.attributes.progressViewTint
          )
        }
      } minimal: {
        if let startDate = context.state.elapsedTimerStartDateInMilliseconds {
          ElapsedTimerText(
            startTimeMilliseconds: startDate,
            color: context.attributes.progressViewTint.map { Color(hex: $0) },
            pausedAtInMilliseconds: context.state.pausedAtInMilliseconds,
            totalPausedDurationInMilliseconds: context.state.totalPausedDurationInMilliseconds
          )
          .font(.system(size: 11))
          .minimumScaleFactor(0.6)
        } else if let date = context.state.timerEndDateInMilliseconds {
          compactTimer(
            endDate: date,
            timerType: context.attributes.timerType ?? .circular,
            progressViewTint: context.attributes.progressViewTint
          )
        } else if let progress = context.state.progress {
          compactProgress(
            progress: progress,
            progressViewTint: context.attributes.progressViewTint
          )
        }
      }
    }

    if #available(iOS 18.0, *) {
      return baseConfiguration.supplementalActivityFamilies([.small])
    } else {
      return baseConfiguration
    }
  }

  public init() {}

  @ViewBuilder
  private func compactTimer(
    endDate: Double,
    timerType: LiveActivityAttributes.DynamicIslandTimerType,
    progressViewTint: String?
  ) -> some View {
    if timerType == .digital {
      Text(timerInterval: Date.toTimerInterval(miliseconds: endDate))
        .font(.system(size: 15))
        .minimumScaleFactor(0.8)
        .fontWeight(.semibold)
        .frame(maxWidth: 60)
        .multilineTextAlignment(.trailing)
    } else {
      circularTimer(endDate: endDate)
        .tint(progressViewTint.map { Color(hex: $0) })
    }
  }

  private func dynamicIslandExpandedLeading(imageName: String?, title: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Spacer()
      if let imageName {
        Image.dynamic(assetNameOrPath: imageName)
          .resizable()
          .scaledToFit()
          .frame(height: 20)
      }
      Text(title)
        .font(.title3)
        .foregroundStyle(.white)
        .fontWeight(.semibold)
      Spacer()
    }
  }

  private func dynamicIslandExpandedTrailing(imageName: String) -> some View {
    VStack {
      Spacer()
      resizableImage(imageName: imageName)
      Spacer()
    }
  }

  private func dynamicIslandExpandedBottom(endDate: Double, progressViewTint: String?) -> some View {
    ProgressView(timerInterval: Date.toTimerInterval(miliseconds: endDate))
      .foregroundStyle(.white)
      .tint(progressViewTint.map { Color(hex: $0) })
      .padding(.top, 5)
  }

  private func circularTimer(endDate: Double) -> some View {
    ProgressView(
      timerInterval: Date.toTimerInterval(miliseconds: endDate),
      countsDown: false,
      label: { EmptyView() },
      currentValueLabel: {
        EmptyView()
      }
    )
    .progressViewStyle(.circular)
  }

  private func compactProgress(
    progress: Double,
    progressViewTint: String?
  ) -> some View {
    ProgressView(value: progress)
      .progressViewStyle(.circular)
      .tint(progressViewTint.map { Color(hex: $0) })
  }

  private func dynamicIslandExpandedBottomProgress(progress: Double, progressViewTint: String?) -> some View {
    ProgressView(value: progress)
      .foregroundStyle(.white)
      .tint(progressViewTint.map { Color(hex: $0) })
      .padding(.top, 5)
  }
}

// MARK: - Elapsed Timer View

struct ElapsedTimerText: View {
  let startTimeMilliseconds: Double
  let color: Color?
  var pausedAtInMilliseconds: Double? = nil
  var totalPausedDurationInMilliseconds: Double? = nil

  private var startTime: Date {
    Date(timeIntervalSince1970: startTimeMilliseconds / 1000)
  }

  private var adjustedStartTime: Date {
    let totalPausedSeconds = (totalPausedDurationInMilliseconds ?? 0) / 1000
    return startTime.addingTimeInterval(totalPausedSeconds)
  }

  private var pauseTime: Date? {
    guard let pausedAt = pausedAtInMilliseconds else { return nil }
    return Date(timeIntervalSince1970: pausedAt / 1000)
  }

  private var formattedPausedTime: String {
    guard let pauseTime = pauseTime else { return "0:00" }
    let elapsed = Int(pauseTime.timeIntervalSince(adjustedStartTime))
    let total = max(0, elapsed)
    let hours = total / 3600
    let minutes = (total % 3600) / 60
    let seconds = total % 60

    if hours > 0 {
      return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    } else {
      return String(format: "%d:%02d", minutes, seconds)
    }
  }

  var body: some View {
    if pauseTime != nil {
      // When paused, show static zero-padded time
      Text(formattedPausedTime)
        .foregroundStyle(color ?? .primary)
    } else {
      // When running, use system timer (iOS handles updates automatically)
      Text(
        timerInterval: adjustedStartTime ... Date.distantFuture,
        pauseTime: nil,
        countsDown: false,
        showsHours: true
      )
      .foregroundStyle(color ?? .primary)
    }
  }
}

// MARK: - Previews

#if DEBUG
@available(iOS 17.0, *)
#Preview("Recording") {
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
  .frame(width: 360, height: 160)
}

@available(iOS 17.0, *)
#Preview("Paused") {
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
  .frame(width: 360, height: 160)
}

@available(iOS 17.0, *)
#Preview("Limit Reached") {
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
  .frame(width: 360, height: 160)
}
#endif
