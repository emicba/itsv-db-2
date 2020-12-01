## 1. Install Redis with docker.

- Add port mapping.
- Set up a bindmount volume.

`$ docker run --name redis --rm -v redis-data:/data/ -p 6379:6379 redis`

## 2. Connect to Redis and run basic commands

- Write the command to connect using the cli
- do a ping
- get config values
- etc

`$ docker exec -it redis redis-cli`

## 3. Write examples with string

```
SET emoji ✨

GET emoji
"\xe2\x9c\xa8"
```

## 4. Write examples with hashes

```
HMSET hash hello there alice smith

HGET hash hello
"there"

HGETALL hash
1) "hello"
2) "there"
3) "alice"
4) "smith"
```

## 5. Write examples with Lists

```
LPUSH list hello
LPUSH list there

LRANGE list 0 0
1) "there"

LRANGE list 0 -1
1) "there"
2) "hello"
```

## 6. Write examples with Sets

```
SADD set hello
SADD set there

SMEMBERS set
1) "there"
2) "hello"

SCARD set
(integer) 2
```

## 7. Write examples with Sorted Sets

```
ZINCRBY zset 10 user1
"10"

ZADD zset 20 user2
(integer) 1

ZRANGE zset 0 -1 WITHSCORES
1) "user1"
2) "10"
3) "user2"
4) "20"

ZREVRANGE zset 0 -1 WITHSCORES
1) "user2"
2) "20"
3) "user1"
4) "10"
```

## 8. Write examples using Publish Subscribe

```
SUBSCRIBE channel1

PUBLISH channel1 ✨
(integer) 1

1) "message"
2) "channel1"
3) "\xe2\x9c\xa8"
```

## 9. Write examples using Transactions

```
MULTI
OK

ZINCRBY zset 10 user1
QUEUED

ZINCRBY zset 10 user1
QUEUED

EXEC
1) "20"
2) "30"
```

## 10. Investigate backups

### _You can create a backup using `SAVE`, which is stored in `/data/dump.rdb`. Also you can save the database in background using `BGSAVE`_

## 11. Investigate Benchmarks - Run some

```
$ redis-benchmark -t lpush -n 100000 -q
LPUSH: 33079.72 requests per second

$ redis-benchmark -t set,get -n 100000 -q
SET: 33568.31 requests per second
GET: 33145.51 requests per second
```
