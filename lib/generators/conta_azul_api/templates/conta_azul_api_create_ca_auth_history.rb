class ContaAzulApiCreateCaAuthHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :ca_auth_histories do |t|
      t.string   :access_token,  null: false
      t.string   :refresh_token, null: false
      t.datetime :expires_at,    null: false

      t.timestamps
    end
  end
end
