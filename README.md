# Billetto Events

Rails application for fetching public events from Billetto and allowing authenticated users to upvote or downvote them.  
Clerk is used for authentication and Rails Event Store is used to record voting events.

## Setup

### Requirements

- Ruby 3.4.9
- Rails 8.1.3.1
- PostgreSQL 14

Install dependencies and set up the database:

```
bundle install
bin/rails db:create
bin/rails db:migrate
```

### Credentials

Billetto and Clerk credentials are stored using Rails encrypted credentials.

```
EDITOR="code --wait" bin/rails credentials:edit
```

Expected structure:

```
billetto:
  api_key: your_billetto_api_key

clerk:
  secret_key: your_clerk_secret_key
  publishable_key: your_clerk_publishable_key
  sign_in_url: your_sign_in_url
  sign_up_url: your_sign_up_url

```

Start the application:

```
bin/rails server
```

The app will be available at `http://localhost:3000`.

## Authentication

Authentication is handled by Clerk.

Events can be viewed without signing in, but voting requires an authenticated user. The Clerk user ID is stored with the vote so votes can be associated with the user who submitted them.

## Voting

The request flow is:

```
VotesController
  -> Voting::Upvote / Voting::Downvote
  -> CommandBus
  -> Voting::Service
  -> EventUpvoted / EventDownvoted
  -> Rails Event Store
  -> Voting::VoteRecorder
  -> EventVote
```

## Design Choices & Assumptions

- Billetto events are stored locally, while Rails Event Store is used to keep the history of voting actions.
- `EventVote` is used as a read model for the current vote state and vote counts.
- Commands and a small command bus are used to keep voting logic outside the controller.
- Clerk is used as the source of authentication, and the Clerk user ID is stored with voting events.
- A user can have one active vote per event. Repeating the same vote is not allowed, but the user can switch between upvote and downvote.
- Vote projections are handled synchronously since the processing required for a vote is small.

## Tests

Prepare the test database and run the specs:

```
bin/rails db:test:prepare
bundle exec rspec
```

## Code Style

```
bundle exec rubocop
```