class Post < ActiveRecord::Base
  has_many :category_posts

  def self.calculate_hex_color_code(min_hex_code="FFCCCC", percent)
    raise "Bad percent param!!!" unless percent <= 1.0 && percent >= 0
    red_min   = min_hex_code[0..1].to_i(16)
    blue_min  = min_hex_code[2..3].to_i(16)
    green_min = min_hex_code[4..5].to_i(16)

    red_new   = red_min   + ((255 - red_min)   * (1 - percent)).round
    blue_new  = blue_min  + ((255 - blue_min)  * (1 - percent)).round
    green_new = green_min + ((255 - green_min) * (1 - percent)).round

    return "#{red_new.to_s(16)}#{blue_new.to_s(16)}#{green_new.to_s(16)}".upcase
  end

  def self.extract_keywords(title)
    # Modify tile
    title = title.downcase.gsub(/[\u2018\u2019]/, "'").gsub(/[\u201C\u201D]/, '')

    ['(', ')', '[', ']', "'s ", ' - '].each do |chars|
      title.gsub!(chars, ' ')
    end

    title = title.gsub(/\s+/, ' ').strip

    # Split title into words
    words = title.split(/\s+/)

    # Remove leading & trailing chars from each word
    [':', '?', ',', "'"].each do |char|
      words = words.map do |word|
        word.chomp(char).reverse.chomp(char).reverse
      end
    end

    n2 = ngrams(words, 2)
    n3 = ngrams(words, 3)
    words.concat(n2).concat(n3)
    return words
  end

  def self.ngrams(words, n)
    words.each_cons(n).to_a.map {|a| a.join(' ')}
  end
end

