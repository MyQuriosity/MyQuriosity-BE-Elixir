defmodule QuizGeneratorNotifier.Constants.NotificationConstants do
  @moduledoc """
  Holds constants to be used across notification system
  """
  @status_read "read"
  @status_unread "unread"

  @medium_push "web_push"
  @medium_email "email"
  @medium_sms "sms"

  @feature_subject "subject"
  @feature_topic "topic"
  @feature_chapter "chapter"
  @feature_grade "grade"
  @feature_role "roles"

  @constants [
    {:status_read, @status_read},
    {:status_unread, @status_unread},
    {:medium_sms, @medium_sms},
    {:medium_push, @medium_push},
    {:medium_email, @medium_email},
    {:statuses, [@status_read, @status_unread]},
    {:mediums, [@medium_email, @medium_push, @medium_sms]},
    {:feature_subject, @feature_subject},
    {:feature_topic, @feature_topic},
    {:feature_chapter, @feature_chapter},
    {:feature_grade, @feature_grade},
    {:feature_role, @feature_role},
    {:features,
     [
       @feature_subject,
       @feature_topic,
       @feature_chapter,
       @feature_grade,
       @feature_role,
     ]},
    {:quiz_generator_notification_channel_topic, "tenant_notification"}
  ]

  @spec encode(atom()) :: String.t() | [String.t()]
  Enum.map(@constants, fn {key, value} ->
    def encode(unquote(key)), do: unquote(value)
  end)
end
