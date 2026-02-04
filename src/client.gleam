import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import message.{
  type ClientMsg, type RedditEngineMsg, AddAccount, CreateAccount, CreateComment,
  CreateCommentClient, CreateCommentReply, CreateCommentReplyClient, CreatePost,
  CreatePostClient, DownvotePost, DownvotePostClient, GetDirectMessages,
  GetDirectMessagesClient, GetFeed, GetFeedClient, Initialize, JoinSubReddit,
  JoinSubRedditClient, LeaveSubReddit, LeaveSubRedditClient, SendMessage,
  SendMessageClient, TerminateClient, UpvotePost, UpvotePostClient,
}

pub type ClientState {
  ClientState(
    username: String,
    password: String,
    client_subject: Subject(ClientMsg),
    engine_subject: Subject(RedditEngineMsg),
  )
}

pub fn handle(
  state: ClientState,
  message: ClientMsg,
) -> actor.Next(ClientState, ClientMsg) {
  case message {
    Initialize(client_subject, engine_subject) -> {
      actor.continue(ClientState(
        state.username,
        state.password,
        client_subject,
        engine_subject,
      ))
    }

    CreateAccount(username, password) -> {
      //Send a CreateAccount message to the Reddit engine
      actor.send(state.engine_subject, AddAccount(username, password))
      actor.continue(state)
    }

    JoinSubRedditClient(subreddit_id) -> {
      actor.send(
        state.engine_subject,
        JoinSubReddit(state.username, subreddit_id),
      )
      actor.continue(state)
    }

    LeaveSubRedditClient(subreddit_id) -> {
      actor.send(
        state.engine_subject,
        LeaveSubReddit(state.username, subreddit_id),
      )
      actor.continue(state)
    }

    CreatePostClient(subreddit_id, content) -> {
      actor.send(
        state.engine_subject,
        CreatePost(state.username, subreddit_id, content),
      )
      actor.continue(state)
    }

    CreateCommentClient(subreddit_id, comment) -> {
      actor.send(
        state.engine_subject,
        CreateComment(state.username, subreddit_id, comment),
      )
      actor.continue(state)
    }

    CreateCommentReplyClient(subreddit_id, reply) -> {
      actor.send(
        state.engine_subject,
        CreateCommentReply(state.username, subreddit_id, reply),
      )
      actor.continue(state)
    }

    UpvotePostClient(subreddit_id) -> {
      actor.send(state.engine_subject, UpvotePost(state.username, subreddit_id))
      actor.continue(state)
    }

    DownvotePostClient(subreddit_id) -> {
      actor.send(
        state.engine_subject,
        DownvotePost(state.username, subreddit_id),
      )
      actor.continue(state)
    }

    SendMessageClient(receiver_id, message) -> {
      actor.send(
        state.engine_subject,
        SendMessage(state.username, receiver_id, message),
      )
      actor.continue(state)
    }
    GetFeedClient -> {
      actor.send(state.engine_subject, GetFeed(state.username))
      actor.continue(state)
    }

    GetDirectMessagesClient -> {
      actor.send(state.engine_subject, GetDirectMessages(state.username))
      actor.continue(state)
    }

    TerminateClient -> {
      actor.stop()
    }
  }
}
