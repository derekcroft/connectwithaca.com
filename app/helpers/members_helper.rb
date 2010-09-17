module MembersHelper
  def form_tag_for_controller(&block)
    form_tag member_center_path, :method => "GET", &block
  end
end
