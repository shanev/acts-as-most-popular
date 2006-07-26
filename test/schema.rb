ActiveRecord::Schema.define(:version => 1) do

  create_table :people, :force => true do |t|
    t.column :name, :string
    t.column :age, :integer
    t.column :city, :string
  end

end