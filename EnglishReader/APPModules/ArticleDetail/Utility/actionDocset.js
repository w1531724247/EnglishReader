function handleSpans() {
    //处理<span>标签
    var span_nodes = document.getElementsByTagName('span');
    for (var i = 0; i < span_nodes.length; i++) {
        var span = span_nodes[i];
        var actionFlag = span.getAttribute("actionFlag");
        if (actionFlag != "true") {
            addActionToEveryWordWithNode(span);
        }
    }
}

function addActionToEveryWordWithNode(aNode) {
    var aText = aNode.innerText;
    var textLength = aText.length;
    var spanArray= new Array();
    for (var i = 0; i < textLength; i++) {
        var char = aText.charAt(i);//第i个字符
        var word = "";
        var str = /^[A-Za-z]*$/;
        if (str.test(char)) {//是字母
            for (var j = i; j < textLength; j++) {
                char = aText.charAt(j);
                if (str.test(char)) {
                    word = word + char;
                    
                    if (j == textLength - 1) {//最后一位是字母
                        var action_span = document.createElement('span');
                        action_span.innerText = word;
                        action_span.setAttribute("actionFlag", true);
                        addClickEventToNode(action_span);
                        spanArray[spanArray.length] = action_span;
                        i = j;
                    }
                } else {
                    var action_span = document.createElement('span');
                    action_span.innerText = word;
                    action_span.setAttribute("actionFlag", true);
                    addClickEventToNode(action_span);
                    spanArray[spanArray.length] = action_span;
                    i = j - 1;
                    break;
                }
            }
        } else {
            var new_span = document.createElement('span');
            new_span.innerText = char;
            new_span.setAttribute("actionFlag", true);
            spanArray[spanArray.length] = new_span;
        }
    }
    
    aNode.innerHTML = "";
    for (var j = 0; j < spanArray.length;j++) {
        var span = spanArray[j];
        aNode.appendChild(span);
    }
}

function addClickEventToNode(aNode) {
    aNode.onclick = function () {
        jsActionDelegate.textDidTouch(this.innerText);
    }
}

handleSpans();

