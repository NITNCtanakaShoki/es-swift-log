import Vapor
import ConsoleKit
import Fluent

struct CountEventCommand: AsyncCommand {
  
  struct Signature: CommandSignature {
    @Option(name: "username", short: "u")
    var username: String?
  }
  
  let help = "イベント数を取得します。"
  
  func run(using context: CommandContext, signature: Signature) async throws {
    if let username = signature.username {
      let count = try await context.api.eventCount(username: username)
      context.console.print("[ INFO ] \(username)のイベント数は\(count)です。")
    } else {
      let count = try await context.api.allEventCount()
      context.console.print("[ INFO ] 全ユーザーのイベント数は\(count)です。")
    }
  }
}

