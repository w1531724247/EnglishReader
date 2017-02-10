//只提取文章内容
function extractArticleNode() {

}
extractArticleNode();

function handleElementsWithTagName(tagName) {
    var span_nodes = document.getElementsByTagName(tagName);
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
}

//处理<span>标签
handleElementsWithTagName('span');
//处理<p>标签
handleElementsWithTagName('p');
//处理<h1>标签
handleElementsWithTagName('h1');
//处理<h2>标签
handleElementsWithTagName('h2');
//处理<h3>标签
handleElementsWithTagName('h3');
//处理<h4>标签
handleElementsWithTagName('h4');
//处理<h5>标签
handleElementsWithTagName('h5');
//处理<h6>标签
handleElementsWithTagName('h6');
