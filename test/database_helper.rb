require 'scrypt'

module Database
  def self.prepare(db)
    db.drop_table?(:users)
    db.create_table :users do
      primary_key :id

      column :name, String, null: false
      column :email, String, null: false
      column :crypted_password, String
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end

    db.drop_table?(:credentials)
    db.create_table :credentials do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, null: false

      column :provider, String, null: false
      column :crypted_password, String
      column :external_id, String
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end

    password = SCrypt::Password.create('abc123xd')
    db[:users].insert(
      name: 'test user',
      email: 'test@user.com',
      crypted_password: password,
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
