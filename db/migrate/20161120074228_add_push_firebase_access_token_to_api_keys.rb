class AddPushFirebaseAccessTokenToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :firebase_access_token, :string, after: :access_token
  end
end
