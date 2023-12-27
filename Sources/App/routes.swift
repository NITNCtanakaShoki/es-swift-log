import Fluent
import Vapor
import AsyncCommandRegister

func routes(_ app: Application) throws {
  app.get { req async in
    "It works!"
  }
  
  app.get("hello") { req async -> String in
    "Hello, world!"
  }
  
  app.commands.use(CountEventCommand(), as: "count-event")
  app.commands.use(CreateEventCommand(), as: "create-event")
  app.commands.use(CreateUserCommand(), as: "create-user")
  app.commands.use(DeleteAllUserCommand(), as: "delete-all-user")
  app.commands.use(DeleteUserCommand(), as: "delete-user")
  app.commands.use(MeasureCommand(), as: "measure")
  app.commands.use(OutputLogCommand(), as: "output-log")
  app.commands.use(DockerStatsCommand(), as: "docker-stats")
  app.commands.use(OutputDockerCommand(), as: "output-docker")
}
