[![Build Status](https://travis-ci.org/teachbase/clickmeetings.svg?branch=master)](https://travis-ci.org/teachbase/clickmeetings)

# Clickmeetings

Simple REST API client to interact with [Clickmeeting](https://clickmeeting.com) open and Privatelabel API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clickmeetings'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clickmeetings

## Usage

### Configuration

With Rails:

+ in `config/secrets.yml` add:
```yml
clickmeetings:
  privatelabel_host: https://api.clickmeetings.com/privatelabel/v1 # or http://api.anysecond.com/privatelabel/v1
  privatelabel_api_key: your_privatelabel_api_key
  host: https://api.clickmeetings.com/v1 # or http://api.anysecond.com/v1
  api_key: your_open_api_key
  locale: es # default language (uses e.g. in invitations)
```
+ in `config/clickmeetings.yml`:
```yml
privatelabel_host: https://api.clickmeetings.com/privatelabel/v1 # or http://api.anysecond.com/privatelabel/v1
privatelabel_api_key: your_privatelabel_api_key
host: https://api.clickmeetings.com/v1 # or http://api.anysecond.com/v1
api_key: your_open_api_key
locale: es # default language (uses e.g. in invitations)
```

With or without Rails:

+ Use environment variables `CLICKMEETINGS_*` (e.g. `CLICKMEETINGS_PRIVATELABEL_HOST`).
+ Use `configure` method:
```ruby
Clickmeetings.configure do |config|
  config.privatelabel_api_key = 'your_privatelabel_api_key'
  # and another configs like above
end
```

### Usage

+ Privatelabel API
  + Your profile
  ```ruby
  profile = Clickmeetings::PrivateLabel::Profile.get # => get your PrivateLabel profile  details
  ```
  + Accounts
  ```ruby
  account = Clickmeetings::PrivateLabel::Account.create(params)
  # => Clickmeetings::PrivateLabel::Account object
  # params is a Hash; see specification for params
  # in your clickmeeting account
  account = account.update username: "New account name"
  # => updated Clickmeetings::PrivateLabel::Account object
  # see specification to know what params you can provide
  account = account.disable # sets account's status to 'disabled'
  account = account.enable  # sets account's status to 'active'
  account.destroy # => deleted account
  Clickmeetings::PrivateLabel::Account.all # => array of accounts
  Clickmeetings::PrivateLabel::Account.find(1) # => account details with id = 1 or
                                               #    Clickmeetings::NotFoundError
  ```
  + Conferences
    + Specify an account
    ```ruby
    Clickmeetings::PrivateLabel::Conference.account_id # => nil
    Clickmeetings::PrivateLabel::Conference.by_account(account_id: 1)
    # => Clickmeetings::PrivateLabel::Conference, so you can use #create,
    # #update and #find in chain
    Clickmeetings::PrivateLabel::Conference.account_id # => 1
    ```
    or
    ```ruby
    # Clickmeetings::PrivateLabel::Conference.account_id equals to nil
    Clickmeetings::PrivateLabel::Conference.by_account(account_id: 1) do
      # there Clickmeetings::PrivateLabel::Conference.account_id equals to 1
    end
    # and there Clickmeetings::PrivateLabel::Conference.account_id equals to nil

    Clickmeetings::PrivateLabel::Conference.by_account(account_id: 1).new
    # => #<Clickmeetings::PrivateLabel::Conference:0x... @account_id=1>
    ```
    + Do anything
    ```ruby
    Clickmeetings::PrivateLabel::Conference.by_account(account_id: 1) do
      # use Clickmeetings::PrivateLabel::Conference.create, .all and .find methods+
      # to create conference, get list of conferences for account or get conference
      # details

      # and #update and #destroy instance methods to change or delete any conference

      # params same as in Open API (see below)
    end
    ```
+ [Open API](http://dev.clickmeeting.com/api-doc/)

  Account is based on your config (from api key) or with every class you can use
  ```ruby
  Clickmeetings::Open::Conference.with_account(account_api_key: 'another_account_api_key') do
    # do anything in another account
  end
  ```
  + Сonference
    ```ruby
    Clickmeetings::Open::Conference.active   # => list of active conferences
    Clickmeetings::Open::Conference.inactive # => list of inactive conferences
    # .all, .find, .create, #update, #destroy as usual
    ```
    + params for `.create` and `#update`
      + Required:
        + name (String): room name
        + room_type (String): 'webinar' or 'meeting'
        + permanent_room (Integer): 1 - room is permanent; 0 - has start time and duration
        + access_type (Integer): 1 - open, 2 - password (requires password in params), 3 - token
      + Optional
        + password (String): password for rooms with access_type 2
        + custom_room_url_name (String): room url will be `https://{account_name}.clickmeeting.com/{custom_room_url_name}`
        + lobby_description (String): Messagee in lobby
        + lobby_enabled (String): 1 - true, 0 - false
        + starts_at (iso8601 datetime): time conference starts at (if it is not permanent). Default is `now`
        + duration (String "h:mm"): duration of conference, between 0:05 and 3:00
        + timezone (String): Time zone of conference (e.g. “America/New_York”)
        + skin_id (integer): Skin identifier
        + registration (Hash):
          + enabled (Boolean)
          + template (Integer): registration template, between 1 and 3
        + status (String): "active" or "inactive"
        + settings (Hash): please, see on [Clickmeting API documentation](http://dev.clickmeeting.com/api-doc/#post_conferences) if need
    + Other helpful methods
    ```ruby
    Clickmeetings::Open::Conference.skins # => array of available skins; each skin is a Hash
    Clickmeetings::Open::Conference.find(1).create_tokens(10)
    # creates tokens for confereces with access_type = 3;
    # param specifies how many tokens will be created (default is 1)

    Clickmeetings::Open::Conference.new(id: 1).send_invites(
      attendees: [
        {email: "first@teachbase.ru"},
        {email: "second@teachbase.ru"}
      ]
      role: "presenter",
      template: "basic" # or "advanced"
    )
    # send invites to emails in attendees for specified role. Template means view of email
    # .new(id: 1) specifies id of conference. Unlike .find(1) it doesn't request to clickmeetings

    Clickmeetings::Open::Conference.new(id: 1).files # => files for conference
    Clickmeetings::Open::Conference.new(id: 1).tokens # => tokens for conference (if access_type is 3)
    Clickmeetings::Open::Conference.new(id: 1).sessions # => sessions for conference
    Clickmeetings::Open::Conference.new(id: 1).registrations # => registrations for conference
    Clickmeetings::Open::Conference.new(id: 1).recordings # => recordings for conference

    Clickmeetings::Open::Conference.new(id: 1).register(
      registration: {
        1 => "firstname",
        2 => "lastname",
        3 => "email@teachbase.ru"
      },
      confirmation_email: { # optional
        enabled: 1, # or 0
        lang: "ru", # or something else
      }
    )

    Clickmeetings::Open::Conference.find(1).create_hash(
      nickname: "User#1",
      role: "presenter",
      email: "user1@teachbase.ru
      # :password for conference with access_type 2
      # :token for conference with access_type 3
    )
    # creates autologin hash for user, specified in params
    ```
    For more information about autologin hashes see [docs](http://dev.clickmeeting.com/api-doc/#post_autologin_hash).
  + Session
    ```ruby
    Clickmeetings::Open::Session.by_conference(conference_id: 1).all
    # => sessions for conference with id 1
    # now u can use
    Clickmeetings::Open::Session.all
    # => sessions for conference with id 1
    Сlickmeetings::Open::Session.find(1)
    # => session with id 1 in conference with id 1
    ```
    or
    ```ruby
    Clickmeetings::Open::Session.by_conference(conferecne_id: 1) do
      Clickmeetings::Open::Session.all
      # => sessions for conference with id 1
      Сlickmeetings::Open::Session.find(1)
      # => session with id 1 in conference with id 1
    end
    Clickmeetings::Open::Session.all
    # => Clickmeetings::NotFoundError
    ```
    You can use only `.all`, `.find` and one of methods below
    + `#attendees`

      ```ruby
      Clickmeetings::Open::Session.by_conference(conferecne_id: 1) do
        Сlickmeetings::Open::Session.find(1).attendees
        # => array of attendees; each attendee is  a hash
      end
      ```
    + `#generate_pdf`

      ```ruby
      Clickmeetings::Open::Session.by_conference(conferecne_id: 1) do
        Сlickmeetings::Open::Session.find(1).generate_pdf :ru
        # => hash { status: "...", ... }
        # if status id "FINISHED", it contains :url key with url of pdf
        # params sets locale; default locale in config; default for config is "en"
      end
      ```
    + `#get_report`

      ```ruby
      Clickmeetings::Open::Session.by_conference(conferecne_id: 1) do
        Сlickmeetings::Open::Session.find(1).generate_pdf :ru
        # => url of pdf is status for specified locale is "FINISHED"
        #    nil else
      end
      ```
    + `#registrations`

      ```ruby
      Clickmeetings::Open::Session.by_conference(conferecne_id: 1) do
        Сlickmeetings::Open::Session.find(1).registrations
        # => array of registrations
      end
      ```
  + Contacts

    Only `.create` method:
    ```ruby
    Clickmeetings::Open::Contact.create(
      email: "...",
      firstname: "...",
      lastname: "...",
      phone: "...", # optional
      company: "...", # optional
      country: "..." # optional
    )
    ```
    If contact with passed email exists, it will be updated
  
  + TimeZone

    Only `.all` method with optional param `:country`. Returns array of strings.
    ```ruby
    Clickmeetings::Open::TimeZone.all country: :ru # => time zones in Russia
    Clickmeetings::Open::TimeZone.all # => all time zones
    ```

  + PhoneGateway

    ```ruby
    Clickmeetings::Open::PhoneGateway.all # => array of phone gateways
    ```

  + Registration

    ```ruby
    Clickmeetings::Open::Registration.by_conference(conference_id: 1) do
      Clickmeetings::Open::Registration.all # => array of registrations
      Clickmeetings::Open::Registration.active # => array of active registrations
      Clickmeetings::Open::Registration.create(params) # => registration hash
      # => params like in Clickmeetings::Open::Conference#register
      Clickmeetings::Open::Registration.for_session(session_id: 1)
      # => registrations for session with id 1
    end
    ```

  + FileLibrary

    ```ruby
    Clickmeetings::Open::FileLibrary.create(path: '/path/to/file.pdf')
    # => FileLibrary instance; creates file in your library
    Clickmeetings::Open::FileLibrary.create(path: '/path/to/file.pdf', conference_id: 1)
    # => FileLibrary instance; creates file in conference with id 1
    Clickmeetings::Open::FileLibrary.all # => array of FileLibrary instances
    Clickmeetings::Open::FileLibrary.for_conference(conference_id: 1)
    # array of files in conference with id 1

    # find and destroy as usually

    Clickmeetings::Open::FileLibrary.new(id: 1).download # => content of file with id 1 as String
    ```

  + Recording

    `Clickmeetings::Open::Recordings` interacts with recordings. Specify a conference with `by_conference` (as above) method and use `.all`, `.find`, and `.destroy_all` (to destroy all recordings of conference) methods.

  + Chat

    `Clickmeetings::Open::Chat` interacts with chats. Use `.all` to get info about chats. `.find` returns content of zip-archive with a chat.

  + Other

    Use `.ping` with any class to check API status.

## Development

+ Fork repo
+ Create new branch
+ install dependencies

      $ bundle install

+ Commit your changes (do not forget about specs)
+ Create a pull request

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/teachbase/clickmeetings.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

