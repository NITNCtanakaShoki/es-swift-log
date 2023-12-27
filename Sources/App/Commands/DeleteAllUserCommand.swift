import Vapor
import Fluent
import AsyncCommandRegister

struct DeleteAllUserCommand: AsyncCommand {
  struct Signature: CommandSignature {}
  
  let help = "全てのユーザーを削除します。"
  
  func run(using context: CommandContext, signature: Signature) async throws {
    guard context.console.confirm("本当に全てのユーザーを削除しますか？") else {
      return
    }
    try await context.api.deleteAllUsers()
  }
}
