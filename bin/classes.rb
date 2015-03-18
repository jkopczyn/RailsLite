
class Human < SQLObject
  self.table_name = 'humans' 

  has_many :cats, foreign_key: :owner_id 
  belongs_to :house

  def name
    "#{fname} #{lname}"
  end

  finalize!
end  

class House < SQLObject
  has_many :humans

  finalize!
end

class Status < SQLObject
  belongs_to :cat, foreign_key: :cat_id

  finalize!
end


class Cat < SQLObject
  belongs_to :human, foreign_key: :owner_id

  finalize!
end

class StatusesController < PhaseHigher::ControllerBase
  def index
    statuses = Status.where({cat_id: params[:cat_id]})
    render_content(statuses.to_json, "text/json")
  end
end

class CatsController < PhaseHigher::ControllerBase
  def index
    @cats = Cat.all.map { |cat| cat.attributes.to_json }.join(",\n")
    render :index
  end

  def show
    @cat = (Cat.where({id: params[:id]})).first
    render :show
  end
end
