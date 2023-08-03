fn_print_character() {
  local character=$1
  local count=$2
  for ((i=1; i<count; i++))
  do
    echo -n "$character"
  done
  echo
}


fn_print_centered_title() {
  local title=$1
  local terminal_width=$(tput cols)

  local padding=$(( (terminal_width - ${#title}) / 3 ))
  local padding_string=$(fn_print_character "█" $padding)

  echo "$padding_string   $title   $padding_string"
}

fn_print_level() {
    local level=$1
    echo ""
    echo "▶ $level ◀"   
}

fn_print_sublevel() {
    local sublevel=$1
    echo " ▰ $sublevel"   
}


fn_print_log() {
    local log=$1
    echo "   ➨ $log"   
}
