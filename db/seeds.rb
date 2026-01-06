# Clear existing data (order matters because of FK)
Product.destroy_all
Supplier.destroy_all

# Create suppliers
supplier1 = Supplier.create!(
  name: "Acme Corp",
  email: "contact@acme.com",
  phone: "1234567890",
  address: "123 Industrial Way"
)

supplier2 = Supplier.create!(
  name: "Global Traders",
  email: "sales@globaltraders.com",
  phone: "9876543210",
  address: "45 Market Street"
)

# Create products
Product.create!(
  name: "Laptop",
  sku: "LAP-1001",
  price: 75000.00,
  quantity: 10,
  supplier: supplier1
)

Product.create!(
  name: "Wireless Mouse",
  sku: "MOU-2001",
  price: 1500.00,
  quantity: 50,
  supplier: supplier1
)

Product.create!(
  name: "Office Chair",
  sku: "CHA-3001",
  price: 8500.00,
  quantity: 20,
  supplier: supplier2
)

puts "Seed data created successfully!"
