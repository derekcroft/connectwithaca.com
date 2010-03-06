module SiteHelper
  def form_tag_for_controller(&block)
    yield
  end
end
