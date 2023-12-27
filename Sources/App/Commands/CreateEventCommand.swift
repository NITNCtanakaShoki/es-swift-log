import Vapor
import ConsoleKit
import Fluent

struct CreateEventCommand: AsyncCommand {
  
  struct Signature: CommandSignature {
    @Argument(name: "username1")
    var username1: String
    
    @Argument(name: "username2")
    var username2: String
    
    @Argument(name: "count")
    var count: Int
    
    @Flag(name: "add", short: "a", help: "countで指定した数までusername1のイベントを増やします。それに伴いusername2のイベントも同数だけ増加します。addとbyの両方を指定した場合はbyが優先されます。")
    var add: Bool

    @Flag(name: "by", short: "b", help: "イベントをcountで指定した数まで増やします。addとbyの両方を指定した場合はbyが優先されます。")
    var by: Bool
  }
  
  let help = "イベントを作成します"
  
  func run(using context: CommandContext, signature: Signature) async throws {
    if signature.by {
      guard context.console.confirm("\(signature.username1)のイベントを\(String(signature.count))個まで増やしていいですか？ （\(signature.username2)のイベント数も増加します") else {
        return
      }
      try await createEventBy(using: context, signature: signature)
      return
    }
    if signature.add {
      guard context.console.confirm("\(signature.username1)のイベントを\(String(signature.count))個だけ増やしていいですか？ （\(signature.username2)のイベント数も増加します") else {
        return
      }
      try await createEventAdd(using: context, signature: signature)
      return
    }
    context.console.print("[ WARNING ] --addまたは--byを指定してください")
  }
  
  private func createEventBy(using context: CommandContext, signature: Signature) async throws {
    let oldCount = try await context.api.eventCount(username: signature.username1)
    guard oldCount < signature.count else {
      context.console.print("[ ERROR ] \(signature.username1)のイベント数は\(oldCount)です。\(signature.count)より大きい値を指定してください")
      return
    }
    let addCount = signature.count - oldCount
    try await context.api.createEvent(
      count: addCount,
      username1: signature.username1,
      username2: signature.username2
    )
    context.console.print("[ INFO ] \(signature.username1)のイベントを\(signature.count)まで増やしました。同時に\(signature.username2)のイベント数が\(addCount)増えました。")
  }
  
  private func createEventAdd(using context: CommandContext, signature: Signature) async throws {
    try await context.api.createEvent(
      count: signature.count,
      username1: signature.username1,
      username2: signature.username2
    )
    context.console.print("[ INFO ] \(signature.username1)と\(signature.username2)のイベントを\(signature.count)個増やしました。")
  }
}
