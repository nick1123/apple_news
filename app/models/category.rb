class Category
  APPLE  = 'apple'
  IPHONE = 'iphone'
  IWATCH = 'iwatch'
  IPAD   = 'ipad'


  CATEGORY_INFO = {
    APPLE  => {title: 'Apple'},
    IPHONE => {title: 'iPhone'},
    IWATCH => {title: 'iWatch'},
    IPAD   => {title: 'iPad'},
  }

  def self.categorize(post)
    add_category_post(post, APPLE) if is_apple?(post)
#    add_category_post(post, IPHONE) if is_iphone?(post)
#    add_category_post(post, IWATCH) if is_iwatch?(post)
#    add_category_post(post, IPAD) if is_ipad?(post)
  end

  def self.is_iphone?(post)
    title = post.title.downcase
    return title.include?('iphone')
  end

  def self.is_ipad?(post)
    title = post.title.downcase
    return title.include?('ipad')
  end

  def self.is_iwatch?(post)
    title = post.title.downcase
    return title.include?('iwatch')
  end

  def self.is_apple?(post)
    return true if is_iphone?(post) || is_ipad?(post)  || is_iwatch?(post)

    title = ' ' + post.title.downcase + ' '
    [' tim cook ', ' apple ', ' icloud ', ' mac ', 'osx', ' os x '].each do |word|
      return true if title.include?(word)
    end

    return false
  end


  def self.add_category_post(post, category)
    if CategoryPost.where(post_id: post.id, category: category).count == 0
      CategoryPost.create(post_id: post.id, category: category, on_date: post.on_date)
    end
  end
end

