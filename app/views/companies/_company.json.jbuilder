json.extract! company, :id, :company_name, :company_website, :company_email, :company_phone, :industry, :created_at, :updated_at
json.url company_url(company, format: :json)