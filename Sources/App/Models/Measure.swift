import Vapor
import Fluent

final class Measure: Model {
  static let schema = "measures"
  
  var id: UUID?
  
  @Field(key: "cpu_percent")
  var cpuPercent: Int
  
  @Field(key: "memory_mb")
  var memoryMB: Int
  
  @Enum(key: "way")
  var way: Way
  
  @Field(key: "chunk")
  var chunk: Int?
  
  @Field(key: "start")
  var start: Date
  
  @Field(key: "end")
  var end: Date
  
  @Field(key: "user_event_count")
  var userEventCount: Int
  
  @Field(key: "all_event_count")
  var allEventCount: Int
  
  @Field(key: "enable_index")
  var enableIndex: Bool
  
  @Field(key: "point")
  var point: Int
  
  @Field(key: "server_time")
  var serverTime: Double
  
  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?
  
  init() { }
  
  init(id: UUID? = nil, cpuPercent: Int, memoryMB: Int, way: Way, chunk: Int? = nil, start: Date, end: Date, userEventCount: Int, allEventCount: Int, enableIndex: Bool, point: Int, serverTime: Double, createdAt: Date? = nil) {
    self.id = id
    self.cpuPercent = cpuPercent
    self.memoryMB = memoryMB
    self.way = way
    self.chunk = chunk
    self.start = start
    self.end = end
    self.userEventCount = userEventCount
    self.allEventCount = allEventCount
    self.enableIndex = enableIndex
    self.point = point
    self.serverTime = serverTime
    self.createdAt = createdAt
  }
  
  init(id: UUID? = nil, cpuPercent: Int, memoryMB: Int, kind: PointKind, start: Date, end: Date, userEventCount: Int, allEventCount: Int, enableIndex: Bool, point: Int, serverTime: Double, createdAt: Date? = nil) {
    self.id = id
    self.cpuPercent = cpuPercent
    self.memoryMB = memoryMB
    self.way = .from(kind)
    self.chunk = kind.count
    self.start = start
    self.end = end
    self.userEventCount = userEventCount
    self.allEventCount = allEventCount
    self.enableIndex = enableIndex
    self.point = point
    self.serverTime = serverTime
    self.createdAt = createdAt
  }
}

extension Measure {
  enum Way: String, Sendable, Codable, Hashable {
    case stream = "stream"
    case chunk = "chunk"
    case pagingOffset = "paging-offset"
    case pagingLast = "paging-last"
    case pagingLastAsync = "paging-last-async"
    
    static func from(_ kind: PointKind) -> Self {
      switch kind {
      case .stream: .stream
      case .chunk(_): .chunk
      case .pagingOffset(_): .pagingOffset
      case .pagingLast(_): .pagingLast
      case .pagingLastAsync(_): .pagingLastAsync
      }
    }
  }
  
  var clientTime: TimeInterval {
    end.timeIntervalSince(start)
  }
}

