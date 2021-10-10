FactoryBot.define do
  factory :user do
    name                  { 'vanja' }
    email                 { 'kosti@mail.com' }
    password              { 'point' }
    password_confirmation { 'point' }
  end
  to_create(&:save)
end