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

require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  setup do
    @company = companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create company" do
    assert_difference('Company.count') do
      post :create, company: { company_email: @company.company_email, company_name: @company.company_name, company_phone: @company.company_phone, company_website: @company.company_website, industry: @company.industry }
    end

    assert_redirected_to company_path(assigns(:company))
  end

  test "should show company" do
    get :show, id: @company
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @company
    assert_response :success
  end

  test "should update company" do
    patch :update, id: @company, company: { company_email: @company.company_email, company_name: @company.company_name, company_phone: @company.company_phone, company_website: @company.company_website, industry: @company.industry }
    assert_redirected_to company_path(assigns(:company))
  end

  test "should destroy company" do
    assert_difference('Company.count', -1) do
      delete :destroy, id: @company
    end

    assert_redirected_to companies_path
  end
end
