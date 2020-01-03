全文搜索属于最常见的需求，开源的 Elasticsearch （以下简称 Elastic）是目前全文搜索引擎的首选。
它可以快速地储存、搜索和分析海量数据。维基百科、Stack Overflow、Github 都采用它。

# 一、安装
## jdk1.7.0_79+elasticsearch-2.4.6
## https://www.elastic.co/guide/en/elasticsearch/reference/6.3/setup.html

Elasticsearch is built using Java, and requires at least Java 8 in order to run. Only Oracle’s Java and the OpenJDK are supported. The same JVM version should be used on all Elasticsearch nodes and clients.

We recommend installing Java version 1.8.0_131 or a later version in the Java 8 release series. We recommend using a supported LTS version of Java. Elasticsearch will refuse to start if a known-bad version of Java is used.

The version of Java that Elasticsearch will use can be configured by setting the JAVA_HOME environment variable.

jdk1.8.0_181(jdk-8u181) 

download from https://www.elastic.co/downloads/past-releases/elasticsearch-6-3-0

elasticsearch-6.3.0.tar.gz

tar zxvf elasticsearch-6.3.0.tar.gz
sudo mv elasticsearch-6.3.0 /usr/local


Installation
After downloading the latest release and extracting it, elasticsearch can be started using:

$ sudo chmod -R 777 /usr/local/elasticsearch-6.3.0/config
$ sudo chmod -R 777 /usr/local/elasticsearch-6.3.0/logs
$ bin/elasticsearch
unable to load JNA native support library=>
cd /usr/local/elasticsearch-6.3.0/lib
sudo mv jna-4.5.1.jar jna-4.5.1.jar.bak
wget http://repo1.maven.org/maven2/net/java/dev/jna/jna/4.5.1/jna-4.5.1.jar

unable to install syscall filter=>
原因:因为ubuntu14.04(32-bit)不支持SecComp，而ES6.3.0默认bootstrap.system_call_filter为true进行检测，所以导致检测失败，失败后直接导致ES不能启动。详见:elastic/elasticsearch#22899
解决方案：在elasticsearch.yml中配置bootstrap.system_call_filter为false，注意要在Memory下面:
bootstrap.memory_lock: false
bootstrap.system_call_filter: false

max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]=>
原因：无法创建本地文件问题,用户最大可创建文件数太小
解决方案：
切换到root用户，编辑limits.conf配置文件， 添加类似如下内容：
vi /etc/security/limits.conf
添加如下内容:
* soft nofile 65536
* hard nofile 131072
* soft nproc 2048
* hard nproc 4096


备注：* 代表Linux所有用户名称（比如 hadoop）
保存、退出、重新登录才可生效

max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
原因：最大虚拟内存太小
解决方案：切换到root用户下，修改配置文件sysctl.conf
vi /etc/sysctl.conf
添加下面配置：
vm.max_map_count=655360
并执行命令：
sysctl -p
然后重新启动elasticsearch，即可启动成功。

max number of threads [2048] for user [simon] is too low, increase to at least [4096]
切换到root用户，编辑limits.conf配置文件， 添加类似如下内容：
vi /etc/security/limits.conf
simon soft nproc 4096


X-Pack is not supported and Machine Learning is not available for [linux-x86]; you can use the other X-Pack features (unsupported) by setting xpack.ml.enabled: false in elasticsearch.yml

df -h

ps -p 6063 -o comm=
=>java
ps aux|grep java

On *nix systems, the command will start the process in the foreground.
Running as a daemon
To run it in the background, add the -d switch to it:
$ bin/elasticsearch -d

PID
The Elasticsearch process can write its PID to a specified file on startup, making it easy to shut down the process later on:
$ bin/elasticsearch -d -p pid 
$ kill `cat pid` 
The PID is written to a file called pid. 

*NIX

There are added features when using the elasticsearch shell script. The first, which was explained earlier, is the ability to easily run the process either in the foreground or the background.

