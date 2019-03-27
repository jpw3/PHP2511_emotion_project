function touchHandler(event)
{
    var touches = event.changedTouches,
        first = touches[0],
        type = event.type;
    var simulatedEvent = document.createEvent("TouchEvent");
    simulatedEvent.initMouseEvent(type, true, true, window, 1, 
                              first.screenX, first.screenY, 
                              first.clientX, first.clientY, false, 
                              false, false, false, 0/*left*/, null);

   first.target.dispatchEvent(simulatedEvent);
   event.preventDefault();
};

function init() 
{
    document.addEventListener("touchstart", touchHandler, true);
    document.addEventListener("touchmove", touchHandler, true);
    document.addEventListener("touchend", touchHandler, true);
    document.addEventListener("touchcancel", touchHandler, true);    
};