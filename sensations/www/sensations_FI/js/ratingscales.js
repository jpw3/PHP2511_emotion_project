/******************************************************************************************
* Visual rating scales
* v1.6
*
* http://timo.gnambs.at
*
* Copyright (c) 2003 Timo Gnambs. All rights reserved.
* Created 24/06/2003 by Timo Gnambs <timo@gnambs.at>
* Last modified 06/12/2003
*
*
* Requires wz_dragdrop.js created by Walter Zorn
* available at http://www.walterzorn.de
*
* This script has been tested with wz_dragdrop.js v4.51
*
*
*
* Instructions:
*
*  I)   Include wz_dragdrop.js and ratingscale.js right AFTER the
*       opening <body>-Tag:
*       <script type="text/javascript" src="wz_dragdrop.js"></script>
*       <script type="text/javascript" src="ratingscales.js"></script>
*
*  II)  Include the following line right BEFORE the closing </body>-Tag:
*       <script type="text/javascript">scales.init();</script>
*
*  III) Create your scales by calling 'scales.scale()'.
*       There are six options:
*       1) name of your variable (= hidden form element)           - REQUIRED
*       2) mode of your scale ('click', 'slide' or 'button')       - OPTIONAL
*       3) number of classes used                                  - OPTIONAL
*       4) image source, width and height of the scale             - OPTIONAL
*          NOTE: reference as String: 'scale.gif'  
*                (sets source and uses default width & height)
*          OR:   reference as Array: ['scale.gif', 100, 12]
*                (sets source, width & height)
*       5) image source of the cross                               - OPTIONAL
*          NOTE: reference as String: 'cross.gif'  
*                (sets source and uses default width & height)
*          OR:   reference as Array: ['cross.gif', 10, 10]
*                (sets source, width & height)
*       6) labels as 2-dimensional array                           - OPTIONAL
*
*       e.g.: scales.scale('var1')
*             creates a scale with the default settings and saves the result to the
*             hidden form field var1
*       e.g.: scales.scale('var1', '', 9)
*             same as above excecpt with nine classes
*       e.g.: scales.scale('var1', 'click', 5, ['coolscale.gif', 250], 'evencoolercross.gif')
*             creates a click-scale with five classes using coolscale.gif (250px width) as
*             scale image and evencoolercross.gif as cross image.
*       e.g.: scales.scale('var1', 'button', '', 'coolscale.gif', '', ['agree strongly', 'disagree strongly'])
*             creates a button-scale with no classes using coolscale.gif (with default width and height)
*             as scale image, the default cross and the two labels 'agree strongly' vs 'disagree strongly'.
*
* IV)  Modify the default settings (optional):
*      - scales.scale_src:     image source of scale
*      - scales.scale_width:   width of scale image
*      - scales.cross_src:     image source of cross
*      - scales.classes        number of classes
*      - scales.mode           mode of your scale ('click', 'slide' or 'button')
*
*
* Any comments, suggestions or bug reports should be adressed
* to Timo Gnambs <timo@gnambs.at>
*
******************************************************************************************/



var scales = new allScales();
        

/**
* All defined scales and configuration options
*/
function allScales() {
    this.scale_src = 'line1.gif';         //default image source of scale
    this.scale_width = 300;                       //width of default scale
    this.scale_height = 16;                       //height of default scale
    this.cross_src = 'cross.gif';         //default image source of cross
    this.crossOv_src = 'cross2_ov.gif';   //default image source of cross for slides on drag
    this.cross_width = 17;                        //width of cross
    this.cross_height = 17;                       //height of cross
    this.classes = 1;                             //default number of classes
    this.mode = 'click';                          //default scale mode: click / slide
    this.labels = new Array();                    //holds labels 
    this.labels_button = ['<', '>'];              //default button label for button scales
    this.items = new Array();                     //holds all defined scales
    this.slide_clickable = false;                 //are slide scales clickable as well?

    this.scale = scale;
    this.init = initScales;
    this.setcrosses = setCrosses;
}


