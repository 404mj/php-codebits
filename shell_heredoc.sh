#!/bin/bash
cat > sh_heredoc.log << EOF
echo "this shell file size is:"
$(du -sh ./shell_heredoc.sh | awk '{print $1}')
EOF

