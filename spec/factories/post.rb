FactoryBot.define do
  factory :post do
    user_id { 1 }
    title   { 'hy_man' }
    content { 'robocop' }
  end
  to_create(&:save)
end