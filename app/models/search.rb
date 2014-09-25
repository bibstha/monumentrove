class Search < ActiveRecord::Base
  
  def initialize query, user_id
    @query = query
    @user_id = user_id
  end

  def results
    self.class.basic_search({monument_name: @query, category_name: @query}, false)
      .basic_search(user_id: @user_id)
  end

end