/**
* A single scale with all its values
*
* @param   string     image source of scale
* @param   string     image source of cross
* @param   string     variable name
*/
function theScale() {       
    this.element = theScale.arguments[0];
    this.src = scales.scale_src;
    this.width = scales.scale_width;
    this.height = scales.scale_height;
    this.cross = scales.cross_src;
    this.crossOv = scales.crossOv_src;
    this.cross_width = scales.cross_width;
    this.cross_height = scales.cross_height;
    this.mode = scales.mode;
    this.classes = scales.classes;
    this.labels = scales.labels;
    this.labels_button = scales.labels_button;
    this.slide_clickable = scales.slide_clickable;
    
    this.print = printScale;
}
        
        
/**
* Build new scale
*
* @param  string    variable name
* @param  string    scale mode: click / slide (optional)
* @param  integer   number of classes (optional)
* @param  array     image source, width and height of scale (optional)
* @param  string    image source, width and height of cross (optional)
*/
function scale() {
    /* number of item */
    var cnt = this.items.length;        
            
    /* build new scale */
    for(var i = 0; i < scale.arguments.length; i++) {
        switch(i) {
            case 0:     this.items[cnt] = new theScale(scale.arguments[0]);
                        break;
                        
            case 1:     if(scale.arguments[1] == 'click' || scale.arguments[1] == 'slide' || scale.arguments[1] == 'button')
                            this.items[cnt].mode = scale.arguments[1];
                        break;
                        
            case 2:     if(!isNaN(scale.arguments[2]))
                            this.items[cnt].classes = scale.arguments[2];
                        break;
                        
            case 3:     /* array */
                        if(scale.arguments[3].length > 0 && scale.arguments[3].length <= 3) {
                            this.items[cnt].src = scale.arguments[3][0];
                            if(!isNaN(scale.arguments[3][1])) this.items[cnt].width = scale.arguments[3][1];
                            if(!isNaN(scale.arguments[3][2])) this.items[cnt].height = scale.arguments[3][2];
                        /* no array */
                        } else if(scale.arguments[3].length > 0) {
                            this.items[cnt].src = scale.arguments[3];
                        }
                        break;
                        
            case 4:     if(scale.arguments[4].length > 0 && scale.arguments[4].length <= 4) {
                            this.items[cnt].cross = scale.arguments[4][0];
                            if(!isNaN(scale.arguments[4][1])) this.items[cnt].cross_width = scale.arguments[4][1];
                            if(!isNaN(scale.arguments[4][2])) this.items[cnt].cross_height = scale.arguments[4][2];
                            if(scale.arguments[4][3]) this.items[cnt].crossOv = scale.arguments[4][3];
                        /* no array */
                        } else if(scale.arguments[4].length > 0) {
                            this.items[cnt].cross = scale.arguments[4];
                        }
                        break;
                        
            case 5:     if(scale.arguments[5].length == 2) {
                            this.items[cnt].labels[0] = scale.arguments[5][0];
                            this.items[cnt].labels[1] = scale.arguments[5][1];
                        }
                        break;
        }
    }
    
    this.items[cnt].print(cnt);
}
        
        
/**
* Print scale: image and hidden form element
*
* @param   integer   id    id of current item     
*/
function printScale(id) {
    //print label
    if(this.labels.length >= 2) {
        document.writeln('<table border="0" class="vastable""><tr><td class="vaslabelL">');
        document.writeln(this.labels[0]);
        document.writeln('</td><td class="vasline">');
    }
    
    //print scale
    if(this.mode == 'button') {
        document.writeln('<input type="button" value="' + this.labels_button[0] + '" onclick="moveCross(' + id + ', false, \'click\');" onmousedown="moveCross(' + id + ');" onmouseup="stopCross(' + id + ');"');
        document.writeln(' />');
    }
    document.writeln('<img name="line' + id + '" src="' + this.src + '" width="' + this.width + '" height="' + this.height + '" alt="" border="0" />');
    if(this.mode == 'button') {
        document.writeln('<input type="button" value="' + this.labels_button[1] + '" onclick="moveCross(' + id + ', true, \'click\');" onmousedown="moveCross(' + id + ', true);" onmouseup="stopCross(' + id + ');"');
        document.writeln(' />');
    }

    //print label
    if(this.labels.length >= 2) {
        document.writeln('</td><td class="vaslabelR">');
        document.writeln(this.labels[1]);
        document.writeln('</td></tr></table>');
    }
    
    document.writeln('<input type="hidden" id="' + this.element + '" name="' + this.element + '" value="-9" />');
    document.writeln('<img id="cross' + id + '" name="cross' + id + '" src="' + scales.items[id].cross + '" width="' + this.cross_width + '" height="' + this.cross_height + '" alt="" />');
}


