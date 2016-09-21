module API
  module V1
    class Applicants < Grape::API
      version 'v1'
      format :json

      helpers do
        params :applicant_id do
          requires :id, type: Integer, desc: "Applicant id" 
        end

      end

      resource :applicants do
        desc "Applicant List", {
          :notes => <<-NOTE
          Get All Applicants
          --------------------
          NOTE
        }
        get do
          puts current_user.nil?
          Applicant.all
        end

        desc "Applicant By Id", {
          :notes => <<-NOTE
          Get Applicant By Id
          --------------------
          NOTE
        }
        params do
          use :applicant_id       
        end
        get ":id" do
          begin
            Applicant.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            error!({status: :not_found}, 404)
          end
        end

        desc "Delete Applicant By Id", {
          :notes => <<-NOTE
          Delete Applicant By Id
          --------------------
          NOTE
        }
        params do
          use :applicant_id      
        end
        delete ":id" do
          authenticate!
          begin
            applicant = Applicant.find(params[:id])
            { status: :success } if applicant.destroy
          rescue ActiveRecord::RecordNotFound
            error!({status: :error, message: :not_found}, 404)
          end
        end

        desc "Update Applicant By Id", {
          :notes => <<-NOTE
          Update Applicant By Id
          --------------------
          NOTE
        }
        params do
          use :applicant_id
          requires :applicant_title, type: String, desc: "Applicant title"
          requires :departement, type: String, desc: "Applicant departement"
          requires :applicant_code, type: String, desc: "Applicant code"
          requires :country, type: String, desc: "Applicant country"
          requires :state, type: String, desc: "Applicant state"
          requires :city, type: String, desc: "Applicant city"
          requires :zip_code, type: String, desc: "Applicant zip_code"
          requires :min_salary, type:Integer, desc: "Applicant min_salary"
          requires :max_salary, type:Integer, desc: "Applicant max_salary"
          requires :curency, type: String, desc: "Applicant curency"
          requires :applicant_description, type: String, desc: "Applicant curency"
          requires :applicant_requirement, type: String, desc: "Applicant curency"
          requires :benefits, type: String, desc: "Applicant curency"
          requires :applicant_search_keyword, type: String, desc: "Applicant search keyword"
          requires :education_list_id, type: Integer, desc: "Applicant education list id"
          requires :employment_type_list_id, type: Integer, desc: "Applicant employment type list_id"
          requires :experience_list_id, type: Integer, desc: "Applicant experience list id"
          requires :function_list_id, type: Integer, desc: "Applicant function list id"
          requires :industry_list_id, type: Integer, desc: "Applicant industry list id"
        end
        put ':id' do
          authenticate!
          begin
            applicant = Applicant.find(params[:id])
            if applicant.update({
                           id:                     params[:id                   ],
                           applicant_title:              params[:applicant_title            ],
                           departement:            params[:departement          ],
                           applicant_code:               params[:applicant_code             ],
                           country:                params[:country              ],
                           state:                  params[:state                ],
                           city:                   params[:city                 ],
                           zip_code:               params[:zip_code             ],
                           min_salary:             params[:min_salary           ],
                           max_salary:             params[:max_salary           ],
                           curency:                params[:curency              ],
                           applicant_description:        params[:applicant_description      ],
                           applicant_requirement:        params[:applicant_requirement      ],
                           benefits:               params[:benefits             ],
                           applicant_search_keyword:     params[:applicant_search_keyword   ],
                           company_id:             params[:company_id           ],
                           education_list_id:      params[:education_list_id    ],
                           employment_type_list_id: params[:employment_type_list_id],
                           experience_list_id:     params[:experience_list_id   ],
                           function_list_id:       params[:function_list_id     ],
                           industry_list_id:       params[:industry_list_id     ]
                        })
              { status: :success }
            else
              error!({ status: :error, message: applicant.errors.full_messages.first }) if applicant.errors.any?
            end
     
          rescue ActiveRecord::RecordNotFound
            error!({ status: :error, message: :not_found }, 404)
          end
        end

        desc "Create Applicant", {
          :notes => <<-NOTE
          Create Applicant By
          --------------------
          NOTE
        }
        params do
          requires :applicant_title, type: String, desc: "Applicant title"
          requires :departement, type: String, desc: "Applicant departement"
          requires :applicant_code, type: String, desc: "Applicant code"
          requires :country, type: String, desc: "Applicant country"
          requires :state, type: String, desc: "Applicant state"
          requires :city, type: String, desc: "Applicant city"
          requires :zip_code, type: String, desc: "Applicant zip_code"
          requires :min_salary, type:Integer, desc: "Applicant min_salary"
          requires :max_salary, type:Integer, desc: "Applicant max_salary"
          requires :curency, type: String, desc: "Applicant curency"
          requires :applicant_description, type: String, desc: "Applicant curency"
          requires :applicant_requirement, type: String, desc: "Applicant curency"
          requires :benefits, type: String, desc: "Applicant curency"
          requires :applicant_search_keyword, type: String, desc: "Applicant search keyword"
          requires :education_list_id, type: Integer, desc: "Applicant education list id"
          requires :employment_type_list_id, type: Integer, desc: "Applicant employment type list_id"
          requires :experience_list_id, type: Integer, desc: "Applicant experience list id"
          requires :function_list_id, type: Integer, desc: "Applicant function list id"
          requires :industry_list_id, type: Integer, desc: "Applicant industry list id"
        end
        post ':id' do
          authenticate!
          begin
            applicant = Applicant.create({
                           applicant_title:              params[:applicant_title            ],
                           departement:            params[:departement          ],
                           applicant_code:               params[:applicant_code             ],
                           country:                params[:country              ],
                           state:                  params[:state                ],
                           city:                   params[:city                 ],
                           zip_code:               params[:zip_code             ],
                           min_salary:             params[:min_salary           ],
                           max_salary:             params[:max_salary           ],
                           curency:                params[:curency              ],
                           applicant_description:        params[:applicant_description      ],
                           applicant_requirement:        params[:applicant_requirement      ],
                           benefits:               params[:benefits             ],
                           applicant_search_keyword:     params[:applicant_search_keyword   ],
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
              error!({ status: :error, message: applicant.errors.full_messages.first }) if applicant.errors.any?
            end
     
          rescue ActiveRecord::RecordNotFound
            error!({ status: :error, message: :not_found }, 404)
          end
        end
      end #end resource
    end
  end
end



