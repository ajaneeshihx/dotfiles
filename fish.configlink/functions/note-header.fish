function note-header
    set -g CURRENT_WEATHER (curl -s "https://wttr.in/?format=1")
    set -g JOURNAL_HEADER "[Yesterday]($YESTERDAY_NOTE.md) | [Home](home.md) | [Tomorrow]($TOMORROW_NOTE.md)\n\n$LONG_DATE\n$CURRENT_WEATHER\n#journal\n\n---\n\n\n# Journal\n\n"
end
