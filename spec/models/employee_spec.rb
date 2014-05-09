# == Schema Information
#
# Table name: employees
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  email                 :string(255)
#  role_id               :integer
#  team_id               :integer
#  technology_id         :integer
#  created_at            :datetime
#  updated_at            :datetime
#  auth_token            :text
#  devise_type           :string(255)      default("ios")
#  devise_token          :string(255)
#  known_technology_id   :string(255)
#  badge                 :integer          default(0)
#  active                :boolean          default(TRUE)
#  joining_date          :date
#  birthdate             :date
#  slug                  :string(255)
#  pic_url               :string(255)
#  provider              :string(255)
#  uid                   :string(255)
#  refresh_token         :string(255)
#  token_expires_at      :datetime
#  event_id_birthdate    :string(255)
#  event_id_joining_date :string(255)
#

require 'spec_helper'

describe Employee do


end
