class ProfilesController < ApplicationController
  before_filter :load_member
  before_filter :load_profile

  def show
    render "member"
  end

  def edit
    render "member"
  end

  protected
  def load_member
    @member = Member.find(params[:member_id]) if params[:member_id]
  end

  def load_profile
    @profile = params[:id] ? Profile.find(params[:id]) : @member.profile 
  end
end