Another feature is the ability to pass -D or getopt long style configuration parameters directly to the script. When set, all override anything set using either JAVA_OPTS or ES_JAVA_OPTS. For example:

$ bin/elasticsearch -Des.index.refresh_interval=5s --node.name=my-node

Without going too much into detail, we can see that our node named "New Goblin" (which will be a different Marvel character in your case) has started and elected itself as a master in a single cluster. Don’t worry yet at the moment what master means. The main thing that is important here is that we have started one node within one cluster.

As mentioned previously, we can override either the cluster or node name. This can be done from the command line when starting Elasticsearch as follows:

./elasticsearch --cluster.name my_cluster_name --node.name my_node_name

Also note the line marked http with information about the HTTP address (192.168.8.112) and port (9200) that our node is reachable from. By default, Elasticsearch uses port 9200 to provide access to its REST API. This port is configurable if necessary.

如果一切正常，Elastic 就会在默认的9200端口运行。这时，打开另一个命令行窗口，请求该端口，会得到说明信息。
$ curl localhost:9200

默认情况下，Elastic 只允许本机访问，如果需要远程访问，可以修改 Elastic 安装目录的config/elasticsearch.yml文件，去掉network.host的注释，将它的值改成0.0.0.0，然后重新启动 Elastic。
network.host: 0.0.0.0
上面代码中，设成0.0.0.0让任何人都可以访问。线上服务不要这样设置，要设成具体的 IP。

## netstat -plntu

# 二、基本概念
2.1 Node 与 Cluster

Elastic 本质上是一个分布式数据库，允许多台服务器协同工作，每台服务器可以运行多个 Elastic 实例。
单个 Elastic 实例称为一个节点（node）。一组节点构成一个集群（cluster）。

2.2 Index

Elastic 会索引所有字段，经过处理后写入一个反向索引（Inverted Index）。查找数据的时候，直接查找该索引。

所以，Elastic 数据管理的顶层单位就叫做 Index（索引）。它是单个数据库的同义词。每个 Index （即数据库）的名字必须是小写。

下面的命令可以查看当前节点的所有 Index。
$ curl -X GET 'http://localhost:9200/_cat/indices?v'

2.3 Document

Index 里面单条的记录称为 Document（文档）。许多条 Document 构成了一个 Index。

Document 使用 JSON 格式表示，下面是一个例子。
{
  "user": "张三",
  "title": "工程师",
  "desc": "数据库管理"
}

同一个 Index 里面的 Document，不要求有相同的结构（scheme），但是最好保持相同，这样有利于提高搜索效率。

2.4 Type

Document 可以分组，比如weather这个 Index 里面，可以按城市分组（北京和上海），也可以按气候分组（晴天和雨天）。这种分组就叫做 Type，它是虚拟的逻辑分组，用来过滤 Document。

不同的 Type 应该有相似的结构（schema），举例来说，id字段不能在这个组是字符串，在另一个组是数值。这是与关系型数据库的表的一个区别。性质完全不同的数据（比如products和logs）应该存成两个 Index，而不是一个 Index 里面的两个 Type（虽然可以做到）。

下面的命令可以列出每个 Index 所包含的 Type。
$ curl 'localhost:9200/_mapping?pretty=true'
根据规划，Elastic 6.x 版只允许每个 Index 包含一个 Type，7.x 版将会彻底移除 Type。

# 三、新建和删除 Index

新建 Index，可以直接向 Elastic 服务器发出 PUT 请求。下面的例子是新建一个名叫weather的 Index。

$ curl -X PUT 'localhost:9200/weather'

服务器返回一个 JSON 对象，里面的acknowledged字段表示操作成功。

{
  "acknowledged":true,
  "shards_acknowledged":true
}

然后，我们发出 DELETE 请求，删除这个 Index。
$ curl -X DELETE 'localhost:9200/weather'

