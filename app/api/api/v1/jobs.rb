module API
  module V1
    class Jobs < Grape::API
      version 'v1'
      format :json

      helpers do
        params :job_id do
          requires :id, type: Integer, desc: "Job id" 
        end

      end

      resource :jobs do
        desc "Job List", {
          :notes => <<-NOTE
          Get All Jobs
          --------------------
          NOTE
        }
        get do
          puts current_user.nil?
          Job.all
        end

        desc "Job By Id", {
          :notes => <<-NOTE
          Get Job By Id
          --------------------
          NOTE
        }
        params do
          use :job_id       
        end
        get ":id" do
          begin
            Job.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
          end
        end

        desc "Delete Job By Id", {
          :notes => <<-NOTE
          Delete Job By Id
          --------------------
          NOTE
        }
        params do
          use :job_id      
        end
        delete ":id" do
          authenticate!
          begin
            job = Job.find(params[:id])
            { status: :success } if job.destroy
          rescue ActiveRecord::RecordNotFound
            error!({status: :error, message: :not_found}, 404)
          end
        end

        desc "Update Job By Id", {
          :notes => <<-NOTE
          Update Job By Id
          --------------------
          NOTE
        }
        params do
          use :job_id
          requires :job_title, type: String, desc: "Job title"
          requires :departement, type: String, desc: "Job departement"
          requires :job_code, type: String, desc: "Job code"
          requires :country, type: String, desc: "Job country"
          requires :state, type: String, desc: "Job state"
          requires :city, type: String, desc: "Job city"
          requires :zip_code, type: String, desc: "Job zip_code"
          requires :min_salary, type:Integer, desc: "Job min_salary"
          requires :max_salary, type:Integer, desc: "Job max_salary"
          requires :curency, type: String, desc: "Job curency"
          requires :job_description, type: String, desc: "Job curency"
          requires :job_requirement, type: String, desc: "Job curency"
          requires :benefits, type: String, desc: "Job curency"
          requires :job_search_keyword, type: String, desc: "Job search keyword"
          requires :education_list_id, type: Integer, desc: "Job education list id"
          requires :employment_type_list_id, type: Integer, desc: "Job employment type list_id"
          requires :experience_list_id, type: Integer, desc: "Job experience list id"
          requires :function_list_id, type: Integer, desc: "Job function list id"
          requires :industry_list_id, type: Integer, desc: "Job industry list id"
        end
        put ':id' do
          authenticate!
          begin
            job = Job.find(params[:id])
            if job.update({
                           id:                     params[:id                   ],
                           job_title:              params[:job_title            ],
                           departement:            params[:departement          ],
                           job_code:               params[:job_code             ],
                           country:                params[:country              ],
                           state:                  params[:state                ],
                           city:                   params[:city                 ],
                           zip_code:               params[:zip_code             ],
                           min_salary:             params[:min_salary           ],
                           max_salary:             params[:max_salary           ],
                           curency:                params[:curency              ],
                           job_description:        params[:job_description      ],
                           job_requirement:        params[:job_requirement      ],
                           benefits:               params[:benefits             ],
                           job_search_keyword:     params[:job_search_keyword   ],
                           company_id:             params[:company_id           ],
                           education_list_id:      params[:education_list_id    ],
                           employment_type_list_id: params[:employment_type_list_id],
                           experience_list_id:     params[:experience_list_id   ],
                           function_list_id:       params[:function_list_id     ],
                           industry_list_id:       params[:industry_list_id     ]
                        })
              { status: :success }
            else
              error!({ status: :error, message: job.errors.full_messages.first }) if job.errors.any?
            end
     
          rescue ActiveRecord::RecordNotFound
            error!({ status: :error, message: :not_found }, 404)
          end
        end

        desc "Create Job", {
          :notes => <<-NOTE
          Create Job By
          --------------------
          NOTE
        }
        params do
          requires :job_title, type: String, desc: "Job title"
          requires :departement, type: String, desc: "Job departement"
          requires :job_code, type: String, desc: "Job code"
          requires :country, type: String, desc: "Job country"
          requires :state, type: String, desc: "Job state"
          requires :city, type: String, desc: "Job city"
          requires :zip_code, type: String, desc: "Job zip_code"
          requires :min_salary, type:Integer, desc: "Job min_salary"
          requires :max_salary, type:Integer, desc: "Job max_salary"
          requires :curency, type: String, desc: "Job curency"
          requires :job_description, type: String, desc: "Job curency"
          requires :job_requirement, type: String, desc: "Job curency"
          requires :benefits, type: String, desc: "Job curency"
          requires :job_search_keyword, type: String, desc: "Job search keyword"
          requires :education_list_id, type: Integer, desc: "Job education list id"
          requires :employment_type_list_id, type: Integer, desc: "Job employment type list_id"
          requires :experience_list_id, type: Integer, desc: "Job experience list id"
          requires :function_list_id, type: Integer, desc: "Job function list id"
          requires :industry_list_id, type: Integer, desc: "Job industry list id"
        end
        post ':id' do
          authenticate!
          begin
            job = Job.create({
                           job_title:              params[:job_title            ],
                           departement:            params[:departement          ],
                           job_code:               params[:job_code             ],
                           country:                params[:country              ],
                           state:                  params[:state                ],
                           city:                   params[:city                 ],
                           zip_code:               params[:zip_code             ],
                           min_salary:             params[:min_salary           ],
                           max_salary:             params[:max_salary           ],
                           curency:                params[:curency              ],
                           job_description:        params[:job_description      ],
                           job_requirement:        params[:job_requirement      ],
                           benefits:               params[:benefits             ],
                           job_search_keyword:     params[:job_search_keyword   ],
                           company_id:             params[:company_id           ],
                           education_list_id:      params[:education_list_id    ],
                           employment_type_list_id: params[:employment_type_list_id],
                           experience_list_id:     params[:experience_list_id   ],
                           function_list_id:       params[:function_list_id     ],
                           industry_list_id:       params[:industry_list_id     ]
                        })
            if product.save
              { status: :success }
            else
              error!({ status: :error, message: job.errors.full_messages.first }) if job.errors.any?
            end
     
          rescue ActiveRecord::RecordNotFound
            error!({ status: :error, message: :not_found }, 404)
          end
        end
      end #end resource
    end
  end
end



