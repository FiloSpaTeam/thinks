module LikesHelper
  def like_count(number)
    case number
    when 0..20 then number
    when 20..50 then "20+"
    when 50..100 then "50+"
    when 100..500 then "100+"
    when 500..1000 then "500+"
    when 1000..Float::INFINITY then "1000+"
    end
  end
end