# 四、中文分词设置
系统默认分词器：
standard/simple/Whitespace/Stop/keyword/pattern/snowball
Elasticsearch默认提供的分词器，会把每个汉字分开，而不是我们想要的根据关键词来分词。例如：
文本使用URL编码就可以避免乱码
URI.encode("我是中国人")
=> "%E6%88%91%E6%98%AF%E4%B8%AD%E5%9B%BD%E4%BA%BA"

curl -X GET 'http://localhost:9200/_cat/indices?v'

elasticsearch-2.4.6 => 
curl -X DELETE 'localhost:9200/userinfo?pretty=true'
curl -X PUT 'localhost:9200/userinfo?pretty=true'
curl -XPOST  "http://localhost:9200/userinfo/_analyze?analyzer=standard&pretty=true&text=%E6%88%91%E6%98%AF%E4%B8%AD%E5%9B%BD%E4%BA%BA"

## https://www.elastic.co/guide/en/elasticsearch/reference/6.x/analyzer.html
elasticsearch-6.3.0 => 
curl -X PUT "localhost:9200/userinfo?pretty=true" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "_doc": {
      "properties": {
        "text": { 
          "type": "text",
          "fields": {
            "english": { 
              "type":     "text",
              "analyzer": "english"
            }
          }
        }
      }
    }
  }
}
'
curl -X GET "localhost:9200/userinfo/_analyze?pretty=true" -H 'Content-Type: application/json' -d'
{
  "field": "text",
  "text": "The quick Brown Foxes."
}
'

curl -X GET "localhost:9200/userinfo/_analyze?pretty=true" -H 'Content-Type: application/json' -d'
{
  "field": "text.english",
  "text": "The quick Brown Foxes."
}
'

curl -X PUT "localhost:9200/chineseinfo?pretty=true" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "_doc": {
      "properties": {
        "text": { 
          "type": "text",
          "fields": {
            "chinese": { 
              "type":     "text",
              "analyzer": "standard"
            }
          }
        }
      }
    }
  }
}
'

curl -X GET "localhost:9200/chineseinfo/_analyze?pretty=true" -H 'Content-Type: application/json' -d'
{
  "field": "text",
  "text": "发展中国家"
}
'

curl -X DELETE 'localhost:9200/my_index?pretty=true'
curl -X PUT "localhost:9200/my_index?pretty=true" -H 'Content-Type: application/json' -d'
{
   "settings":{
      "analysis":{
         "analyzer":{
            "my_analyzer":{ 
               "type":"custom",
               "tokenizer":"standard",
               "filter":[
                  "lowercase"
               ]
            },
            "my_stop_analyzer":{ 
               "type":"custom",
               "tokenizer":"standard",
               "filter":[
                  "lowercase",
                  "english_stop"
               ]
            }
         },
         "filter":{
            "english_stop":{
               "type":"stop",
               "stopwords":"_english_"
            }
         }
      }
   },
   "mappings":{
      "_doc":{
         "properties":{
            "title": {
               "type":"text",
               "analyzer":"my_analyzer", 
               "search_analyzer":"my_stop_analyzer", 
               "search_quote_analyzer":"my_analyzer" 
            }
         }
      }
   }
}
'

curl -X PUT "localhost:9200/my_index/_doc/1?pretty=true" -H 'Content-Type: application/json' -d'
{
   "title":"The Quick Brown Fox"
}
'

curl -X PUT "localhost:9200/my_index/_doc/2?pretty=true" -H 'Content-Type: application/json' -d'
{
   "title":"A Quick Brown Fox"
}
'

curl -X GET "localhost:9200/my_index/_search?pretty=true" -H 'Content-Type: application/json' -d'
{
   "query":{
      "query_string":{
         "query":"\"the quick brown fox\"" 
      }
   }
}
'


首先，安装中文分词插件。这里使用的是 ik，也可以考虑其他插件（比如 smartcn）。
$ bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v6.3.0/elasticsearch-analysis-ik-6.3.0.zip
上面代码安装的是6.3.0版的插件，与Elastic6.3.0 配合使用。接着，重新启动 Elastic，就会自动加载这个新安装的插件。


