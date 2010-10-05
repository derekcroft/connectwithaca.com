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

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(params[:member])
    if @member.try(:save) && @member.errors.empty?
      flash[:notice] = "Member signed up successfully!"
      redirect_to members_path
    else
      flash[:error] = "Errors encountered while setting up member."
      render :action => "new"
    end
  end
end
