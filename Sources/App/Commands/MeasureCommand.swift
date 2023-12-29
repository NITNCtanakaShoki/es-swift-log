import Vapor
import Fluent
import AsyncCommandRegister
import Foundation

struct MeasureCommand: AsyncCommand {
  struct Signature: CommandSignature {
    @Argument(name: "username1")
    var username1: String
    
    @Argument(name: "username2")
    var username2: String
    
    @Option(name: "until")
    var until: Int?
    
    @Flag(name: "stream")
    var stream: Bool
    
    @Flag(name: "chunk-10")
    var chunk10: Bool
    
    @Flag(name: "chunk-100")
    var chunk100: Bool
    
    @Flag(name: "chunk-1000")
    var chunk1000: Bool
    
    @Flag(name: "chunk-10000")
    var chunk10000: Bool
    
    @Flag(name: "paging-offset-10")
    var pagingOffset10: Bool
    
    @Flag(name: "paging-offset-100")
    var pagingOffset100: Bool
    
    @Flag(name: "paging-offset-1000")
    var pagingOffset1000: Bool
    
    @Flag(name: "paging-offset-10000")
    var pagingOffset10000: Bool
    
    @Flag(name: "paging-last-10")
    var pagingLast10: Bool
    
    @Flag(name: "paging-last-100")
    var pagingLast100: Bool
    
    @Flag(name: "paging-last-1000")
    var pagingLast1000: Bool
    
    @Flag(name: "paging-last-10000")
    var pagingLast10000: Bool
    
    @Flag(name: "paging-last-async-10")
    var pagingLastAsync10: Bool
    
    @Flag(name: "paging-last-async-100")
    var pagingLastAsync100: Bool
    
    @Flag(name: "paging-last-async-1000")
    var pagingLastAsync1000: Bool
    
    @Flag(name: "paging-last-async-10000")
    var pagingLastAsync10000: Bool
    
    @Flag(name: "yesConfirm", short: "y")
    var yesConfirm
  }
  
  let help = "指定されたusernameのUserを削除します。"
  
  func run(using context: CommandContext, signature: Signature) async throws {
    let until = signature.until ?? 1_000_000
    context.console.print("CPU: \(String(context.cpuPercent))%")
    context.console.print("Memory: \(String(context.memoryMB))MB")
    context.console.print("EnableIndex: \(String(context.enableIndex))")
    context.console.print("LoopSeconds: \(String(context.loopSeconds))")
    context.console.print("Until: \(String(until))")
    context.console.print("username1: \(signature.username1)")
    context.console.print("username2: \(signature.username2)")
    for kind in kinds(signature: signature) {
      context.console.print(kind.path)
    }
    guard signature.yesConfirm || context.console.confirm("以上の内容で計測を開始しても良いですか？") else {
      return
    }
    
    while true {
      let eventCount = try await context.api.eventCount(username: signature.username1)
      try await measure(using: context, signature: signature)
      guard eventCount < until else {
        context.console.print("[ INFO ] \(signature.username1) eventCount: \(eventCount)で計測終了しました。")
        break
      }
      let interval = switch eventCount {
      case 0 ..< 10_000: 1_000
      case 10_000 ..< 100_000: 10_000
      case 100_000 ..< 1_000_000: 100_000
      case 1_000_000 ..< 10_000_000: 1_000_000
      case 10_000_000 ..< 100_000_000: 10_000_000
      default: fatalError("eventCountが想定外の数字です。\(eventCount)")
      }
      let createEventCount = eventCount % interval == 0 ? interval : eventCount % interval
      try await context.api.createEvent(
        count: createEventCount,
        username1: signature.username1,
        username2: signature.username2
      )
      context.console.print("[ INFO ] \(signature.username1) eventCount: \(eventCount)で\(createEventCount)件のイベントを作成しました。")
    }
  }
  
  private func measure(using context: CommandContext, signature: Signature) async throws {
    let eventCount = try await context.api.eventCount(username: signature.username1)
    let allEventCount = try await context.api.allEventCount()
    let cpuPercent = context.cpuPercent
    let memoryMB = context.memoryMB
    let enableIndex = context.enableIndex
    let loopSeconds = context.loopSeconds
    
    for kind in kinds(signature: signature) {
      context.console.print("[ INFO ] イベント数: \(eventCount)で\(kind.path)の計測が開始されました。")
      let kindStart = Date()
      var measures = [Measure]()
      while Date().timeIntervalSince(kindStart) < loopSeconds {
        let start = Date()
        let result = try await context.api.point(kind: kind, username: signature.username1)
        let end = Date()
        
        let measure = Measure(
          cpuPercent: cpuPercent,
          memoryMB: memoryMB,
          kind: kind,
          start: start,
          end: end,
          userEventCount: eventCount,
          allEventCount: allEventCount,
          enableIndex: enableIndex,
          point: result.point,
          serverTime: result.time
        )
        measures.append(measure)
      }
      try await measures.create(on: context.application.db)
      Thread.sleep(forTimeInterval: 1)
    }
  }
  
  private func kinds(signature: Signature) -> [PointKind] {
    var kinds = [PointKind]()
    if signature.stream {
      kinds.append(.stream)
    }
    if signature.chunk10 {
      kinds.append(.chunk(count: 10))
    }
    if signature.chunk100 {
      kinds.append(.chunk(count: 100))
    }
    if signature.chunk1000 {
      kinds.append(.chunk(count: 1000))
    }
    if signature.chunk10000 {
      kinds.append(.chunk(count: 10000))
    }
    if signature.pagingOffset10 {
      kinds.append(.pagingOffset(count: 10))
    }
    if signature.pagingOffset100 {
      kinds.append(.pagingOffset(count: 100))
    }
    if signature.pagingOffset1000 {
      kinds.append(.pagingOffset(count: 1000))
    }
    if signature.pagingOffset10000 {
      kinds.append(.pagingOffset(count: 10000))
    }
    if signature.pagingLast10 {
      kinds.append(.pagingLast(count: 10))
    }
    if signature.pagingLast100 {
      kinds.append(.pagingLast(count: 100))
    }
    if signature.pagingLast1000 {
      kinds.append(.pagingLast(count: 1000))
    }
    if signature.pagingLast10000 {
      kinds.append(.pagingLast(count: 10000))
    }
    if signature.pagingLastAsync10 {
      kinds.append(.pagingLastAsync(count: 10))
    }
    if signature.pagingLastAsync100 {
      kinds.append(.pagingLastAsync(count: 100))
    }
    if signature.pagingLastAsync1000 {
      kinds.append(.pagingLastAsync(count: 1000))
    }
    if signature.pagingLastAsync10000 {
      kinds.append(.pagingLastAsync(count: 10000))
    }
    return kinds
  }
}

extension CommandContext {
  var cpuPercent: Int {
    Int(Environment.get("CPU_PERCENT")!)!
  }
  
  var memoryMB: Int {
    Int(Environment.get("MEMORY_MB")!)!
  }
  
  var enableIndex: Bool {
    let env = Environment.get("ENABLE_INDEX")!
    if env == "true" {
      return true
    }
    if env == "false" {
      return false
    }
    fatalError("環境変数: ENABLE_INDEXが不正です。\(env)")
  }
  
  var loopSeconds: TimeInterval {
    Environment.get("LOOP_SECONDS").flatMap(TimeInterval.init) ?? 10
  }
}
