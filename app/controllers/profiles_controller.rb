class ProfilesController < ApplicationController
  before_filter :load_profile

  def show
    render "member"
  end

  def edit
    render "member"
  end

  def update
    expertise_ids = params[:expertise].select { |k,v| v.has_key?(:has) }.collect { |e| e.first.to_i }
    @profile.expertise_ids = expertise_ids
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
