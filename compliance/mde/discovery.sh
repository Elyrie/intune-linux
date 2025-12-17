#!/bin/bash

mkdir -p $HOME/.local/share/intune
log="$HOME/.local/share/intune/compliance.log"
echo "$(date) | Starting compliance script" >>$log

health=$(mdatp health --field healthy)
rtp=$(mdatp health --field real_time_protection_enabled)
echo "$(date) |   + MDE Health: [$health]" >>$log
echo "$(date) |   + MDE RTP enabled: [$rtp]" >>$log

echo -n "{"
echo -n "\"health\": $health"
echo -n ","
echo -n "\"real_time_protection_enabled\": $rtp"
echo "}"

echo "$(date) | Ending compliance script" >>$log
