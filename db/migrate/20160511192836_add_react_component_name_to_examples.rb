class AddReactComponentNameToExamples < ActiveRecord::Migration
  def change
    add_column :examples, :react_component_name, :string
  end
end
