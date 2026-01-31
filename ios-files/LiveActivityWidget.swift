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

@available(iOS 16.1, *)
public struct LiveActivityWidget: Widget {
  public var body: some WidgetConfiguration {
    let baseConfiguration = ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      LiveActivityView(contentState: context.state, attributes: context.attributes)
        .activityBackgroundTint(
          context.attributes.backgroundColor.map { Color(hex: $0) }
        )
        .activitySystemActionForegroundColor(Color.black)
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading, priority: 1) {
          dynamicIslandExpandedLeading(
            imageName: context.state.imageName,
            title: context.state.title
          )
          .dynamicIsland(verticalPlacement: .belowIfTooWide)
          .padding(.leading, 5)
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
        DynamicIslandExpandedRegion(.trailing) {
          if let subtitle = context.state.subtitle,
             context.attributes.buttonBackgroundColor != nil || context.attributes.deepLinkUrl != nil {
            SubtitleButtonView(
              subtitle: subtitle,
              deepLinkUrl: context.attributes.deepLinkUrl,
              buttonBackgroundColor: context.attributes.buttonBackgroundColor,
              buttonTextColor: context.attributes.buttonTextColor
            )
            .padding(.trailing, 5)
          } else if let imageName = context.state.imageName {
            dynamicIslandExpandedTrailing(imageName: imageName)
              .padding(.trailing, 5)
              .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
        }
        DynamicIslandExpandedRegion(.bottom) {
          if let startDate = context.state.elapsedTimerStartDateInMilliseconds {
            VStack(spacing: 2) {
              ElapsedTimerText(
                startTimeMilliseconds: startDate,
                color: context.attributes.progressViewTint.map { Color(hex: $0) } ?? .white,
                pausedAtInMilliseconds: context.state.pausedAtInMilliseconds,
                totalPausedDurationInMilliseconds: context.state.totalPausedDurationInMilliseconds
              )
              .font(.title2)
              .fontWeight(.semibold)

              if let limitText = context.state.limitText {
                Text(limitText)
                  .font(.system(size: 14))
                  .foregroundStyle(Color(hex: "ff3b30"))
              }
            }
            .padding(.top, 5)
            .padding(.horizontal, 5)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
          } else if let date = context.state.timerEndDateInMilliseconds {
            dynamicIslandExpandedBottom(
              endDate: date, progressViewTint: context.attributes.progressViewTint
            )
            .padding(.horizontal, 5)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
          } else if let progress = context.state.progress {
            dynamicIslandExpandedBottomProgress(
              progress: progress, progressViewTint: context.attributes.progressViewTint
            )
            .padding(.horizontal, 5)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
        }
      } compactLeading: {
        if let dynamicIslandImageName = context.state.dynamicIslandImageName {
          resizableImage(imageName: dynamicIslandImageName)
            .frame(maxWidth: 23, maxHeight: 23)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
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
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        } else if let date = context.state.timerEndDateInMilliseconds {
          compactTimer(
            endDate: date,
            timerType: context.attributes.timerType ?? .circular,
            progressViewTint: context.attributes.progressViewTint
          ).applyWidgetURL(from: context.attributes.deepLinkUrl)
        } else if let progress = context.state.progress {
          compactProgress(
            progress: progress,
            progressViewTint: context.attributes.progressViewTint
          ).applyWidgetURL(from: context.attributes.deepLinkUrl)
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
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        } else if let date = context.state.timerEndDateInMilliseconds {
          compactTimer(
            endDate: date,
            timerType: context.attributes.timerType ?? .circular,
            progressViewTint: context.attributes.progressViewTint
          ).applyWidgetURL(from: context.attributes.deepLinkUrl)
        } else if let progress = context.state.progress {
          compactProgress(
            progress: progress,
            progressViewTint: context.attributes.progressViewTint
          ).applyWidgetURL(from: context.attributes.deepLinkUrl)
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
    // Offset the start time by total paused duration to show correct elapsed time
    let totalPausedSeconds = (totalPausedDurationInMilliseconds ?? 0) / 1000
    return startTime.addingTimeInterval(totalPausedSeconds)
  }

  private var pauseTime: Date? {
    guard let pausedAt = pausedAtInMilliseconds else { return nil }
    return Date(timeIntervalSince1970: pausedAt / 1000)
  }

  var body: some View {
    // Use Text with timerInterval for Live Activities - iOS handles the updates automatically
    // The range goes from adjustedStartTime to a far future date, with countsDown: false to count UP
    // pauseTime freezes the timer display when set (during pause state)
    Text(
      timerInterval: adjustedStartTime ... Date.distantFuture,
      pauseTime: pauseTime,
      countsDown: false,
      showsHours: true
    )
    .monospacedDigit()
    .foregroundStyle(color ?? .primary)
  }
}
