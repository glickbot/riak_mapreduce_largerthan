riak_mapreduce_largerthan
=========================

### Usage

#### Install the Map Redude function:
## Warnings:
* You need to install this onto *all* nodes in the cluster
* The mapreduce function will be available *until any node restarts*
* Instructions for making the function persist across node restarts is below


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

### *Optional*: Make persistant across node restarts:
``` bash
$ cp /tmp/riak_mapreduce_largerthan.beam /usr/&lt;libdir&gt;/riak/lib/basho-patches
```
( where &lt;libdir&gt; depends on OS, but is usually ether 'lib' or 'lib64' )

#### Query the new mapreduce function:
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
### run_mapred_json.sh
``` bash
#!/bin/bash
HOST="localhost:8098"
CHUNKED="false"

if [ -z $1 ]; then
   echo "Usage: $0 mapreduce.json"
   exit
fi
curl -X POST -H "content-type: application/json" -H "Accept: application/json" http://$HOST/mapred?chunked=$CHUNKED --data @$1
```
Example:

``` bash
$ ./run_mapred_json.sh mapred_test.json
```

where mapred_test.json is:
``` json
{
    "inputs":"test",
    "query":[
        { "map": {
          "language":"erlang",
          "module":"riak_mapreduce_largerthan",
          "function":"map_largerthan",
          "keep":true,
          "arg":["10485760"]
        }}
     ]
}
```