curl -X GET 'http://localhost:9200/_cat/indices?v'
curl -X DELETE 'localhost:9200/ikinfo?pretty=true'
curl -X PUT "localhost:9200/ikinfo?pretty=true" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "_doc": {
      "properties": {
        "tags": { 
          "type": "text",
          "fields": {
            "chinese": { 
              "type":     "text",
              "analyzer": "ik_smart",
              "search_analyzer": "ik_smart"
            }
          }
        }
      }
    }
  }
}
'

curl -X GET "localhost:9200/ikinfo/_analyze?pretty=true" -H 'Content-Type: application/json' -d'
{
  "field": "text",
  "text": "联想是全球最大的笔记本厂商"
}
'

curl -X GET "localhost:9200/ikinfo/_analyze?pretty" -H 'Content-Type: application/json' -d'
 {"analyzer": "ik_smart", "text":"联想是全球最大的笔记本厂商" }'

curl -X GET "localhost:9200/ikinfo/_analyze?pretty" -H 'Content-Type: application/json' -d'
 {"analyzer": "ik_smart", "text":"安徽省长江流域" }'

curl -X GET "localhost:9200/ikinfo/_analyze?pretty" -H 'Content-Type: application/json' -d'
 {"analyzer": "ik_max_word", "text":"安徽省长江流域" }'


自定义一个analyzer，新的analyzer名称设置为ik，tokenizer的type设置为ik_max_word即可。
curl -X GET 'http://localhost:9200/_cat/indices?v'
curl -X DELETE 'localhost:9200/ikinfo?pretty'
curl -X PUT "localhost:9200/ikinfo?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "analysis": {
      "analyzer": {
        "ik": {
          "type": "custom",
          "tokenizer": "ik_max_word"
        }
      }
    }
  }
}
'

curl -X GET "localhost:9200/ikinfo/_analyze?pretty" -H 'Content-Type: application/json' -d'
 {"analyzer": "ik", "text":"安徽省长江流域" }'

curl -X GET "localhost:9200/ikinfo/_analyze?pretty" -H 'Content-Type: application/json' -d'
 {"analyzer": "ik", "text":"Elasticsearch provides a powerful, RESTful HTTP interface for indexing and querying data, built on top of the Apache Lucene library." }'

curl -X GET "localhost:9200/ikinfo/_analyze?pretty" -H 'Content-Type: application/json' -d'
 {"analyzer": "ik", "text":"没有那个quality" }'


然后，新建一个 Index，指定需要分词的字段。这一步根据数据结构而异，下面的命令只针对本文。基本上，凡是需要搜索的中文字段，都要单独设置一下。
$ curl -X PUT 'localhost:9200/accounts?pretty=true' -H 'Content-Type: application/json' -d '
{
  "mappings": {
    "person": {
      "properties": {
        "user": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        },
        "title": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        },
        "desc": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        }
      }
    }
  }
}'

curl -X GET 'http://localhost:9200/_cat/indices?v'
上面代码中，首先新建一个名称为accounts的 Index，里面有一个名称为person的 Type。person有三个字段。
user
title
desc
这三个字段都是中文，而且类型都是文本（text），所以需要指定中文分词器，不能使用默认的英文分词器。
Elastic 的分词器称为 analyzer。我们对每个字段指定分词器。
"user": {
  "type": "text",
  "analyzer": "ik_max_word",
  "search_analyzer": "ik_max_word"
}
上面代码中，analyzer是字段文本的分词器，search_analyzer是搜索词的分词器。ik_max_word分词器是插件ik提供的，可以对文本进行最大数量的分词。

# 五、数据操作
5.1 新增记录

向指定的 /Index/Type 发送 PUT 请求，就可以在 Index 里面新增一条记录。比如，向/accounts/person发送请求，就可以新增一条人员记录。


