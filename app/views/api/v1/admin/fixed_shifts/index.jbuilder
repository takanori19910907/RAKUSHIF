json.array! @shifts do |shift|
  json.id shift.id
  json.clock_in shift.clock_in
  json.clock_out shift.clock_out
  json.user_id shift.user_id
  json.user shift.user
end