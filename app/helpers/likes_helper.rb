module LikesHelper
  def like_count(number)
    case number
    when 0..20 then number.to_s
    when 20..50 then "20+"
    when 50..100 then "50+"
    when 100..500 then "100+"
    when 500..1000 then "500+"
    when 1000..Float::INFINITY then "1000+"
    end
  end

  def like_button(comment)
    likes = comment.likes
    likes.length
    if comment.current_thinker?(current_thinker)
      link_to 'javascript:;', :class => "pull-right btn", :role => "button", :title => t("you_cannot_vote_yourself") do
        content_tag(:span, "", :class => "glyphicon glyphicon-arrow-up dark-grey", "aria-hidden" => "true") +
        like_count(likes.length)
      end
    elsif likes.current_thinker(current_thinker).present?
      link_to 'javascript:;', :class => "pull-right btn", :role => "button", :title => t("you_voted_yet") do
        content_tag(:span, "", :class => "glyphicon glyphicon-arrow-up dark-grey", "aria-hidden" => "true") +
        like_count(likes.length)
      end
    else
      link_to comment_likes_path(comment), :class => "pull-right btn", :role => "button", :title => t("vote"), method: :post do
        content_tag(:span, "", :class => "glyphicon glyphicon-arrow-up", "aria-hidden" => "true") +
        like_count(likes.length)
      end
    end
  end

  def approve_button(comment)
    link_to comment.approved ? 'javascript:;' : approve_comment_path(comment), :class => "pull-right btn", :role => "button", :title => t("approve"), method: :put do
        content_tag(:span, "", :class => "glyphicon glyphicon-ok #{ comment.approved ? 'dark-grey' : '' }", "aria-hidden" => "true")
    end
  end
end
