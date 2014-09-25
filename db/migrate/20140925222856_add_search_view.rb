class AddSearchView < ActiveRecord::Migration

  def up
    # Thoughtbot article on multi table indices
    execute <<-EOF
      CREATE VIEW searches AS
        SELECT monuments.id, users.id as user_id, monuments.name as monument_name, categories.name as category_name
        FROM monuments
        LEFT JOIN categories ON monuments.category_id = categories.id
        LEFT JOIN users ON monuments.user_id = users.id
    EOF

  end

  def down
    execute "DROP VIEW searches"
  end
end
