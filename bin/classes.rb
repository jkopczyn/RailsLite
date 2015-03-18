
#class Human < SQLObject
#  self.table_name = 'humans' 
#
#  has_many :cats, foreign_key: :owner_id 
#  belongs_to :house
#
#  finalize!
#end  
#
#class House < SQLObject
#  has_many :humans
#
#  finalize!
#end

class Status < SQLObject
  belongs_to :cat, foreign_key: :cat_id

  finalize!
end


class Cat < SQLObject
#  belongs_to :human, foreign_key: :owner_id

  finalize!
end

class StatusesController < PhaseHigher::ControllerBase
  def index
    render_content(Status.all.to_json, "text/json")
  end
end

class Cats2Controller < PhaseHigher::ControllerBase
  def index
    render_content(Cat.all.to_json, "text/json")
  end
end
