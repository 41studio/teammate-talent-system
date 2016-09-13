require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  setup do
    @job = jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job" do
    assert_difference('Job.count') do
      post :create, job: { aplicant_education: @job.aplicant_education, aplicant_employment_type: @job.aplicant_employment_type, aplicant_experience: @job.aplicant_experience, aplicant_function: @job.aplicant_function, aplicant_industry: @job.aplicant_industry, benefits: @job.benefits, city: @job.city, country: @job.country, curency: @job.curency, departement: @job.departement, job_code: @job.job_code, job_description: @job.job_description, job_requirement: @job.job_requirement, job_search_keyword: @job.job_search_keyword, job_title: @job.job_title, max_salary: @job.max_salary, min_salary: @job.min_salary, state: @job.state, zip_code: @job.zip_code }
    end

    assert_redirected_to job_path(assigns(:job))
  end

  test "should show job" do
    get :show, id: @job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job
    assert_response :success
  end

  test "should update job" do
    patch :update, id: @job, job: { aplicant_education: @job.aplicant_education, aplicant_employment_type: @job.aplicant_employment_type, aplicant_experience: @job.aplicant_experience, aplicant_function: @job.aplicant_function, aplicant_industry: @job.aplicant_industry, benefits: @job.benefits, city: @job.city, country: @job.country, curency: @job.curency, departement: @job.departement, job_code: @job.job_code, job_description: @job.job_description, job_requirement: @job.job_requirement, job_search_keyword: @job.job_search_keyword, job_title: @job.job_title, max_salary: @job.max_salary, min_salary: @job.min_salary, state: @job.state, zip_code: @job.zip_code }
    assert_redirected_to job_path(assigns(:job))
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete :destroy, id: @job
    end

    assert_redirected_to jobs_path
  end
end
