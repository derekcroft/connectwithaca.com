class MembersController < ApplicationController
  include AuthenticatedSystem

  def index
    @members = Member.all(:order => "last_name, first_name")
  end
end
