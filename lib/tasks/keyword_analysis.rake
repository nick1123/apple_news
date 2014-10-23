desc "Keyword Analysis"
task :keyword_analysis => :environment do
  keyword_hash = Hash.new(0)
  CategoryPost.includes(:post).where(category: 'apple').each do |cp|
    post = cp.post
    keywords = Post.extract_keywords(post.title)
    puts post.title
    puts keywords.inspect
    puts ''

    keywords.uniq.each {|keyword| keyword_hash[keyword] += 1}
  end

#  puts keyword_hash
  keyword_hash.sort_by {|k,v| v}.each {|keyword, count| puts "#{count}\t#{keyword}" }
end