/**
* Initiate some procedures: 
*       1. start dragdrop script        
*       2. set state of crosses
*/        
function initScales() {
    var dragdrop = 'NO_SCROLL';
            
    for(var i = 0; i < this.items.length; i++) {
        /* build dragdrop */
        dragdrop += ', "cross' + i + '"';
        dragdrop += (this.items[i].mode == 'slide') ? '+HORIZONTAL' : '+NO_DRAG';
        dragdrop += (this.items[i].mode != 'button') ? '+CURSOR_HAND' : '';
        dragdrop += ', "line' + i + '"';
        switch(this.items[i].mode) {
            case 'click':
                dragdrop += '+HORIZONTAL+CURSOR_HAND+MAXOFFLEFT+0+MAXOFFRIGHT+0';
                break;
                
            case 'slide':
                dragdrop += '+HORIZONTAL+CURSOR_DEFAULT+MAXOFFLEFT+0+MAXOFFRIGHT+0';
                break;
                
            case 'button':
                dragdrop += '+NO_DRAG';
                break;
        }
    }
     
    /* initialise the dragdrop script */
    eval("SET_DHTML(" + dragdrop + ")");

    this.setcrosses();
}


/**
* Set crosses to their initial states
*/
function setCrosses() {
    for(var i = 0; i < this.items.length; i++) {
        /* hide cross */
        if(this.items[i].mode == 'click') dd.elements["cross"+i].hide();
        
        /* position cross */
        dd.elements["cross"+i].moveTo((dd.elements["line"+i].x + (this.items[i].width / 2) - halfCrossWidth(i)), crossY(i));
        dd.elements["line"+i].addChild("cross"+i);
        dd.elements["cross"+i].defx = dd.elements["line"+i].x + (this.items[i].width / 2) - halfCrossWidth(i);

        /* set max. z-index */
        if(this.items[i].mode == 'click') dd.elements["line"+i].maximizeZ();
        else dd.elements["cross"+i].maximizeZ();
    }
}
        
        
/**
* Calculate half width of cross image (rounded)
*
* @param    integer    id    id of cross
* @return   integer          half cross width
*/
function halfCrossWidth(id) {
    return dd.elements["cross"+id].w / 2;
}


/**
* Calculate y position of cross image
*
* @param    integer    id    id of cross
* @return   integer          y position of cross
* @since                     1.3
*/
function crossY(id) {
    // y of line + half height of line - half height of cross
    return dd.elements["line"+id].y + dd.elements["line"+id].h / 2 - dd.elements["cross"+id].h / 2;
}


/**
* Parse string for id (= last number)
*
* @parse   string    string    string to parse
* @return  integer             id
*/
function getId(string) {
    var result = string.match(/^\D+(\d+)$/);
    return result[1];           
}


