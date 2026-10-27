alias CoffeePrices.Cafes
alias CoffeePrices.Cafes.Cafe
alias CoffeePrices.Pricing
alias CoffeePrices.Repo
alias CoffeePrices.Accounts.User

unless Repo.get_by(Cafe, name: "Cuba St Coffee") do
  Cafes.create_cafe(%{
    name: "Cuba St Coffee",
    address: "123 Cuba Street, Te Aro, Wellington",
    latitude: -41.2934,
    longitude: 174.7757
  })
end

unless Repo.get_by(Cafe, name: "Lambton Grounds") do
  Cafes.create_cafe(%{
    name: "Lambton Grounds",
    address: "45 Lambton Quay, Wellington Central",
    latitude: -41.2784,
    longitude: 174.7767
  })
end

unless Repo.get_by(Cafe, name: "The Courtenay Cup") do
  Cafes.create_cafe(%{
    name: "The Courtenay Cup",
    address: "78 Courtenay Place, Te Aro, Wellington",
    latitude: -41.2967,
    longitude: 174.7792
  })
end

unless Repo.get_by(Cafe, name: "Manners St Roast") do
  Cafes.create_cafe(%{
    name: "Manners St Roast",
    address: "32 Manners Street, Wellington Central",
    latitude: -41.2912,
    longitude: 174.7756
  })
end

unless Repo.get_by(Cafe, name: "Willis Lane Brew") do
  Cafes.create_cafe(%{
    name: "Willis Lane Brew",
    address: "91 Willis Street, Wellington Central",
    latitude: -41.2889,
    longitude: 174.7745
  })
end

unless Repo.get_by(User, username: "quartz563") do
  CoffeePrices.Accounts.create_user(%{
    username: "quartz563",
    email: "quartz563@example.com",
    password_hash: "placeholder"
  })
end

# Grab a user to attribute reports to
user = Repo.get!(User, 1)

# Cuba St Coffee - cafe_id: 1
Pricing.create_price_report(%{
  cafe_id: 1,
  user_id: user.id,
  drink_type: :flat_white,
  milk_type: :whole,
  size: :regular,
  price: Decimal.new("6.50")
})

Pricing.create_price_report(%{
  cafe_id: 1,
  user_id: user.id,
  drink_type: :latte,
  milk_type: :oat,
  size: :large,
  price: Decimal.new("7.50")
})

Pricing.create_price_report(%{
  cafe_id: 1,
  user_id: user.id,
  drink_type: :long_black,
  milk_type: :none,
  size: :regular,
  price: Decimal.new("5.50")
})

# Lambton Grounds - cafe_id: 2
Pricing.create_price_report(%{
  cafe_id: 2,
  user_id: 1,
  drink_type: :flat_white,
  milk_type: :whole,
  size: :regular,
  price: Decimal.new("6.00")
})

Pricing.create_price_report(%{
  cafe_id: 2,
  user_id: 1,
  drink_type: :cappuccino,
  milk_type: :whole,
  size: :regular,
  price: Decimal.new("6.00")
})

Pricing.create_price_report(%{
  cafe_id: 2,
  user_id: 1,
  drink_type: :latte,
  milk_type: :almond,
  size: :regular,
  price: Decimal.new("7.00")
})

# The Courtenay Cup - cafe_id: 3
Pricing.create_price_report(%{
  cafe_id: 3,
  user_id: user.id,
  drink_type: :flat_white,
  milk_type: :whole,
  size: :small,
  price: Decimal.new("5.50")
})

Pricing.create_price_report(%{
  cafe_id: 3,
  user_id: user.id,
  drink_type: :flat_white,
  milk_type: :oat,
  size: :regular,
  price: Decimal.new("7.00")
})

Pricing.create_price_report(%{
  cafe_id: 3,
  user_id: user.id,
  drink_type: :long_black,
  milk_type: :none,
  size: :large,
  price: Decimal.new("6.00")
})

# Manners St Roast - cafe_id: 4
Pricing.create_price_report(%{
  cafe_id: 4,
  user_id: 1,
  drink_type: :flat_white,
  milk_type: :whole,
  size: :regular,
  price: Decimal.new("5.00")
})

Pricing.create_price_report(%{
  cafe_id: 4,
  user_id: 1,
  drink_type: :latte,
  milk_type: :oat,
  size: :large,
  price: Decimal.new("7.00")
})

# Willis Lane Brew - cafe_id: 5
Pricing.create_price_report(%{
  cafe_id: 5,
  user_id: user.id,
  drink_type: :cappuccino,
  milk_type: :whole,
  size: :regular,
  price: Decimal.new("6.50")
})

Pricing.create_price_report(%{
  cafe_id: 5,
  user_id: user.id,
  drink_type: :flat_white,
  milk_type: :oat,
  size: :regular,
  price: Decimal.new("7.50")
})

Pricing.create_price_report(%{
  cafe_id: 5,
  user_id: user.id,
  drink_type: :long_black,
  milk_type: :none,
  size: :small,
  price: Decimal.new("4.50")
})
