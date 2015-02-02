require 'sinatra'
require 'dinosaurus'
require_relative 'assets/dinokey.rb'

  Dinosaurus.configure do |config|
    key = Dinokey.new
    config.api_key = key.generate
  end

  before do
    # redis = Redis.new(:host => 'localhost', :port => 9292, :db => 15)
    # redis = Redis.new(:host => 'localhost', :port => 9292, :db => 15)
    # redis.set("key", "0")
    @clicked = false
  end

  get '/' do 
    erb :index
  end

  get '/error' do
    erb :error
  end

  post '/tweet' do 
    @clicked = true
    word = rejoiner(params[:tweet])
    # if hit_limit?
    #   redirect '/error'
    # else
    @link = "http://twitter.com/home?status=" + word
    redirect @link
    # end
  end

  # def hit_limit?
  #  redis.get("key")>1000? true : false
  # end


  def rejoiner(string)
    string.split(" ").map { |word| get_not_prep(word)}.join("%20")
  end

  def get_not_prep(word)
    word = word.downcase

    word_ary = ["a", "am", "about", "above", "according to", "across", "after", "against", "along",
      "with", "among", "apart", "around", "as", "for", "at", "because", "of", "be",
      "before", "behind", "below", "beneath", "beside", "between", "beyond", "but",
      "by", "means", "concerning", "despite", "down", "up", "during", "except",
      "from", "in", "instead", "into", "like", "near", "of", "off", "on", "onto",
      "out", "over", "to", "till", "toward", "through", "throughout", "until", "with",
      "within", "without", "toward", "since", "should",
      "under", "underneath", "until", "unlike", "upon", "i", "you", "he", "she",
      "him", "her", "other", "there", "they", "them", "that", "this", "me", "my", "his",
      "hers", "their"]

      val = word_ary.include? word
      val==false ? get_synonym(word) : word
    end

  # picks random synonym out of array of synonyms
  def get_synonym(word)
    results = Dinosaurus.synonyms_of(word)
    # count = redis.get("key")

    # if next_day? || count == "0"
    #   redis.set("key", "1")
    #   timer.set("t0", Time.now)
    # else
    #   count++
    #   redis.incr("key")
    #   timer.set("t1", Time.now)
    # end

    len = rand(results.length)
    len==0? word : word = results[len]
  end

  # def next_day?
  #   diff = timer.get("t1") - timer.get("t0")
  #   diff<86400? false : true
  # end