/**
* Set value of hidden form element
*
* @param  string   name    name of form element
* @param  integer  content value to set form value to
* @return bool
*/
function setFormValue(name, content) {
    if (document.getElementById) document.getElementById(name).value = content;
    else if(document.all) document.all[name].value = content;
    else if (document.layers) document.forms[0].elements[name].value = content;

    //debug("Wert (" + name + "): " + content);
    return true;
}


/**
* Move cross for button scales
*
* @param  integer  scale id
* @param  boolean  direction (true...right / false...left)
* @return boolean
* @unused
*/
var myTimer;
var movecross = 1;
function moveCross()
{    
    var id = moveCross.arguments[0];
    
    /* process onclick for nn4 only, as onmousedown is disabled through wz_dragdrop */
    if(moveCross.arguments[2] == 'click' && !dd.n4) return;
    /* check for nn4, if we shall run or stop the cross */
    if(moveCross.arguments[2] == 'click' && dd.n4) {
        movecross++;
        if(movecross > 2) {
            stopCross(id);
            movecross = 1;
            return;
        }
    }
    
    var direction = moveCross.arguments[1] ? true : false; //true...right
    if(dd.elements['cross' + id].src == dd.elements['cross' + id].defsrc)  dd.elements['cross' + id].swapImage(scales.items[id].crossOv);

    if (!dd.obj || !dd.op6)
    {
        if(!direction && (dd.elements['cross'+id].x + halfCrossWidth(id)) < dd.elements['line'+id].x) {      
            if(dd.n4) movecross = 1;
            return false;
        }
        if(direction && (dd.elements['cross'+id].x + halfCrossWidth(id)) > (dd.elements['line'+id].x + dd.elements['line'+id].w)) {
            if(dd.n4) movecross = 1;
            return false;
        }
            
        //move cross
        dd.elements['cross'+id].moveTo(
            (direction ? (dd.elements['cross'+id].x + 1) : (dd.elements['cross'+id].x - 1)),
            crossY(id));
        //save value
        var fval = dd.elements['cross'+id].x - dd.elements['line'+id].x + halfCrossWidth(id);
        setFormValue(scales.items[id].element, Math.round(fval));
            
        //set timeout    
        myTimer = setTimeout("moveCross(" + id + ", " + direction + ")", 10);
    }
    
    return false;
}


/**
* Stop move function for button scales
*
* @return boolean
* @unused
*/
function stopCross(id) {
    dd.elements['cross' +id].swapImage(dd.elements['cross' + id].defsrc);
    clearTimeout(myTimer);
    return false;
}
        
        
/**
* Alert form input
*
* @return   bool
*/
function processForm() {
    var element, msg = "VAS ";
            
    for(var i = 0; i < scales.items.length; i++) {
        element = scales.items[i].element;
        msg += element + " = ";
        if(document.getElementById) msg += document.getElementById(element).value;
        else if(document.all) msg += document.all[element].value;
        else if (document.layers) msg += document.forms[0].elements[element].value;
        msg += "\n";
    }
            
    alert(msg);
    return false;
}
        
               
/**
* Construct and print debug layer
*
* @param   string   msg     message to print
*/        
function debug(msg) {
    if(!debug.box) {
        debug.box = document.createElement("div");
        debug.box.setAttribute("style",
                                "background-color: #FFFFFF; " + 
                                "font-family: monospace; " + 
                                "font-size:10px; " +
                                "border: solid black 3px; " + 
                                "padding: 10px; " + 
                                "position: absolute; " + 
                                "top: 10px; " + 
                                "right: 10px;");
        document.body.appendChild(debug.box);
                
        var h1 = document.createElement("h1");
        h1.appendChild(document.createTextNode("Ergebnis"));
        h1.setAttribute("style", "font-size: 10px;");
        debug.box.appendChild(h1);
    }
            
    var p = document.createElement("p");
    p.appendChild(document.createTextNode(msg));
    debug.box.appendChild(p);
}





/****************
* These functions are processed by wz_dragdrop.js
****************/
        
