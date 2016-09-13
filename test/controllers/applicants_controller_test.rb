require 'test_helper'

class ApplicantsControllerTest < ActionController::TestCase
  setup do
    @applicant = applicants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:applicants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create applicant" do
    assert_difference('Applicant.count') do
      post :create, applicant: { address: @applicant.address, company_name: @applicant.company_name, date_birth: @applicant.date_birth, degree: @applicant.degree, email: @applicant.email, gender: @applicant.gender, headline: @applicant.headline, industry: @applicant.industry, name: @applicant.name, name_school: @applicant.name_school, phone: @applicant.phone, photo: @applicant.photo, resume: @applicant.resume, state_study: @applicant.state_study, status: @applicant.status, summary: @applicant.summary, title: @applicant.title }
    end

    assert_redirected_to applicant_path(assigns(:applicant))
  end

  test "should show applicant" do
    get :show, id: @applicant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @applicant
    assert_response :success
  end

  test "should update applicant" do
    patch :update, id: @applicant, applicant: { address: @applicant.address, company_name: @applicant.company_name, date_birth: @applicant.date_birth, degree: @applicant.degree, email: @applicant.email, gender: @applicant.gender, headline: @applicant.headline, industry: @applicant.industry, name: @applicant.name, name_school: @applicant.name_school, phone: @applicant.phone, photo: @applicant.photo, resume: @applicant.resume, state_study: @applicant.state_study, status: @applicant.status, summary: @applicant.summary, title: @applicant.title }
    assert_redirected_to applicant_path(assigns(:applicant))
  end

  test "should destroy applicant" do
    assert_difference('Applicant.count', -1) do
      delete :destroy, id: @applicant
    end

    assert_redirected_to applicants_path
  end
end
