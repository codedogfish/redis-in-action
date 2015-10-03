require 'redis'

redis=Redis.new

redis.set('redis_db','great k/v storage')
puts 'redis_db'
puts redis.get('redis_db')
#puts redis.get('redis_db').value

redis.incrby('counter',99)
redis.hmset('hash_dt',:key1,'value1',:key2,'value2')

redis['key1']='value1'
puts 'key1'
puts redis['key1']
#puts redis['key1'].value

redis.set('key2','value2')
puts 'multi key2'
puts redis.get('key2')

redis.multi do
    redis.set('key2','value2')
    #puts 'multi key2'
    #puts redis.get('key2')
    @value = redis.get('key2')
    redis.set('key3','0')
    @number = redis.incr('key3')
end

puts 'key2'
puts @value.value
#puts @value
puts 'key3'
puts @number.value
#puts @number
