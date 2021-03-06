# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME.  All others are
# optional.  When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# Set JAVA_HOME
export JAVA_HOME="/usr/java/latest"

# Configure SSH options
export HADOOP_SSH_OPTS="-o StrictHostKeyChecking=no"

# Configure Hadoop logging location
export HADOOP_LOG_DIR=/mnt/hadoop/logs

# Pid files go here
#export HADOOP_PID_DIR=/var/run/hadoop

{% if 'cdh4.hadoop.namenode' in grains['roles'] %}
export HADOOP_HEAPSIZE=3000
HADOOP_JOBTRACKER_OPTS="-XX:+HeapDumpOnOutOfMemoryError ${HADOOP_JOBTRACKER_OPTS}"
{% endif %}
