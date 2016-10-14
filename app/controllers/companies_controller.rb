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
  skip_before_filter :authenticate_user!, only: [:index, :show, :autocomplete_industry]
  before_action :set_collection, only: [:new, :create, :edit, :update]

  # GET /companies
  # GET /companies.json
  def index
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
        current_user.update_attribute(:company_id, @company.id)
        format.html { redirect_to dashboards_path, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to dashboards_path, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to dashboards_path, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def invite_personnel
    personnel_email = params[:email]    
    respond_to do |format|
      if User.invite!({email: personnel_email, company_id: current_user.company_id}, current_user)
        format.html { redirect_to dashboards_path, notice: 'User invited!' }
        # format.json { render :show, status: :ok, location: @company }
      else
        format.html { redirect_to dashboards_path }
        # format.json { render json: @company.errors, status: :unprocessable_entity }
      end
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
      @company = Company.find(params[:id])
    end

    def set_collection
      @industries = Company.industry.collect {|p| [ p[1], p[1] ] }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:company_name, :company_website, :company_email, :company_phone, :industry, :photo_company)
    end
end
