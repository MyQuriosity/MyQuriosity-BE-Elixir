# defmodule Data.Support.Factory do
#   @moduledoc """
#   # TODO: Write proper moduledoc
#   """

#   use ExMachina.Ecto, repo: Data.Repo
#   alias Data.TeamUser
#   alias Data.TenantInformation
#   alias Data.User

#   def tenant_info_factory do
#     %TenantInformation{
#       institute_name: sequence("title"),
#       tenant_prefix: sequence("test_sub_domain"),
#       sub_domain: sequence("tenant"),
#       employees_count: 50,
#       students_count: 1000,
#       campuses_count: 3
#     }
#   end

#   def tenant_info_1_factory do
#     %TenantInformation{
#       institute_name: sequence("title"),
#       tenant_prefix: "test_sub_domain",
#       sub_domain: sequence("tenant"),
#       rejected_at: "2022-01-06T11:00:00+0500",
#       students_count: 1000,
#       employees_count: 50,
#       campuses_count: 3
#     }
#   end

#   def tenant_info_deactivated_factory do
#     %TenantInformation{
#       institute_name: sequence("title"),
#       tenant_prefix: sequence("test_sub_domain"),
#       sub_domain: sequence("tenant"),
#       rejected_at: "2022-01-06T11:00:00+0500",
#       students_count: 1000,
#       campuses_count: 3
#     }
#   end

#   def tenant_info_approved_factory do
#     %TenantInformation{
#       institute_name: "title",
#       tenant_prefix: "test_sub_domain",
#       sub_domain: "tenant",
#       students_count: 1000,
#       campuses_count: 3
#     }
#   end

#   def tenant_info_pending_factory do
#     %TenantInformation{
#       institute_name: "title",
#       tenant_prefix: "test_sub_domain_2",
#       sub_domain: "tenant",
#       students_count: 1000,
#       campuses_count: 3
#     }
#   end

#   def user_factory do
#     %User{
#       first_name: "first_name",
#       last_name: "last_name",
#       username: sequence("user"),
#       phone: sequence(:contact_no, &"+92320#{&1}"),
#       email: sequence(:email, &"user#{&1}@yopmail.com")
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

#   def team_admin_1_factory do
#     %TeamUser{
#       first_name: "team",
#       last_name: "admin",
#       username: sequence("teamadmin"),
#       phone: sequence(:contact_no, &"+92321#{&1}"),
#       email: sequence(:email, &"team_admin#{&1}@yopmail.com"),
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

#   def tenant_contacts_factory do
#     %Data.TenantContact{
#       title: "General Contact Info",
#       designation: "HOD",
#       email: "hello@gmail.com",
#       is_email_approved: true,
#       phone: "+923334444444",
#       is_phone_approved: true,
#       address: "Lahore"
#     }
#   end
# end
