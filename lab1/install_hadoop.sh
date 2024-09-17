#!/bin/bash

HADOOP=hadoop-3.3.6
wget -q https://downloads.apache.org/hadoop/common/$HADOOP/$HADOOP.tar.gz
tar -xzf $HADOOP.tar.gz
mv $HADOOP/ /usr/local/
echo "export JAVA_HOME="`readlink -f /usr/bin/java | sed "s:bin/java::"` >> /usr/local/$HADOOP/etc/hadoop/hadoop-env.sh

echo "#!/bin/bash" > /usr/local/bin/hadoop
echo "exec /usr/local/$HADOOP/bin/hadoop \$*" >> /usr/local/bin/hadoop
chmod a+x /usr/local/bin/hadoop

