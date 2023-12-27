import Vapor
import Fluent
import AsyncCommandRegister

struct CreateUserCommand: AsyncCommand {
  struct Signature: CommandSignature {
    @Argument(name: "username")
    var username: String
  }
  
  let help = "指定されたusernameのUserを作成します。"
  
  func run(using context: CommandContext, signature: Signature) async throws {
    try await context.api.createUser(username: signature.username)
    context.console.print("[ INFO ] \(signature.username)を作成しました。")
  }
}
