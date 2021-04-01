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

refreshFrequency: 10000000

render: () ->
  """
  <link rel="stylesheet" href="./polybar/assets/font-awesome/css/all.css" />
  <div class="spaces">
    <div>1: Default</div>
  </div>
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
      $(".spaces").append(
         """<div class="workspace" id="#{index}">#{index}:#{value}</div>"""
      )
      #$("<div>").prop("id", index).text("#{index}: #{value}").appendTo(".spaces")
  )

handleActiveSpace: (id) ->
  $("##{id}").addClass("active")

style: """
  .spaces
    display: flex
    align-items: stretch
    height: 24px

  .workspace
    display: flex
    color: #{colors.orange}
    align-items: center
    justify-content: center
    padding: 8px 8px

  .active
    color: #{colors.elegant}
    background: #{colors.silver}
    border: 1px solid #{colors.elegant}

  top: 10px
  left: 24px
  font-family: 'Monaco'
  font-size: 14px
  font-smoothing: antialiasing
  z-index: 0
"""
