class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|

      t.belongs_to  :user
      t.integer     :service, null: false
      t.string      :recipient, null: false
      t.string      :message, null: false
      t.boolean     :was_sent, default: false
      t.integer     :attempts, default: 0

      t.timestamps
    end
  end
end
