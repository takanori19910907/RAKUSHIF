Shop.create(
  id: 300,
  name: "松戸3丁目"
)

user1 = User.create(
  shop_id: 300,
  name:  "管理者",
  age: 30,
  user_id: 1111,
  password_digest: "password",
  work_status: 1,
  license: true,
  admin: true
)

user1 = User.create(
  shop_id: 300,
  name:  "ユーザー1",
  age: 18,
  user_id: 1112,
  password_digest: "password",
  work_status: 2,
  rookie: true
)
