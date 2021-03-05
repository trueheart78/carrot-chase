#!/usr/bin/env ruby

# frozen_string_literal: true

class CarrotChase
  MAX_DISTANCE = 59.freeze

  def initialize
    @bun_position = rand 0..MAX_DISTANCE
    @sun_position = rand 0...MAX_DISTANCE
    @sun_inserted = false
    @output = []
  end

  def to_s
    build_output unless @output.any?
    
    @output.join
  end

  private
  
  def build_output
    validate_sun_position
    set_green_grass
    add_starting_grass
    if bun_wins?
      celebrate
    else
      long_for_victory
    end
    reset_color
  end
  
  def celebrate
    add_space
    add_sparkles
    add_carrot
    add_sparkles
  end
  
  def long_for_victory
    add_bun
    add_remaining_grass
    add_carrot
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
  
  def add_starting_grass
    @output << ('.' * @bun_position)
  end
  
  def add_remaining_grass
    @output << ('.' * distance_left)
  end
  
  def add_sun
    @output << ['☀️','🌤','⛅️','🌥'].sample
  end
  
  def add_bun
    @output << '🐰'
  end
  
  def add_carrot
    @output << '🥕'
  end

  def distance_left
    @distance_left ||= MAX_DISTANCE - @bun_position
  end

  def bun_wins?
    distance_left == 0
  end
  
  def bun_at_start?
    @bun_position == 0
  end
  
  def sun_inserted?
    @sun_inserted
  end
  
  def heads?
    rand(1..2).odd?
  end
  
  def add_sparkles
    @output << '✨'
  end
  
  def add_space
    @output << ' '
  end
  
  def set_green_grass
    @output << '\033[32m'
  end

  def reset_color
    @output << '\033[39m'
  end
end

puts CarrotChase.new
