FactoryGirl.define do
  factory :person, class: JquestPg::Person do
    firstname "John"
    lastname  "Doe"
    sequence(:fullname) do |n|
      "#{firstname} #{lastname} #{n}"
    end
    sequence(:email) do |n|
      "#{firstname}.#{lastname}.#{n}@jquestapp.com".downcase
    end
  end

  factory :legislature, class: JquestPg::Legislature do
    sequence(:name) do |n|
      "Assemblée Nationiale #{n}"
    end
    difficulty_level 1
    start_date Date.new(2006)
    end_date Date.new(2016)
    country 'FR'
    languages 'fr'
    territory 'France'
  end

  factory :mandature, class: JquestPg::Mandature do
    legislature
    person
  end
end
