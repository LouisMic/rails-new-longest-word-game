require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    cookies[:cumuled_score] = 0 if cookies[:cumuled_score].nil?
    9.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @letters
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @score = (in_dictionnary?(@word) && is_valid?(@word)) ? @word.size : 0
    @message = @score != 0 ? "Well done!" : (in_dictionnary?(@word) ? "Word doesn't match with #{@letters.join","}" : "Word not in dictionnary")
    cookies[:cumuled_score] = cookies[:cumuled_score].to_i + @score
    @cumuled_score = cookies[:cumuled_score].to_i
  end

  private

  def in_dictionnary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result = JSON.parse(URI.open(url).read)

    result["found"]
  end

  def is_valid?(word)
    word.chars.each do |char|
      return false unless @letters.include?(char.upcase)
      @letters.slice!(@letters.index(char.upcase))
    end
    return true
  end
end
