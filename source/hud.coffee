class HudX

  lifetime: 5e3
  map: {}
  mapLast: {}

  constructor: ->
    client.on 'tick', @update
    client.on 'pause', @hideAll

  hide: (n) ->
    @mapLast[n] = ''
    id = n + 1
    `ToolTip,, 0, 0, % id`

  hideAll: -> for n in [1, 2, 3, 4, 5]
    @hide n

  makePosition: (n) ->

    if client.isFullScreen
      left = client.vw 80
    else left = client.width

    return [
      left
      client.vh 22 + 9 * (n - 1)
    ]

  render: (n, msg) -> @map[n] = [
    $.now() + @lifetime
    msg
  ]

  reset: ->
    @map = {}
    @mapLast = {}
    @hideAll()

  update: ->

    unless $.includes ['fishing', 'normal'], Scene.name then return

    now = $.now()

    for n in [1, 2, 3, 4, 5]

      [time, msg] = @map[n]

      unless msg
        @hide n
        continue

      unless now < time
        @hide n
        continue

      if msg == @mapLast[n]
        continue
      @mapLast[n] = msg

      [x, y] = @makePosition n
      id = n + 1
      `ToolTip, % msg, % x, % y, % id`

    if Config.data.isDebug
      cost = $.now() - now
      if cost >= 20 then console.log "hud/cost: #{$.now() - now} ms"

# execute
Hud = new HudX()