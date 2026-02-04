import gleam/erlang/process.{type Subject}
import types.{type Account}

pub type SimulatorMsg {
  Start(
    nums_users: Int,
    num_subreddits: Int,
    simulation_time: Int,
    simulator_subject: Subject(SimulatorMsg),
  )
}

pub type RedditEngineMsg {
    Init(engine_subject: Subject(RedditEngineMsg), simulator_subject: Subject(SimulatorMsg))
    AddAccount(username: String, password: String)
    UpdateAccount(account: Account)
    CreateSubReddit(name: String, description: String)
    JoinSubReddit(user_id: String, subreddit_id: String)
    LeaveSubReddit(user_id: String, subreddit_id: String)
    CreatePost(user_id: String, subreddit_id: String, content: String)
    CreateComment(user_id: String, subreddit_id: String, comment: String)
    CreateCommentReply(user_id: String, subreddit_id: String, reply: String)
    UpvotePost(user_id: String, subreddit_id: String)
    DownvotePost(user_id: String, subreddit_id: String)
    SendMessage(sender_id: String, receiver_id: String, message: String)
    GetFeed(user_id: String)
    GetDirectMessages(user_id: String)
    PrintStats()
}

pub type ClientMsg {
  Initialize(client_subject: Subject(ClientMsg), engine_subject: Subject(RedditEngineMsg))
  CreateAccount(username: String, password: String)
  JoinSubRedditClient(subreddit_id: String)
  LeaveSubRedditClient(subreddit_id: String)
  CreatePostClient(subreddit_id: String, content: String)
  CreateCommentClient(subreddit_id: String, comment: String)
  CreateCommentReplyClient(subreddit_id: String, reply: String)
  UpvotePostClient(subreddit_id: String)
  DownvotePostClient(subreddit_id: String)
  SendMessageClient(receiver_id: String, message: String)
  GetFeedClient()
  GetDirectMessagesClient()
  TerminateClient()
}
