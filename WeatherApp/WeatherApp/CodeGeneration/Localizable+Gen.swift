// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Details {
    /// Time of data calculation - %@
    internal static func time(_ p1: String) -> String {
      return L10n.tr("Localizable", "details.time", p1)
    }
    internal enum Cloud {
      /// Cloudiness - %@%
      internal static func description(_ p1: String) -> String {
        return L10n.tr("Localizable", "details.cloud.description", p1)
      }
      /// Cloud
      internal static let title = L10n.tr("Localizable", "details.cloud.title")
    }
    internal enum Sunset {
      /// Sunrise - %1$@, Sunset  - %2$@
      internal static func description(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "details.sunset.description", p1, p2)
      }
      /// Sunrise/Sunset
      internal static let title = L10n.tr("Localizable", "details.sunset.title")
    }
    internal enum Temp {
      /// Temperature - %1$@ K\nMin - %2$@ K, Max - %3$@ K
      internal static func description(_ p1: String, _ p2: String, _ p3: String) -> String {
        return L10n.tr("Localizable", "details.temp.description", p1, p2, p3)
      }
      /// Temperature
      internal static let title = L10n.tr("Localizable", "details.temp.title")
    }
    internal enum Wind {
      /// Speed - %1$@ m/s, Direction - %2$@°
      internal static func description(_ p1: String, _ p2: String) -> String {
        return L10n.tr("Localizable", "details.wind.description", p1, p2)
      }
      /// Wind
      internal static let title = L10n.tr("Localizable", "details.wind.title")
    }
  }

  internal enum General {
    /// Error
    internal static let error = L10n.tr("Localizable", "general.error")
    internal enum Button {
      /// OK
      internal static let ok = L10n.tr("Localizable", "general.button.ok")
    }
  }

  internal enum List {
    internal enum Cities {
      /// Try again to load weather for cities
      internal static let tryAgain = L10n.tr("Localizable", "list.cities.try_again")
    }
    internal enum MyLocation {
      /// Location Services are not allowed!
      internal static let permission = L10n.tr("Localizable", "list.my_location.permission")
      /// My location: %@
      internal static func title(_ p1: String) -> String {
        return L10n.tr("Localizable", "list.my_location.title", p1)
      }
      /// Try again to load weather for my location
      internal static let tryAgain = L10n.tr("Localizable", "list.my_location.try_again")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
