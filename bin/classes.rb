
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

$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]

$statuses = [
  { id: 1, cat_id: 1, text: "Curie loves string!" },
  { id: 2, cat_id: 2, text: "Markov is mighty!" },
  { id: 3, cat_id: 1, text: "Curie is cool!" }
]

class StatusesController < PhaseHigher::ControllerBase
  def initialize(*args)
    super
    $statuses.each do |status|
      Status.new(status).save
    end
  end

  def index
    statuses = $statuses.select do |s|
      s[:cat_id] == Integer(params[:cat_id])
    end

    render_content(statuses.to_s, "text/text")
  end
end

class Cats2Controller < PhaseHigher::ControllerBase
  def initialize(*args)
    super
    $cats.each do |cat|
      Status.new(cat).save
    end
  end
  
  def index
    render_content($cats.to_s, "text/text")
  end
end