$ curl -X PUT 'localhost:9200/accounts/person/1?pretty=true' -H 'Content-Type: application/json' -d '
{
  "user": "张三",
  "title": "工程师",
  "desc": "数据库管理"
}' 

服务器返回的 JSON 对象，会给出 Index、Type、Id、Version 等信息。
{
  "_index" : "accounts",
  "_type" : "person",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}


如果你仔细看，会发现请求路径是/accounts/person/1，最后的1是该条记录的 Id。它不一定是数字，任意字符串（比如abc）都可以。

新增记录的时候，也可以不指定 Id，这时要改成 POST 请求。

$ curl -X POST 'localhost:9200/accounts/person?pretty=true' -H 'Content-Type: application/json' -d '
{
  "user": "李四",
  "title": "工程师",
  "desc": "系统管理"
}'

上面代码中，向/accounts/person发出一个 POST 请求，添加一个记录。这时，服务器返回的 JSON 对象里面，_id字段就是一个随机字符串。

{
  "_index" : "accounts",
  "_type" : "person",
  "_id" : "kznn-mUB8627_1LTn7j6",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}

注意，如果没有先创建Index（这个例子是accounts），直接执行上面的命令，Elastic 也不会报错，而是直接生成指定的Index。所以，打字的时候要小心，不要写错Index的名称。

5.2 查看记录
向/Index/Type/Id发出 GET 请求，就可以查看这条记录。
$ curl 'localhost:9200/accounts/person/1?pretty=true'

上面代码请求查看/accounts/person/1这条记录，URL 的参数pretty=true表示以易读的格式返回。
返回的数据中，found字段表示查询成功，_source字段返回原始记录。
{
  "_index" : "accounts",
  "_type" : "person",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "_source" : {
    "user" : "张三",
    "title" : "工程师",
    "desc" : "数据库管理"
  }
}


如果Id不正确，就查不到数据，status就是404。
$ curl 'localhost:9200/weather/beijing/abc?pretty=true'

{
  "error" : {
    "root_cause" : [
      {
        "type" : "index_not_found_exception",
        "reason" : "no such index",
        "resource.type" : "index_expression",
        "resource.id" : "weather",
        "index_uuid" : "_na_",
        "index" : "weather"
      }
    ],
    "type" : "index_not_found_exception",
    "reason" : "no such index",
    "resource.type" : "index_expression",
    "resource.id" : "weather",
    "index_uuid" : "_na_",
    "index" : "weather"
  },
  "status" : 404
}

curl 'localhost:9200/accounts/person/2?pretty=true'
{
  "_index" : "accounts",
  "_type" : "person",
  "_id" : "2",
  "found" : false
}


5.3 删除记录

删除记录就是发出 DELETE 请求。
$ curl -X DELETE 'localhost:9200/accounts/person/1?pretty=true'
这里先不要删除这条记录，后面还要用到。


5.4 更新记录

更新记录就是使用 PUT 请求，重新发送一次数据。


$ curl -X PUT 'localhost:9200/accounts/person/1?pretty=true' -H 'Content-Type: application/json' -d '
{
    "user" : "张三",
    "title" : "工程师",
    "desc" : "数据库管理，软件开发"
}' 

{
  "_index" : "accounts",
  "_type" : "person",
  "_id" : "1",
  "_version" : 2,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 5,
  "_primary_term" : 1
}

上面代码中，我们将原始数据从"数据库管理"改成"数据库管理，软件开发"。 返回结果里面，有几个字段发生了变化。
"_version" : 2,
"result" : "updated"

可以看到，记录的 Id 没变，但是版本（version）从1变成2，操作类型（result）从created变成updated，因为这次不是新建记录。

# 六、数据查询
6.1 返回所有记录

使用 GET 方法，直接请求/Index/Type/_search，就会返回所有记录。


$ curl 'localhost:9200/accounts/person/_search?pretty=true'

