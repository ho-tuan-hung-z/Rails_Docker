require 'faker'

# Cấu hình Faker sử dụng tiếng Nhật
Faker::Config.locale = 'ja'

# Reset ID về 1
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0;")
%w(order_items orders products users).each do |table_name|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
end
ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1;")

# Tạo 20 người dùng ngẫu nhiên (tên và email tiếng Nhật)
20.times do
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email
  )
end

# Tạo 50 sản phẩm ngẫu nhiên (tên và mô tả bằng tiếng Nhật)
50.times do
  Product.create(
    name: Faker::Commerce.product_name,
    price: Faker::Commerce.price(range: 100..10_000),
    description: Faker::Lorem.sentence(word_count: 10)
  )
end

# Tạo 100 đơn hàng ngẫu nhiên (trạng thái bằng tiếng Nhật)
users = User.all
products = Product.all

statuses = ["保留中", "進行中", "配達済み", "キャンセル", "返金済み"]

100.times do
  order = Order.create(
    user: users.sample,
    status: statuses.sample,
    total_price: 0
  )

  # Thêm từ 1 đến 5 sản phẩm vào mỗi đơn hàng
  total_price = 0
  rand(1..5).times do
    product = products.sample
    quantity = rand(1..3)
    price = product.price * quantity
    total_price += price
    OrderItem.create(order: order, product: product, quantity: quantity, price: price)
  end

  # Cập nhật tổng tiền của đơn hàng
  order.update(total_price: total_price)
end

puts "データが正常に作成されました！"
