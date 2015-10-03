# 获得标签的所有前缀
#
# @example
# get_prefixes('word')
# #=>['w','wo','wor','word*']
def get_prefixes(word)
    Array.new(word.length) do |i|
        if i == word.length-1
            "#{word}*"
        else
            word[0..i]
        end
    end
end

require 'redis'

redis = Redis.new

redis.del('autocomplete')

argv = []
File.open('words.txt').each_line do |word|
    get_prefixes(word.chomp).each do |prefix|
        argv << [0,prefix]
    end
end

redis.zadd('autocomplete',argv)

while prefix = gets.chomp do
    result = []
    if(rank = redis.zrank('autocomplete',prefix))
        # 存在以用户输入的内容为前缀的标签
        redis.zrange('autocomplete',rank+1,rank+100).each do |word|
            # 获得该前缀后的100个元素
            if word[-1] == '*' && prefix == word[0..prefix.length-1]
                # 如果以“*”结尾并以用户输入的内容为前缀则假如结果中
                result << word[0..-2]
            end
        end
        puts result
    end
end

