commands =
  active : "/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index'"
  list   : "/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq -r '.[].label'"
  monitor: ""

colors =
  acqua:   "#00d787"
  wine:    "#72003e"
  orange:  "#ff8700"
  silver:  "#e4e4e4"
  elegant: "#1C2331"
  magenta: "#af005f"
  cyan:    "#00afd7"

command: "echo " +
          "$(#{commands.active}):::" +
          "$(#{commands.list}):::"

refreshFrequency: 10000

render: () ->
  """
  <link rel="stylesheet" href="./polybar/assets/font-awesome/css/font-awesome.min.css" />

  <ul class="spaces">
    <li>1: Default</li>
  </ul>
  """

update: (output) ->
  output = output.split( /:::/g )

  active = output[0]
  list   = output[1]

  @handleSpaces(list)
  @handleActiveSpace(Number (active))

handleSpaces: (list) ->
  $(".spaces").empty()
  list = " " + list
  list = list.split(" ")

  $.each(list, (index, value) ->
    if (index > 0)
      $("<li>").prop("id", index).text("#{index}: #{value}").appendTo(".spaces")
  )

handleActiveSpace: (id) ->
  $("##{id}").addClass("active")

style: """
  .active
    color: #{colors.elegant}
    background: #{colors.silver}
    border: 1px solid #{colors.silver}

  .spaces
    display: flex

  .workspace
    color: #{colors.orange}
    background: #{colors.elegant}
    border: 1px solid #{colors.elegant}

  .spaces
    padding-right: 8px
    padding-left: 8px

  ul
    list-style: none
    margin: 0 0 0 8px
    padding: 0

  li
    display: inline
    padding: 2px 8px
    color: #{colors.orange}
    background: #{colors.elegant}
    border: 1px solid #{colors.elegant}

  top: 11px
  left: 10px
  font-family: 'PragmataPro'
  font-size: 14px
  font-smoothing: antialiasing
  z-index: 0
"""