import Vapor
import Fluent

final class API: Sendable {
  private let app: Vapor.Application
  let baseURL: String
  
  init(app: Vapor.Application, baseURL: String) {
    self.app = app
    self.baseURL = baseURL
  }
  
  var client: Vapor.Client {
    app.client
  }
  
  var db: any Fluent.Database {
    app.db
  }
  
  var logger: Logger {
    app.logger
  }
}

extension CommandContext {
  var api: API {
    .init(app: application, baseURL: Environment.get("BASE_URL")!)
  }
}

struct ErrorResponse: Content {
  var reason: String
}

extension Date {
  var formatted: String {
    let formatter = DateFormatter()
    formatter.locale = .init(identifier: "ja_JP")
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss SSS"
  
    return formatter.string(from: self)
  }
}
