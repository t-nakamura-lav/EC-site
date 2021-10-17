# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Genre.create!(
  name: "レディース"
)

Genre.create!(
  name: "メンズ"
)

Genre.create!(
  name: "ユニセックス"
)


5.times do |n|
    Admin.create!(
      email: "admin#{n + 1}@gmail.com",
      password: "password#{n + 1}"
    )

    Order.create!(
      customer_id: n + 1,
      postage: 800,
      total_price: (n + 1) * 2200,
      postcode: "000-000#{n + 1}",
      address: "住所#{n + 1}",
      address_name: "宛名#{n + 1}",
      payment_method: 0
    )
end


