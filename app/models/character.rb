class Character < ActiveRecord::Base

  belongs_to :character_class

  validates_presence_of :name
  validates_presence_of :character_class
  
  has_and_belongs_to_many :skills
  delegate :character_class_skills, :playable, :to => :character_class

  BARS = ['health','skill']
  TRAITS = ['attack','defence','melee','ranged','evade','luck','speed']

  
  LEVEL_UP_INCREMENT = 2

  # initialize from class

  before_create :copy_class

  def copy_class
    # TODO limit this to 100
    TRAITS.each do |trait|
      calc_trait = character_class.send("init_#{trait}")
      calc_trait += (self.level - 1) * character_class.send("#{trait}_mod") if self.level > 1
      self.send("#{trait}=",calc_trait)
    end
    BARS.each do |bar|
      calc_bar = character_class.send("init_#{bar}")
      calc_bar += chacter_class.send("#{bar}_mod") * (self.level - 1) if self.level > 1
      self.send("max_#{bar}=",calc_bar)
    end
    self.full_recover(true)
    self.get_skills(true)
  end

  def full_recover(skip_save=false)
    self.health = self.max_health
    self.skill  = self.max_skill
    self.save unless skip_save
  end

  # Level Methods

  before_save :check_for_level

  def check_for_level
    until self.exp <= self.level_up_target
      self.level_up(false)
      self.level_up_target *= LEVEL_UP_INCREMENT 
    end
  end

  def level_up(save=true)
    self.level += 1
    self.get_skills
    TRAITS.each do |trait|
      self.send("#{trait}=",self.send("#{trait}") + character_class.send("#{trait}_mod"))
    end
    BARS.each do |bar|
      self.send("max_#{bar}=",(self.send("max_#{bar}") + character_class.send("#{bar}_mod")))
    end 
    self.full_recover(true)
  end

  def get_skills(creating=false)
    if creating
      class_skills = character_class_skills(:conditions => ["from_level =< ? and automatic = ?",self.level,true])
      class_skills.each do |class_skill|
        self.skills << class_skill.skill
      end
    end
  end 

  # Battle Methods

  def skill_options
    skills.collect{|skill| [skill.label,skill.id]}
  end

  def skill_targets(skill)
    skill = Skill.find(skill) if skill.is_a?(Integer)
    hit_player = skill.offensive
    hit_player = !hit_player if !self.playable
    if hit_player
      targets = Character.all.select{|c|!c.playable}
    else
      targets = Character.all.select{|c|c.playable}
    end
    targets.collect{|target|[target.name,target.id]}
  end

  def use_skill(skill,target_character)
    skill = Skill.find(skill) if skill.is_a?(Integer)
    target_character = Character.find(target_character) if target_character.is_a?(Integer)
    skill.use(self,target_character)
  end

  def dead?
    health <= 0
  end

  def alive?
    health > 0
  end  

end
