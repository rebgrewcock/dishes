# frozen_string_literal: true

require_relative "rgrewcock_dishes/version"
require_relative "rgrewcock_dishes/dishes.csv"

module RgrewcockDishes

require 'csv'

  #takes in dish name and returns its ingredients string.
  def dish_to_ingredients(dish_key, data)
  	if data[dish_key.downcase]
  		ingredients = data[dish_key.downcase].join(", ")
  	else
  		ingredients = nil
  	end
  end

  #returns ingredients sentence from dish name and ingredients
  def construct_ingredients_sentence(ingredients, dish_arg)
  	if ingredients
  		ingredients_sentence = "Ingredients for #{dish_arg}: #{ingredients}."
  	else
  		ingredients_sentence = "I don't know the ingredients for #{dish_arg}."
  	end
  end

  #takes in dish_arg, dish_key, returns ingredients sentence
  def dish_to_sentence(dish_arg, dish_key, data)
  	ingredients = dish_to_ingredients(dish_key, data)
  	sentence = construct_ingredients_sentence(ingredients, dish_arg)
  end

  #returns the names of all dishes in hash
  def list_all_dishes(table)
  	dishes = table.keys
  end

  #returns hash{ingredient => number}
  def build_count_hash(ingredients)
  	ing_num_hash = {}
  	ingredients.each do |ingredient|
  		if ing_num_hash[ingredient]
  			ing_num_hash[ingredient] += 1
  		else
  			ing_num_hash[ingredient] = 1
  		end
  	end
  	ing_num_hash
  end

  #returns array of strings for ingredients with number (where >2 dishes)
  def build_counted_dishes_array(ingredients_num_hash)
  	ing_array = []
  	ingredients_num_hash.each do |ingr, num|
  		if num > 1
  			ingr_string = ingr + " (*" + num.to_s + " dishes)"
  		else
  			ingr_string = ingr
  		end
  		ing_array << ingr_string
  	end
  	ing_array
  end

  #returns shopping list array
  def make_shopping_list(ingr_array, no_ingr_dishes)
  	ingredients_string = ingr_array.uniq.sort.join("\n")
  	shopping_list = []
  	shopping_list << ingredients_string
  	if !no_ingr_dishes.empty?
  		shopping_list << "I don't know the ingredients for #{no_ingr_dishes.join(", ")}."
  	end
  	shopping_list
  end

  #----------------

  #reads csv into array of arrays.
  doc = CSV.read("dishes.csv")

  #transforms array of arrays into a hash.
  table = {}
  doc.each do |array|
  	table[array.shift] = array.compact
  end

  #transforms all keys in hash to lower case.
  table.transform_keys!(&:downcase)

  #----------------

  #dinner inspire returns all dishes in hash
  def inspire
  	returns list_all_dishes(table)
  end

  #----------------

  #dinner combine returns ingredients for all dishes
  def combine(dish_array)
  	if !dish_array.empty?
  		ingredients = []
  		no_ingredients_dishes = []
  		dish_array.each do |dish_element|
  			arg_string = dish_element.downcase
  			if table[arg_string]
  				#concat makes array rather than array of arrays
  				ingredients.concat(table[arg_string])
  			else
  				no_ingredients_dishes << dish_element
  			end
  		end
  	else
  		abort("Please include a dishy argument.")
  	end

  	#builds hash to count ingredients
  	ingredients_num_hash = build_count_hash(ingredients)

  	#appends number to repeated ingredients
  	ingredients_array = build_counted_dishes_array(ingredients_num_hash)

  	#builds shopping list
  	shopping_list = make_shopping_list(ingredients_array, no_ingredients_dishes).join("\n")
  end

  #----------------

end
