class Redcarpet::Render::CleanerHTML < Redcarpet::Render::HTML
  def paragraph(text)
    "<p class='lead'>#{text}</p>"
  end
end
