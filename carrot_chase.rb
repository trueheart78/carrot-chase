#!/usr/bin/env ruby

# frozen_string_literal: true

class CarrotChase
  MAX_DISTANCE = 59.freeze

  def initialize
    @bun_position = rand 0..MAX_DISTANCE
    @sun_position = rand 0...MAX_DISTANCE
    @output = []
    
    validate_sun_position
  end

  def to_s
    build_output unless @output.any?
    
    @output.join
  end

  private
  
  def build_output
    set_grass_as_green
    add_starting_grass
    if bun_wins?
      celebrate_win
    else
      long_for_victory
    end
    reset_output_color
  end
  
  def celebrate_win
    add_space
    add_sparkles
    add_bun
    add_carrot
    add_sparkles
  end
  
  def long_for_victory
    add_bun
    add_remaining_grass
    add_carrot
  end
  
  def add_starting_grass
    add_grass 0...@bun_position
  end
  
  def add_remaining_grass
    add_grass @bun_position+1...MAX_DISTANCE
  end
  
  def add_grass(range)
    range.each do |n|
      if @sun_position == n
        add_sun
        next
      end
      
      @output.push '.'
    end
  end
  
  def add_sun
    @output.push ['☀️','🌤','⛅️','🌥'].sample
  end
  
  def add_bun
    @output.push '🐰'
  end
  
  def add_carrot
    @output.push '🥕'
  end

  def add_sparkles
    @output.push '✨'
  end
  
  def add_space
    @output.push ' '
  end

  def validate_sun_position
    return unless @sun_position == @bun_position
    
    if bun_at_start?
      @sun_position = rand 1...MAX_DISTANCE
    else
      if heads?
        @sun_position = rand 0...@bun_position
      else
        @sun_position = rand @bun_position+1...MAX_DISTANCE
      end
    end
  end

  def bun_wins?
    @bun_position == MAX_DISTANCE
  end
  
  def bun_at_start?
    @bun_position == 0
  end
  
  def heads?
    rand(1..2).odd?
  end
  
  def set_grass_as_green
    @output.push "\033[32m"
  end

  def reset_output_color
    @output.push "\033[39m"
  end
end

puts CarrotChase.new
