class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone
      t.date :date_of_birth
      t.string :grade
      t.text :address

      t.timestamps
    end

    add_index :students, :email, unique: true
    add_index :students, [:last_name, :first_name]
  end
end
