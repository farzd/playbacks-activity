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
    applyIfPresent(urlString) { view, string in
      // If the string already contains a scheme (full URL), use it directly
      if string.contains("://") {
        return view.widgetURL(URL(string: string))
      }
      // Otherwise, prefix with the cached scheme
      return applyIfPresent(cachedScheme) { view, scheme in
        view.widgetURL(URL(string: scheme + "://" + string))
      }
    }
  }
}
