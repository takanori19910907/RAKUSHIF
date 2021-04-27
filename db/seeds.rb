shop = Shop.create(
  id: 300,
  name: "松戸3丁目"
)

user1 = User.create(
  shop_id: shop.id,
  name:  "管理者",
  age: 30,
  user_id: 1111,
  password: "password",
  work_status: 1,
  license: true,
  admin: true
)

user1 = User.create(
  shop_id: shop.id,
  name:  "ユーザー1",
  age: 18,
  user_id: 1112,
  password: "password",
  work_status: 2,
  rookie: true
)

shift = user1.requested_shifts.create(
  shop_id: user1.shop_id,
  clock_in: "2012-10-08 15:28:12",
  clock_out: "2012-10-08 15:28:13" 
)