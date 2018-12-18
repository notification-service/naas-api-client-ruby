# Usage

Below are example use cases to send an *Email Notification*.

## Create an SMTP Setting

```ruby
account_smtp_setting_attributes = {
  :name                      => 'Gmail',
  :description               => 'Gmail domain account',
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
  :name        => 'My First Project',
  :description => 'My project description'
}

project = Naas::Models::Projects.create(project_attributes)
```

## Create a Campaign

```ruby
campaign_attributes = {
  :project_id  => project.id,
  :name        => 'Transaction Emails',
  :description => 'All transaction emails in the system'
}

campaign = Naas::Models::Campaigns.create(campaign_attributes)
```

## Create a Campaign Email Template

```ruby
campaign_email_template_attributes = {
  :name               => 'Welcome Email',
  :subject            => 'Welcome to Application',
  :from_email_address => 'info@application.com',
  :from_name          => 'Lester Tester',
  :text_body          => 'Welcome {{ user.full_name }} to Application!',
  :html_body          => '<h1>Welcome {{user.full_name }} to Application!</h1>'
}

campaign_email_template = Naas::Models::CampaignEmailTemplates.create_by_campaign_id(campaign.id, campaign_email_template_attributes)
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
  :email_address => 'billy@larkin.com'
}

subscriber_email_address = Naas::Models::SubscriberEmailAddresses.create(subscriber_email_address_attributes)
```

## Create an Email Notification

```ruby
email_notification_attributes = {
  :campaign_email_template_id  => campaign_email_template.id,
  :account_smtp_setting        => account_smtp_setting.id,
  :subscriber_email_address_id => subscriber_email_address.id,
  :content                     => { user: { full_name: "Billy Larkin" } }
}

email_notification = Naas::Models::EmailNotifications.create(email_notification_attributes)
```
