require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @title = "New Game"
    @letters = []
    10.times do
      letter = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z].sample
      @letters << letter
    end
    @letters_str = @letters.join('')
  end

  def score
    @title = 'Result'
    @word = params[:word]
    @letters = params[:letters]
    @word_arr = @word.downcase.chars
    @letters_arr = @letters.downcase.chars
    @letters_join = @letters.chars.join(', ')

    def char_to_hash(char_arr)
      arr = {}
      char_arr.each do |char|
        if arr.has_key?(char)
          arr[char] += 1
        else
          arr[char] = 1
        end
      end
      return arr
    end

    def check_valid_word?
      word_hash = char_to_hash(@word_arr)
      letters_hash = char_to_hash(@letters_arr)
      word_hash.each_pair do |char, value|
        return false unless letters_hash.has_key?(char)
        return false if letters_hash[char] < word_hash[char]
      end
      true
    end

    def check_english_word?
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      file_doc = URI.open(url).read
      file_json = JSON.parse(file_doc)
      return file_json["found"]
    end

    def result
      if !check_valid_word?
        @str1 = "Sorry but "
        @str2 = " cannot be built out of #{@letters_join}."
      elsif !check_english_word?
        @str1 = "Sorry but "
        @str2 = " does not seem to be a valid english word."
      else
        @str1 = "Congrats! "
        @str2 = " is a valid English word."
      end
    end
    result
  end
end
