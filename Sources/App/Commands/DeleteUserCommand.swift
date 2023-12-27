import Vapor
import Fluent
import AsyncCommandRegister

struct DeleteUserCommand: AsyncCommand {
  struct Signature: CommandSignature {
    @Argument(name: "username")
    var username: String
  }
  
  let help = "指定されたusernameのUserを削除します。"
  
  func run(using context: CommandContext, signature: Signature) async throws {
    guard context.console.confirm("\(signature.username)を削除しますか？") else {
      return
    }
    try await context.api.deleteUser(username: signature.username)
    context.console.print("[ INFO ] \(signature.username)を削除しました。")
  }
}
