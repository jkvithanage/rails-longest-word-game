require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @word = params[:word].upcase
    @letters = JSON.parse(params[:letters])
    if on_the_grid?(@word, @letters)
      if valid_word?(@word)
        @status = "Congratulations! <strong>#{@word}</strong> is a valid English word!"
      else
        @status = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @status = "Sorry but #{@word} can't be built out of #{@lertters}"
    end
  end

  private

  def generate_grid(grid_size)
    grid = []
    alphabet = ('A'..'Z').to_a
    grid_size.times do
      grid << alphabet[rand(25)]
    end
    grid
  end

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word.downcase}"
    res = URI.open(url).read
    result = JSON.parse(res)
    result['found'] # => true means a valid english word
  end

  def on_the_grid?(word, grid)
    word.chars.all? do |char|
      word.count(char) <= grid.count(char)
    end
  end
end
