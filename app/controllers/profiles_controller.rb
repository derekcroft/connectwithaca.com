class ProfilesController < ApplicationController
  before_filter :load_member

  def show
  end

  def edit
  end

  protected
  def load_member
    @member = Member.find(params[:member_id])
  end
end
