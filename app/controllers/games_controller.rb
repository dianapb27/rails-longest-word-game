require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample(1).join
    end
    @letters
  end

  def score
    if params[:word]
      @word = params[:word]
    end
    if params[:letters]
      @letters = params[:letters]
    end
    # check if word is valid with the dictionary app
    @english_word = english_word?(@word)
    # check if it matches the grid letters
    @word_in_grid = word_from_grid(@word, @letters)
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_result = open(url).read
    word_found = JSON.parse(word_result)
    word_found['found']
  end

  def word_from_grid(word, grid)
    word.chars.all? do |letter|
      grid.count(letter.upcase) >= word.upcase.count(letter.upcase)
    end
  end
end
