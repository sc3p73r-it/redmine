class AddMissingIndexesToRepositories < ActiveRecord::Migration[4.2]
  def self.up
    add_index :repositories, :project_id
  end

  def self.down
    remove_index :repositories, :project_id
  end
end
