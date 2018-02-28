user = User.new(
  first_name: "Admin",
  last_name: "1",
  username: "admin",
  email: "admin@example.com",
  role: "admin",
  password_digest: BCrypt::Password.create('admin')
)
user.save!

user = User.new(
  first_name: "User",
  last_name: "1",
  username: "user",
  email: "user@example.com",
  role: "user",
  password_digest: BCrypt::Password.create('user')
)
user.save!
