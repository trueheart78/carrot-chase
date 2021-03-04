#!/usr/bin/env ruby

# frozen_string_literal: true

class CarrotChase
  MAX_DISTANCE = 59.freeze

  def initialize
    @position = rand 0..MAX_DISTANCE
  end

  def display
    print green
    @position.times { print "." }
    print " ✨" if win?
    print "🐰"
    pellets_left.times { print "." }
    print "🥕"
    print "✨" if win?
    puts default
  end

  private

  def pellets_left
    MAX_DISTANCE - @position
  end

  def win?
    pellets_left == 0
  end

  def green
    "\033[32m"
  end

  def default
    "\033[39m"
  end
end

CarrotChase.new.display
