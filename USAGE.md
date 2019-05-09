# Usage

This outlines the different ways you can use the API client.

# Approaches

## Request Based

Using this approach gives you flexibility in the extended response body.

```ruby
project_attributes = {
  :id          => 'my-first-project',
  :name        => 'My First Project',
  :description => 'My project description'
}

remote_request = Naas::Requests::Projects.create(project_attributes)

remote_request.on(:success) do |resp|
  # Do something with the successful (2XX) response. You have access to the `data` (models), `links` (hypermedia), and the full `resp` (HTTP)
end

remote_request.on(:failure) do |resp|
  # Do something with the failure (4XX) response. You have access to the `data` (models), `links` (hypermedia), and the full `resp` (HTTP)
end

remote_request.on(:server_error) do |resp|
  # Do something with the server error (5XX) response. You have access to the `data` (models), `links` (hypermedia), and the full `resp` (HTTP)
end
```

## Model Based

Using this approach gives you a boolean response. It's either _successful_ or raises an `Naas:Errors::InvalidRequestError` exception with a stringified error message.


```ruby
project_attributes = {
  :id          => 'my-first-project',
  :name        => 'My First Project',
  :description => 'My project description'
}

begin
  project = Naas::Models::Projects.create(project_attributes)
rescue Naas::Errors::InvalidRequestError => exception
  logger.fatal { exception.message.inspect }
end
```


# Example

Below is an example of the steps needed to create an *Email Notification*.

## Create an SMTP Setting

```ruby
account_smtp_setting_attributes = {
  :id                        => 'gmail-domain-account',
  :name                      => 'Gmail',
  :description               => 'Gmail domain account',
  :domain                    => 'example.com',
  :address                   => 'smtp.gmail.com',
  :port                      => 587,
  :user_name                 => 'apikey',
  :password                  => 'abcd1234',
  :password_confirmation     => 'abcd1234',
  :authentication_type_value => 'plain',
  :is_primary                => true
}

account_smtp_setting = Naas::Models::AccountSmtpSettings.create(account_smtp_setting_attributes)
```

## Create a Project

```ruby
project_attributes = {
  :id          => 'my-first-project',
  :name        => 'My First Project',
  :description => 'My project description'
}

project = Naas::Models::Projects.create(project_attributes)
```

## Create a Campaign

```ruby
campaign_attributes = {
  :id          => 'transaction-emails',
  :name        => 'Transaction Emails',
  :description => 'All transaction emails in the system'
}

campaign = Naas::Models::Campaigns.create_by_project_id(project.id, campaign_attributes)
```

## Create a Campaign Email Template

```ruby
campaign_email_template_attributes = {
  :id                 => 'welcome-email',
  :name               => 'Welcome Email',
  :subject            => 'Welcome to Application',
  :from_email_address => 'info@application.com',
  :from_name          => 'Lester Tester',
  :text_body          => 'Welcome {{ user.full_name }} to Application!',
  :html_body          => '<h1>Welcome {{user.full_name }} to Application!</h1>'
}

campaign_email_template = Naas::Models::CampaignEmailTemplates.create_by_project_id_and_campaign_id(project.id, campaign.id, campaign_email_template_attributes)
```

## Create a Subscriber

```ruby
subscriber_attributes = {
  :first_name => 'Billy',
  :last_name  => 'Larkin'
}

subscriber = Naas::Models::Subscribers.create(subscriber_attributes)
```

## Create a Subscriber Email Address

```ruby
subscriber_email_address_attributes = {
  :subscriber_id => subscriber.id,
  :email_address => 'billy@larkin.com',
  :is_primary    => true
}

subscriber_email_address = Naas::Models::SubscriberEmailAddresses.create(subscriber_email_address_attributes)
```

## Retrieve a Subscriber by Email Address
You can retrieve a subscriber email address via a few ways:

### Via the `id`
```ruby
subscriber_email_address = Naas::Models::SubscriberEmailAddresses.retrieve(12)
=> #<Naas::Models::SubscriberEmailAddress:0x00007fb10e087db8>
```

### Via the MD5 hash of the email address
```ruby
email_address      = 'billy@larkin.com'
email_address_hash = Digest::MD5.hexdigest(email_address)

subscriber_email_address = Naas::Models::SubscriberEmailAddresses.retrieve(email_address_hash)
=> #<Naas::Models::SubscriberEmailAddress:0x00007fb10d3369e8>
```

## Create an Email Notification

```ruby
email_notification_attributes = {
  :campaign_email_template_id  => campaign_email_template.id,
  :account_smtp_setting_id     => account_smtp_setting.id,
  :subscriber_email_address_id => subscriber_email_address.id,
  :content                     => { user: { full_name: "Billy Larkin" } }
}

email_notification = Naas::Models::EmailNotifications.create(email_notification_attributes)
```

## Create a Basic Email Notification
This is a helper method to create the notifications based on the _attributes_ alone.

```ruby
email_notification = Naas::Models::EmailNotificationBasic.create('billy@larkin.com', 'my-first-project', 'transaction-emails', 'welcome-email', { user: { full_name: 'Billy Larkin' } }, account_smtp_setting_id: 'gmail-domain-account')
```

> The arguments are: `email_address`, `project_id`, `campaign_id`, `campaign_email_template_id`, `content`, `options`. The `options` are optional, and if included the `content` must be wrapped with the brackets `{}`.

## Email Notification Delivery
You can then deliver an email notification via a few ways:

> You can call `deliver` multiple times. It will create a _copy_ of the original message and then link you to the new status. All Email Notifications will execute deliver until it receives a successful response. Once successful it will create a new message thread to capture all activity.

### Via the instance

```ruby
email_notification.deliver
```
This will return a `201 Created` with a `Location` header response to view the **status**.

### Via the Request

```ruby
Naas::Requests::EmailNotifications.deliver(email_notification.id)
```

### Via the Model

```ruby
Naas::Models::EmailNotifications.deliver(email_notification.id)
```

