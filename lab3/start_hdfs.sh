#!/bin/bash
#apt-get install -y openssh-server
#/etc/init.d/ssh start

HADOOP=hadoop-3.3.4
HADOOP_HOME=/usr/local/$HADOOP

cat > $HADOOP_HOME/etc/hadoop/core-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
    <property>
      <name>hadoop.tmp.dir</name>
      <value>/tmp</value>
      <description>A base for other temporary directories.</description>
    </property>
</configuration>
EOF
cat > $HADOOP_HOME/etc/hadoop/hdfs-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
      <name>hadoop.tmp.dir</name>
      <value>/tmp</value>
      <description>A base for other temporary directories.</description>
    </property>
</configuration>
EOF
cat > $HADOOP_HOME/etc/hadoop/mapred-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property> 
    <name>mapreduce.framework.name</name> 
    <value>yarn</value> 
  </property>
</configuration>
EOF
cat > $HADOOP_HOME/etc/hadoop/yarn-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <!-- Site specific YARN configuration properties -->
    <property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>128</value>
        <description>Minimum limit of memory to allocate to each container request at the Resource Manager.</description>
    </property>
    <property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>2048</value>
        <description>Maximum limit of memory to allocate to each container request at the Resource Manager.</description>
    </property>
    <property>
        <name>yarn.scheduler.minimum-allocation-vcores</name>
        <value>1</value>
        <description>The minimum allocation for every container request at the RM, in terms of virtual CPU cores. Requests lower than this won't take effect, and the specified value will get allocated the minimum.</description>
    </property>
    <property>
        <name>yarn.scheduler.maximum-allocation-vcores</name>
        <value>2</value>
        <description>The maximum allocation for every container request at the RM, in terms of virtual CPU cores. Requests higher than this won't take effect, and will get capped to this value.</description>
    </property>
    <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>4096</value>
        <description>Physical memory, in MB, to be made available to running containers</description>
    </property>
</configuration>
EOF
$HADOOP_HOME/bin/hdfs namenode -format

export HDFS_NAMENODE_USER="root"
export HDFS_DATANODE_USER="root"
export HDFS_SECONDARYNAMENODE_USER="root"
export YARN_RESOURCEMANAGER_USER="root"
export YARN_NODEMANAGER_USER="root"

cat > $HADOOP_HOME/sbin/start-dfs.sh << EOF
#!/usr/bin/env bash

HADOOP=hadoop-3.3.4
HADOOP_HOME=/usr/local/$HADOOP
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

echo "starting dfs daemons"

hadoop-daemon.sh --config $HADOOP_HOME/etc/hadoop/ start namenode
hadoop-daemon.sh --config $HADOOP_HOME/etc/hadoop/ start secondarynamenode
hadoop-daemon.sh --config $HADOOP_HOME/etc/hadoop/ start datanode

EOF

cat > $HADOOP_HOME/sbin/start-yarn.sh << EOF
#!/usr/bin/env bash

HADOOP=hadoop-3.3.4
HADOOP_HOME=/usr/local/$HADOOP
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

echo "starting yarn daemons"

yarn-daemon.sh --config $HADOOP_HOME/etc/hadoop/ start resourcemanager
yarn-daemon.sh --config $HADOOP_HOME/etc/hadoop/ start nodemanager
EOF


$HADOOP_HOME/sbin/start-dfs.sh
#$HADOOP_HOME/sbin/start-yarn.sh
hadoop fs -mkdir -p root
