import gleam/time/timestamp.{type Timestamp}
import gleam/dict.{type Dict}

pub type Account {
  Account(
    username: String,
    password: String,
    karma: Int,
    subscriptions: List(SubReddit),
    inbox: Dict(String, List(DirectMessage)),
  )
}

pub type SubReddit {
  SubReddit(
    name: String,
    description: String,
    members: List(Account),
    posts: List(Post),
  )
}

pub type Post {
  Post(
    author: String,
    content: String,
    timestamp: Timestamp,
    upvotes: Int,
    downvotes: Int,
    comments: List(Comment),
  )
}

pub type Comment {
  Comment(
    author: String,
    content: String,
    timestamp: Timestamp,
    upvotes: Int,
    downvotes: Int,
    replies: List(Comment),
  )
}

pub type DirectMessage {
  DirectMessage(
    sender_id: String,
    content: String,
    timestamp: Timestamp,
  )
}
