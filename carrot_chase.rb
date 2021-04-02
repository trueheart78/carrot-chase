#!/usr/bin/env ruby

# frozen_string_literal: true
require 'tmpdir'
require 'json'

class CarrotChase
  MAX_DISTANCE     = 59
  MAX_SUN_DISTANCE = 54
  MOVABLE_DISTANCE = 10

  def initialize
    @output = []

    initiate_positions
    validate_positions
    save_positions
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
    @output.push '☀️ '
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

  def validate_positions
    return unless @sun_position == @bun_position

    @bun_position += 1
  end

  def initiate_positions
    @starting_position = 0

    load_positions

    @bun_position = rand @starting_position..max_starting_position
    @sun_position = rand 0..MAX_SUN_DISTANCE if reset_positions?

    nudge_bun
  end

  def nudge_bun
    return if @starting_position.zero?

    @bun_position += 1 if @bun_position == @starting_position
  end

  def load_positions
    return unless File.exist?(temp_file)
    return if reset_positions?

    @starting_position = cached_positions[:start].to_i
    @sun_position = cached_positions[:sun]
  end

  def max_starting_position
    return MAX_DISTANCE if close_starting_position?

    @starting_position += MOVABLE_DISTANCE
  end

  def save_positions
    File.open(temp_file, 'w') { |f| f.write position_data.to_json }
  end

  def cached_positions
    @cached_positions ||= JSON.parse(File.read(temp_file), symbolize_names: true)
  end

  def position_data
    @position_data ||= { start: @bun_position, sun: @sun_position }
  end

  def temp_file
    @temp_file ||= [Dir.tmpdir, 'carrot_chase.json'].join '/'
  end

  def reset_positions?
    cached_positions[:start] == MAX_DISTANCE
  rescue Errno::ENOENT
    true
  end

  def bun_wins?
    @bun_position == MAX_DISTANCE
  end

  def close_starting_position?
    (MAX_DISTANCE - @starting_position) < MOVABLE_DISTANCE
  end

  def set_grass_as_green
    @output.push "\033[32m"
  end

  def reset_output_color
    @output.push "\033[39m"
  end
end

puts CarrotChase.new
