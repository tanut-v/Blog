# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
(($) ->
  
  #BlocksIt default options
  blocksOptions =
    numOfCol: 5
    offsetX: 5
    offsetY: 5
    blockElement: "div"

  
  #dynamic variable
  container = undefined
  colwidth = undefined
  blockarr = []
  
  #ie indexOf fix
  unless Array::indexOf
    Array::indexOf = (elt) -> #, from
      len = @length >>> 0
      from = Number(arguments_[1]) or 0
      from = (if (from < 0) then Math.ceil(from) else Math.floor(from))
      from += len  if from < 0
      while from < len
        return from  if from of this and this[from] is elt
        from++
      -1
  
  #create empty blockarr
  createEmptyBlockarr = ->
    
    #empty blockarr
    blockarr = []
    i = 0

    while i < blocksOptions.numOfCol
      blockarrPush "empty-" + i, i, 0, 1, -blocksOptions.offsetY
      i++

  
  #add new block to blockarr
  blockarrPush = (id, x, y, width, height) ->
    
    #define block object based on block width
    i = 0

    while i < width
      block = new Object()
      block.x = x + i
      block.size = width
      block.endY = y + height + blocksOptions.offsetY * 2
      blockarr.push block
      i++

  
  #remove block from blockarr
  blockarrRemove = (x, num) ->
    i = 0

    while i < num
      
      #remove block beside
      index = getBlockIndex(x + i, "x")
      blockarr.splice index, 1
      i++

  
  #retrieve block index based on block's x position
  getBlockIndex = (value, type) ->
    i = 0

    while i < blockarr.length
      obj = blockarr[i]
      if type is "x" and obj.x is value
        return i
      else return i  if type is "endY" and obj.endY is value
      i++

  
  #get height from blockarr range based on block.x and size
  #retrun min and max height
  getHeightArr = (x, size) ->
    temparr = []
    i = 0

    while i < size
      temparr.push blockarr[getBlockIndex(x + i, "x")].endY
      i++
    min = Math.min.apply(Math, temparr)
    max = Math.max.apply(Math, temparr)
    [min, max, temparr.indexOf(min)]

  
  #get block x and y position
  getBlockPostion = (size) ->
    
    #if block width is not default 1
    #extra algorithm check
    if size > 1
      
      #prevent extra loop
      arrlimit = blockarr.length - size
      
      #define temp variable
      defined = false
      tempHeight = undefined
      tempIndex = undefined
      i = 0

      while i < blockarr.length
        obj = blockarr[i]
        x = obj.x
        
        #check for block within range only
        if x >= 0 and x <= arrlimit
          heightarr = getHeightArr(x, size)
          
          #get shortest group blocks
          unless defined
            defined = true
            tempHeight = heightarr
            tempIndex = x
          else
            if heightarr[1] < tempHeight[1]
              tempHeight = heightarr
              tempIndex = x
        i++
      [tempIndex, tempHeight[1]]
    else #simple check for block with width 1
      tempHeight = getHeightArr(0, blockarr.length)
      [tempHeight[2], tempHeight[0]]

  
  #set block position
  setPosition = (obj, index) ->
    
    #check block size
    if not obj.data("size") or obj.data("size") < 0
      obj.data "size", 1
    else obj.data "size", blocksOptions.numOfCol  if obj.data("size") > blocksOptions.numOfCol
    
    #define block data
    pos = getBlockPostion(obj.data("size"))
    blockWidth = colwidth * obj.data("size") - (obj.outerWidth() - obj.width())
    
    #update style first before get object height
    obj.css
      width: blockWidth - blocksOptions.offsetX * 2
      left: pos[0] * colwidth
      top: pos[1]
      position: "absolute"

    blockHeight = obj.outerHeight()
    
    #modify blockarr for new block
    blockarrRemove pos[0], obj.data("size")
    blockarrPush obj.attr("id"), pos[0], pos[1], obj.data("size"), blockHeight

  $.fn.BlocksIt = (options) ->
    
    #BlocksIt options
    $.extend blocksOptions, options  if options and typeof options is "object"
    container = $(this)
    colwidth = container.width() / blocksOptions.numOfCol
    
    #create empty blockarr
    createEmptyBlockarr()
    container.children(blocksOptions.blockElement).each (e) ->
      setPosition $(this), e

    
    #set final height of container
    heightarr = getHeightArr(0, blockarr.length)
    container.height heightarr[1] + blocksOptions.offsetY
    this
) jQuery