#!/bin/bash
# platform = multi_platform_rhel,multi_platform_fedora,multi_platform_ol,multi_platform_sle

# Check rsyslog.conf with root user log from rules and
# non root user log from $IncludeConfig fails.

source $SHARED/rsyslog_log_utils.sh

{{% if ATTRIBUTE == "owner" %}}
ADDCOMMAND="useradd"
CHATTR="chown"
{{% else %}}
ADDCOMMAND="groupadd"
CHATTR="chgrp"
{{% endif %}}

USER_TEST=testssg
$ADDCOMMAND $USER_TEST

USER_ROOT=root

# setup test data
create_rsyslog_test_logs 2

# setup test log files ownership
$CHATTR $USER_ROOT ${RSYSLOG_TEST_LOGS[0]}
$CHATTR $USER_TEST ${RSYSLOG_TEST_LOGS[1]}

# create test configuration file
test_conf=${RSYSLOG_TEST_DIR}/test1.conf
cat << EOF > ${test_conf}
# rsyslog configuration file

#### RULES ####

*.*     ${RSYSLOG_TEST_LOGS[1]}
EOF

# create rsyslog.conf configuration file
cat << EOF > $RSYSLOG_CONF
# rsyslog configuration file

#### RULES ####

*.*      ${RSYSLOG_TEST_LOGS[0]}

#### MODULES ####

\$IncludeConfig ${test_conf}
EOF
