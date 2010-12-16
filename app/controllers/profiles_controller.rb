class ProfilesController < ApplicationController
  before_filter :load_profile

  def show
  end

  def edit
    (5 - @profile.projects.count).times {@profile.projects.build}
  end

  def update
    params[:profile][:expertise_ids] ||= []
    if @profile.update_attributes(params[:profile])
      params[:expertise_years].each {|k,v| @profile.set_years_of_expertise Expertise.find(k), v}
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
