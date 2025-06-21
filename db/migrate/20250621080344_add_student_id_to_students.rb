class AddStudentIdToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :student_id, :string
  end
end
