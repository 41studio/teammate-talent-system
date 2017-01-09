# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  company_name    :string(255)
#  company_website :string(255)
#  company_email   :string(255)
#  company_phone   :string(255)
#  industry        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  photo_company   :string(255)
#

class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_filter :redirect_url, only: [:new, :index]
  before_filter :user_allowed, only: [:edit, :update, :destroy]
  skip_before_filter :authenticate_user!, only: [:index, :show, :autocomplete_industry]
  before_action :set_collection, only: [:new, :create, :edit, :update]

  # GET /companies
  # GET /companies.json
  def index; end

  # GET /companies/1
  # GET /companies/1.json
  def show; end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit; end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    if @company.save
      current_user.update_attribute(:company_id, @company.id)
      redirect_to dashboards_path, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    if @company.update(company_params)
      redirect_to dashboards_path, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    redirect_to dashboards_path, notice: 'Company was successfully destroyed.'
  end

  def invite_personnel
    personnel_email = params[:email]
    if valid_email?(personnel_email)    
      if User.invite!({email: personnel_email, company_id: current_user.company_id}, current_user)
        redirect_to dashboards_path, notice: 'User invited!'
      else
        redirect_to dashboards_path
      end
    else
      redirect_to dashboards_path, notice: 'email is not valid'
    end
  end

  def autocomplete_industry
    keyword = params[:q]
    @industry = IndustryList.where("industry LIKE ?", "%#{keyword}%").pluck(:industry)

    respond_to do |format|
      format.json { render json: @industry.to_json }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def redirect_url
      if user_signed_in?
        redirect_to previous_url, :status => 401 if current_user.company_id != nil
      else
        redirect_to new_user_session_path
      end
    end

    def set_company
      if user_signed_in?
        @company = Company.friendly.find(current_user.company_id)
      else
        @company = Company.friendly.find(params[:id])
      end
    end

    def set_collection
      @industries = IndustryList.all.collect {|i| [i.industry, i.id]}
    end

    def user_allowed
      if current_user.company_id != @company.id
        redirect_to dashboards_path
      end
    end

    def valid_email?(email)
      
      email_regex = %r{
        ^ # Start of string
        [0-9a-z] # First character
        [0-9a-z.+]+ # Middle characters
        [0-9a-z] # Last character
        @ # Separating @ character
        [0-9a-z] # Domain name begin
        [0-9a-z.-]+ # Domain name middle
        [0-9a-z] # Domain name end
        $ # End of string
      }xi # Case insensitive
      
      if (email =~ email_regex) == 0
        return true
      else
        return false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:company_name, :company_website, :company_email, :company_phone, :industry, :photo_company)
    end
end
