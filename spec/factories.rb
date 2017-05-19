FactoryGirl.define do
  factory :user do
    name     "Vladimir Kotov"
    email    "skill088@mail.ru"
    password "foobar"
    password_confirmation "foobar"
  end
end