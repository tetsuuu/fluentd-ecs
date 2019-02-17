#!/bin/bash
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=${clister_name}
ECS_AVAILABLE_LOGGING_DRIVERS=[¥"json-file¥",¥"syslog¥",¥"fluentd¥",¥"awslog¥"]
EOF