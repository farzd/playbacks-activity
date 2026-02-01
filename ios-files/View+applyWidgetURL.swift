import SwiftUI

private let cachedScheme: String? = {
  guard
    let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
    let schemes = urlTypes.first?["CFBundleURLSchemes"] as? [String],
    let firstScheme = schemes.first
  else {
    return nil
  }

  return firstScheme
}()

extension View {
  func applyWidgetURL(from urlString: String?) -> some View {
    let url: URL? = {
      guard let string = urlString else { return nil }
      // If the string already contains a scheme (full URL), use it directly
      if string.contains("://") {
        return URL(string: string)
      }
      // Otherwise, prefix with the cached scheme
      guard let scheme = cachedScheme else { return nil }
      return URL(string: scheme + "://" + string)
    }()

    return applyIfPresent(url) { view, url in
      view.widgetURL(url)
    }
  }
}
