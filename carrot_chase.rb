#!/usr/bin/env ruby

# frozen_string_literal: true
require 'tmpdir'

class CarrotChase
  MAX_DISTANCE     = 59
  MOVABLE_DISTANCE = 8

  def initialize
    @bun_position = rand starting_position..max_starting_position
    @sun_position = rand 0...MAX_DISTANCE
    @output = []

    save_bun_position
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

  def add_space
    @output.push ' '
  end

  def validate_sun_position
    return unless @sun_position == @bun_position

    @sun_position = if bun_at_start?
                      rand 1...MAX_DISTANCE
                    elsif heads?
                      rand 0...@bun_position
                    else
                      rand @bun_position + 1...MAX_DISTANCE
                    end
  end

  def starting_position
    @starting_position = 0

    return @starting_position unless File.exist?(temp_file)

    @starting_position = File.readlines(temp_file).map(&:chomp).first.to_i
    @starting_position = 0 if @starting_position == MAX_DISTANCE

    @starting_position
  end

  def max_starting_position
    return MAX_DISTANCE if close_starting_position?

    @starting_position += MOVABLE_DISTANCE
  end

  def save_bun_position
    File.open(temp_file, 'w') do |file|
      file.write @bun_position
    end
  end

  def temp_file
    @temp_file ||= [Dir.tmpdir, 'carrot_chase.dat'].join '/'
  end

  def bun_wins?
    @bun_position == MAX_DISTANCE
  end

  def bun_at_start?
    @bun_position.zero?
  end

  def heads?
    rand(1..2).odd?
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
