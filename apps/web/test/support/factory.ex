defmodule TenantData.Support.Factory do
  @moduledoc """
    A factory module for generating test data using `ExMachina`.
  """

  use ExMachina.Ecto, repo: Web.Repo
  alias Web.Chapter
  alias Web.Grade
  alias Web.Option
  alias Web.Question
  alias Web.Subject
  alias Web.SyllabusProvider
  alias Web.Topic
  alias Web.User

  def user_factory do
    %User{
      first_name: "Super",
      last_name: "Admin",
      password: "12345678",
      email: "admin@gmail.com",
      gender: "male",
      is_admin: true
    }
  end

  def syllabus_provider_factory do
    %SyllabusProvider{
      title: "Punjab Textbook Board",
      description: "For Punjab schools"
    }
  end

  def grade_factory do
    %Grade{
      title: "Grade 1",
      description: "Primary class"
    }
  end

  def subject_factory do
    %Subject{
      title: "English",
      course_code: "Eng",
      color: "primary-purple"
    }
  end

  def chapter_factory do
    %Chapter{
      title: "Short Tales",
      number: 1
    }
  end

  def topic_factory do
    %Topic{
      title: "The Riding Hood",
      number: 1
    }
  end

  def question_factory do
    %Question{title: "Quiz 1"}
  end

  def option_factory do
    %Option{
      title: "Option 1",
      is_correct: false
    }
  end
end
