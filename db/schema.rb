# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_06_21_080414) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "students", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone"
    t.date "date_of_birth"
    t.string "grade"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "student_id"
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["last_name", "first_name"], name: "index_students_on_last_name_and_first_name"
  end

end