{
  "took" : 104,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "accounts",
        "_type" : "person",
        "_id" : "kznn-mUB8627_1LTn7j6",
        "_score" : 1.0,
        "_source" : {
          "user" : "李四",
          "title" : "工程师",
          "desc" : "系统管理"
        }
      },
      {
        "_index" : "accounts",
        "_type" : "person",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "user" : "张三",
          "title" : "工程师",
          "desc" : "数据库管理，软件开发"
        }
      }
    ]
  }
}

上面代码中，返回结果的 took字段表示该操作的耗时（单位为毫秒），timed_out字段表示是否超时，hits字段表示命中的记录，里面子字段的含义如下。

total：返回记录数，本例是2条。
max_score：最高的匹配程度，本例是1.0。
hits：返回的记录组成的数组。

返回的记录中，每条记录都有一个_score字段，表示匹配的程度，默认是按照这个字段降序排列。


6.2 全文搜索

Elastic 的查询非常特别，使用自己的查询语法，要求 GET 请求带有数据体。
$ curl 'localhost:9200/accounts/person/_search?pretty=true' -H 'Content-Type: application/json'  -d '
{
  "query":{"match":{"desc":"软件"}}
}'

上面代码使用 Match 查询，指定的匹配条件是desc字段里面包含"软件"这个词。返回结果如下。
{
  "took" : 20,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "accounts",
        "_type" : "person",
        "_id" : "1",
        "_score" : 0.2876821,
        "_source" : {
          "user" : "张三",
          "title" : "工程师",
          "desc" : "数据库管理，软件开发"
        }
      }
    ]
  }
}

Elastic默认一次返回10条结果，可以通过size字段改变这个设置。

$ curl 'localhost:9200/accounts/person/_search?pretty=true' -H 'Content-Type: application/json' -d '
{
  "query":{"match":{"desc":"管理"}},
  "size":1
}'

$ curl 'localhost:9200/accounts/person/_search?pretty=true' -H 'Content-Type: application/json' -d '
{
  "query":{"match":{"desc":"管理"}},
  "size":2
}'


还可以通过from字段，指定位移。
$ curl 'localhost:9200/accounts/person/_search?pretty=true' -H 'Content-Type: application/json' -d '
{
  "query" : { "match" : { "desc" : "管理" }},
  "from": 1,
  "size": 1
}'
上面代码指定，从位置1开始（默认是从位置0开始），只返回一条结果。


6.3 逻辑运算
如果有多个搜索关键字， Elastic认为它们是or关系。
$ curl 'localhost:9200/accounts/person/_search?pretty=true' -H 'Content-Type: application/json' -d '
{
  "query" : { "match" : { "desc" : "软件 系统" }}
}'

上面代码搜索的是'软件' or '系统'

如果要执行多个关键词的and搜索，必须使用布尔查询。
$ curl 'localhost:9200/accounts/person/_search?pretty=true' -H 'Content-Type: application/json' -d '
{
  "query": {
    "bool": {
      "must": [
        { "match": { "desc": "软件" } },
        { "match": { "desc": "系统" } }
      ]
    }
  }
}'

{
  "took" : 23,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 0,
    "max_score" : null,
    "hits" : [ ]
  }
}


google => elasticsearch自动补全

google => How do I set the default analyzer for elastic search with tire?

整合 ElasticSearch 到现有 Rails 项目
gem 'elasticsearch-model' 
gem 'elasticsearch-rails'

注意：es-model自带了分页插件，如果你在gemfile中有分页，如will_paginate 或者 kaminari，要把他们放到es-model和es-rails的前面。

中文分词插件
elasticsearch-analysis-mmseg
https://github.com/medcl/elasticsearch-analysis-mmseg 基于 http://code.google.com/p/mmseg4j/

elasticsearch-analysis-jieba
https://github.com/huaban/elasticsearch-analysis-jieba

elasticsearch-analysis-ansj
https://github.com/4onni/elasticsearch-analysis-ansj

elasticsearch-analysis-ik
https://github.com/medcl/elasticsearch-analysis-ik









