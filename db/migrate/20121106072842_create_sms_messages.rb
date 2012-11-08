class CreateSmsMessages < ActiveRecord::Migration
  def change
    create_table :sms_messages do |t|
      t.integer :country_code
      t.string :mobile_number
      t.text :content
      t.string :gateway
      t.string :status_code

      t.timestamps
    end
    add_index :sms_messages, :mobile_number
  end
end
