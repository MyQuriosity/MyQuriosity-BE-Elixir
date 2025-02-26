# defmodule Data.Support.DataFactory do
#   @moduledoc """
#   # TODO: Write proper moduledoc
#   """

#   use ExMachina.Ecto, repo: QuizGenerator.Repo
#   alias Data.TeamUser
#   alias Data.TenantInformation
#   alias Data.User

#   def tenant_info_factory do
#     %TenantInformation{
#       institute_name: "title",
#       tenant_prefix: "test_sub_domain",
#       site_url: "test_sub_domain.com",
#       sub_domain: sequence("tenant"),
#       employees_count: 50,
#       students_count: 1000,
#       campuses_count: 3
#     }
#   end

#   def user_factory do
#     %User{
#       first_name: "first_name",
#       last_name: "last_name",
#       username: sequence("user"),
#       phone: sequence(:contact_no, &"+92323#{&1}"),
#       email: sequence(:email, &"user_1###{&1}@yopmail.com")
#     }
#   end

#   def team_admin_factory do
#     %TeamUser{
#       first_name: "team",
#       last_name: "admin",
#       username: "teamadmin",
#       phone: "03341234567",
#       email: "teamadmin@yopmail.com",
#       is_admin: true
#     }
#   end

#   def team_member_factory do
#     %TeamUser{
#       first_name: "team",
#       last_name: "member",
#       username: "teammember",
#       phone: "03351234567",
#       email: "teammember@yopmail.com",
#       token: "ref_token_786",
#       is_admin: false
#     }
#   end
# end
