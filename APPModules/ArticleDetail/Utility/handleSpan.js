//处理整个页面的宽度
var meta_nodes = document.getElementsByTagName('meta');
for (var i=0; i<meta_nodes.length; i++) {
    var meta = meta_nodes[i];
    var name = meta.getAttribute("name");
    if (name == "viewport") {
        meta.setAttribute("content", "width=device-width; maximum-scale=4.0");
    }
}

var span_nodes = document.getElementsByTagName('span');
for (var i = 0; i < span_nodes.length; i++) {
    var span = span_nodes[i];
    var actionFlag = span.getAttribute("actionFlag");
    if (actionFlag != "YES") {
        var parent = span.parentNode;
        var text = span.innerText;
            var length = text.length;
            
            var clone_span = span.cloneNode(false);
            
            for (var j=0; j<length; j++) {
                var char = text.charAt(j);
                var word = "";
                var str = /^[A-Za-z]*$/;
                if (str.test(char)) {//是字母
                    for (var k=j; k<length; k++){
                        char = text.charAt(k);
                        if (str.test(char)) {
                            word = word + char;
                            if (k == length-1) {
                                if (word.length > 0) {
                                    var action_span = document.createElement('span');
                                    action_span.innerText = word;
                                    action_span.setAttribute("actionFlag", "YES");
                                    action_span.setAttribute("style", "font-size:20px");
                                    action_span.onclick = function () {
                                        jsActionDelegate.textDidTouch(this.innerText);
                                    }
                                    clone_span.appendChild(action_span);
                                    j=k;
                                }
                            }
                        } else {
                            var action_span = document.createElement('span');
                            action_span.innerText = word;
                            action_span.setAttribute("actionFlag", "YES");
                            action_span.setAttribute("style", "font-size:20px");
                            action_span.onclick = function () {
                                jsActionDelegate.textDidTouch(this.innerText);
                            }
                            clone_span.appendChild(action_span);
                            
                            var new_span = document.createElement('span');
                            new_span.innerText = char;
                            new_span.setAttribute("actionFlag", "YES");
                            new_span.setAttribute("style", "font-size:20px");
                            clone_span.appendChild(new_span);
                            j=k;
                            break;
                        }
                    }
                } else {
                    var new_span = document.createElement('span');
                    new_span.innerText = char;
                    new_span.setAttribute("actionFlag", "YES");
                    new_span.setAttribute("style", "font-size:20px");
                    clone_span.appendChild(new_span);
                }
            }
            clone_span.setAttribute("actionFlag", "YES");
            clone_span.setAttribute("style", "font-size:20px");
            parent.replaceChild(clone_span, span);

    }
}

var screenWidth = window.screen.availWidth;
var contentWidth = window.screen.availWidth - 20;

//处理内容的宽高
var div = document.getElementsByTagName('div')[0];
div.style.overflow = "hidden";
div.style.position = "relative";
div.style.wordWrap = "break-word";
div.style.width = contentWidth;
div.style.padding = 10;
div.style.minHeight = 844;

//处理图片的宽高
//var img_nodes = document.getElementsByTagName('img');
//for (var i=0; i<img_nodes.length; i++) {
//    var img = img_nodes[i];
//    img.style.cssText = "width:" + contentWidth + ";" + "height:" + contentWidth;
//}




