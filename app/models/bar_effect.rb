class BarEffect < SkillEffect

  def use(source,target)
    self.source_character = source
    self.target_character = target
    if evadeable and roll_for_evade
      message = "  #{name} evaded\n"
      puts message
      message
    elsif defendable and roll_for_defence
      message = "  #{name} defended\n"
      puts message
      message
    else
      amount = source_character.send(related_trait)
      amount *= magnitude
      critical = roll_for_critical
      if critical
        amount *= CRITICAL_MULTIPLIER
      end
      message =  "  #{"Critical " if critical}#{name}: #{target_trait} #{"+"if amount >= 0}#{amount.to_i}\n"
      # this gets the result, then adjusts it for max/min on bars
      target_amount = (target_character.send("#{target_trait}") + amount.to_i)
      target_amount = adjust_amount_for_limit(target_amount)
      target_character.update_attribute target_trait, target_amount
      puts message
      message
    end
  end

  def adjust_amount_for_limit(target_amount)
    if target_character.respond_to?("max_#{target_trait}")
      max = target_character.send("max_#{target_trait}")
      if target_amount > max
        max
      elsif target_amount <= 0
        0
      else
        target_amount
      end
    else
      target_amount
    end
  end

end
