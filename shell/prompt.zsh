# Local Zsh prompt

# Preserve the existing prompt in SSH sessions
if [[ -z ${SSH_CONNECTION:-} && -z ${SSH_TTY:-} ]]; then
    PROMPT='%B%~%b %# '
fi
