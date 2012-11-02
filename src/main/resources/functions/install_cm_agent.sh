#
# Licensed to Cloudera, Inc. under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# Cloudera, Inc. licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -x

function install_cm_agent() {
  if which dpkg &> /dev/null; then
    retry_apy_get -y install cloudera-manager-agent cloudera-manager-daemons bigtop-utils bigtop-jsvc bigtop-tomcat hadoop hadoop-hdfs hadoop-httpfs hadoop-mapreduce hadoop-yarn hadoop-client hadoop-0.20-mapreduce hue-plugins hbase hive oozie oozie-client pig zookeeper hue
    if ls /etc/init.d/hadoop-* &> /dev/null; then
      for SERVICE_SCRIPT in /etc/init.d/hadoop-*; do
        service $(basename $SERVICE_SCRIPT) stop
        update-rc.d -f $(basename $SERVICE_SCRIPT) remove
      done
    fi
    service hue stop
    update-rc.d -f hue remove
    service oozie stop
    update-rc.d -f oozie remove
  elif which rpm &> /dev/null; then
    retry_yum install -y cloudera-manager-agent cloudera-manager-daemons bigtop-utils bigtop-jsvc bigtop-tomcat hadoop hadoop-hdfs hadoop-httpfs hadoop-mapreduce hadoop-yarn hadoop-client hadoop-0.20-mapreduce hue-plugins hbase hive oozie oozie-client pig zookeeper impala impala-shell hue
    if ls /etc/init.d/hadoop-* &> /dev/null; then
      for SERVICE_SCRIPT in /etc/init.d/hadoop-*; do
        service $(basename $SERVICE_SCRIPT) stop
        chkconfig $(basename $SERVICE_SCRIPT) off
      done
    fi
    service hue stop
    chkconfig hue off
    service oozie stop
    chkconfig oozie off    
  fi
}
