module FactorsHelper
	def sum_max_possible_value
		sum = 0
		Factor.all.where("active = true").each do |factor|	
			sum += factor.factor_guidlines.pluck(:value).max.to_i
		end
		sum
	end

	def max_value(factor_id)
    	Factor.find(factor_id).factor_guidlines.pluck(:value).max.to_i   
  end
end