/**
* my_PickFunc IS AUTOMATICALLY CALLED WHEN AN ITEM STARTS TO BE DRAGGED.
*/
function my_PickFunc() {    
    /* determine image id */
    var xpos, currentclass, id = getId(dd.obj.name);
       
    /* process click & slide (line) scales only */
    if(scales.items[id].mode == 'click' || (scales.items[id].mode == 'slide' && dd.obj.name == 'line' + id && scales.items[id].slide_clickable)) {
    
        /* if there are classes */
        if(scales.items[id].classes > 1) {
            currentclass = Math.round((dd.e.x - dd.obj.x) / (dd.obj.w / scales.items[id].classes))
            xpos = dd.obj.x - halfCrossWidth(id) +currentclass * (dd.obj.w / scales.items[id].classes);
            setFormValue(scales.items[id].element, currentclass); //save current class to hidden form field
        /* no classes */
        } else {
            xpos = dd.e.x - halfCrossWidth(id);
            setFormValue(scales.items[id].element, Math.round(dd.e.x - dd.elements["line"+id].x)); //save position to hidden form field
        }
   
        /* position and display cross */
        dd.elements["cross"+id].moveTo(xpos, crossY(id));
        if(!dd.elements["cross"+id].visible) dd.elements["cross"+id].show();
        
    /* swap image of slider on drag */
    } else if(scales.items[id].mode == 'slide' && dd.obj.name == 'cross' + id) {
        dd.obj.swapImage(scales.items[id].crossOv);
    }
}


/**
* my_DragFunc IS CALLED WHILE AN ITEM IS DRAGGED
*/
function my_DragFunc() {
    /* determine image id */
    var id = getId(dd.obj.name);


    //Set left and right limits for the slides
    if(scales.items[id].mode == 'slide' && dd.obj.name == 'cross' + id) {
        /* prevent dragging beyond end of line */
        //if too far left
        if(dd.obj.x <= dd.elements["line"+id].x) {
        //set slider (dd.obj) to the x position of the line (dd.elements["line"+id].x) minus
        //the half width of the slider (to center; as halfCrossWidth(id) results in a double value round it
            dd.obj.moveTo((dd.elements["line"+id].x - Math.floor(halfCrossWidth(id))), crossY(id));
            
        //the same for the right side
        } else if(dd.obj.x >= (dd.elements["line"+id].x + dd.elements["line"+id].w - Math.floor(halfCrossWidth(id)))) {
            dd.obj.moveTo((dd.elements["line"+id].x + dd.elements["line"+id].w - Math.floor(halfCrossWidth(id))), crossY(id));
        }
        
        //finally maximize the z-index
        dd.obj.maximizeZ();
    }
}


/**
* my_DropFunc IS CALLED ONCE AN ITEM IS DROPPED
*/
function my_DropFunc() {
    /* determine image id */
    var currentclass, xpos, id = getId(dd.obj.name);
    
    if(scales.items[id].mode == 'slide' && dd.obj.name == 'cross' + id) {
        /* swap image of slider */
        dd.obj.swapImage(dd.obj.defsrc);
        
        /* slides with classes */
        if(scales.items[id].classes > 1) {
            /* number of classes on current click */
            currentclass = Math.round((dd.obj.x - dd.elements["line"+id].x) / (dd.elements["line"+id].w / scales.items[id].classes));
            /* x position of cross */
            xpos = dd.elements["line"+id].x - halfCrossWidth(id) + currentclass * ((dd.elements["line"+id].w / scales.items[id].classes));
            /* set cross */
            dd.obj.moveTo(xpos, crossY(id));
            /* set form value */
            setFormValue(scales.items[id].element, currentclass);
        
        /* no classes */
        } else
            setFormValue(scales.items[id].element, Math.round(dd.elements["cross"+id].x + halfCrossWidth(id) - dd.elements["line"+id].x));     
    }
}
