class MembersController < ApplicationController
  include AuthenticatedSystem

  def index
    @members = Member.all(:order => "last_name, first_name")
  end

  def show
    @member = Member.find(params[:id])
  end

  def edit
    @member = Member.find(params[:id])
  end
end
