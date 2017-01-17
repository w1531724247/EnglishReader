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
                            action_span.onclick = function () {
                                jsActionDelegate.textDidTouch(this.innerText);
                            }
                            clone_span.appendChild(action_span);
                            
                            var new_span = document.createElement('span');
                            new_span.innerText = char;
                            new_span.setAttribute("actionFlag", "YES");
                            clone_span.appendChild(new_span);
                            j=k;
                            break;
                        }
                    }
                } else {
                    var new_span = document.createElement('span');
                    new_span.innerText = char;
                    new_span.setAttribute("actionFlag", "YES");
                    clone_span.appendChild(new_span);
                }
            }
            clone_span.setAttribute("actionFlag", "YES");
            parent.replaceChild(clone_span, span);

    }
}

