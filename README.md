riak_mapreduce_largerthan
=========================

### Usage
``` bash
$ mkdir /tmp/beam && chown riak:riak /tmp/beam
$ cd /tmp/beam
$ curl -O https://raw.github.com/glickbot/riak_mapreduce_largerthan/master/riak_mapreduce_largerthan.erl
$ riak attach
```
Inside riak attach:
``` erl
1> cd("/tmp/beam").
/tmp/beam
ok
2> c(riak_mapreduce_largerthan).
{ok,riak_mapreduce_largerthan}
> ^D
[Quit]
```

Use the following to query the mapreduce function, note the byte size argument in the map function:
``` bash
curl -X POST -H "content-type: application/json" -H "Accept: application/json" http://localhost:8098/mapred --data @-<<\EOF
{"inputs":"bucketname",
"query":[
{"map":{"language":"erlang","module":"riak_mapreduce_largerthan","function":"map_largerthan", "keep":true, "arg":["83886080"]}}
]}
EOF
```

Use the following URL to stream results:
```
http://localhost:8098/mapred?chunked=true
```