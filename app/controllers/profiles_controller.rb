class ProfilesController < ApplicationController
  before_filter :load_profile

  def show
  end

  def edit
  end

  def update
    params[:profile][:expertise_ids] ||= []
    if @profile.update_attributes(params[:profile])
      redirect_to member_profile_path(@member)
    else
      render :action => :edit
    end
  end

  protected
  def load_profile
    if params[:member_id]
      @member = Member.find(params[:member_id])
      @profile = @member.profile
    elsif params[:id]
      @profile = Profile.find(params[:id])
      @member = @profile.member
    end
  end
end
