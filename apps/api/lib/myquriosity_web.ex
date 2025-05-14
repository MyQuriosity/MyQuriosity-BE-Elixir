defmodule MyQuriosityWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use MyQuriosityWeb, :controller
      use MyQuriosityWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def model do
    quote do
      use Ecto.Schema
      require Core.Macros.CommonField

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: Web

      import Plug.Conn
      import Core.Gettext
      import Api.GuardianHelper
      # import Api.ValidationHelper
      alias Api.Router.Helpers, as: Routes
      alias CampusApiUtils.Guardian, as: GuardianUtils
      alias Data.Repo
      import Ecto.Query
      action_fallback(Api.FallbackController)
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/quiz_generator_web/templates",
        namespace: Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      import Api.ErrorHelpers
      import Core.Gettext
      alias Api.Router.Helpers, as: Routes
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: Api.Endpoint,
        router: Api.Router,
        statics: MyQuriosityWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
