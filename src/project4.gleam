import argv
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/otp/actor
import message.{Start}
import simulator.{SimulatorState}

pub fn main() -> Nil {
  case argv.load().arguments {
    [num_users_str, num_subreddits_str, simulation_time_str] -> {
      case
        int.parse(num_users_str),
        int.parse(num_subreddits_str),
        int.parse(simulation_time_str)
      {
        Ok(num_users), Ok(num_subreddits), Ok(simulation_time) -> {
          io.println(
            "Starting simulation with "
            <> int.to_string(num_users)
            <> " users and "
            <> int.to_string(num_subreddits)
            <> " subreddits for "
            <> int.to_string(simulation_time)
            <> " seconds.",
          )
          let simulator_state =
            SimulatorState(
              num_users,
              num_subreddits,
              simulation_time,
              process.new_subject(),
            )

          let assert Ok(simulator_actor) =
            actor.new(simulator_state)
            |> actor.on_message(simulator.handle)
            |> actor.start()
          let simulator_subject = simulator_actor.data
          actor.send(
            simulator_subject,
            Start(num_users, num_subreddits, simulation_time, simulator_subject),
          )
          wait(simulator_actor.pid)
        }
        _, _, _ ->
          io.println(
            "Error: both arguments must be integers. Usage: program <num_users> <num_subreddits>, <simulation_time>",
          )
      }
    }
    _ ->
      io.println(
        "Usage: program <num_users> <num_subreddits>, <simulation_time>",
      )
  }
}

pub fn wait(process_pid: process.Pid) -> Nil {
  case process.is_alive(process_pid) {
    True -> {
      // Avoid busy-waiting; yield to the scheduler briefly
      process.sleep(1000)
      wait(process_pid)
    }
    False -> {
      io.println("Exiting program.")
    }
  }
}
