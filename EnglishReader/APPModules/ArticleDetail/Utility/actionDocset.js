function wrapTextToNode(aNode) {
    var currentNode = aNode;
    var foundNotActionedNode = false;
    var pp_node;
    while (currentNode.hasChildNodes()) {//等于1表示没有子节点
        var iteratorOver = false;
        for (var index = 0; index < currentNode.childNodes.length; index++) {
            var subNode = currentNode.childNodes[index];
            if (subNode.tagName != undefined) {
                var wrapedFlag = subNode.getAttribute("wraped");
                if (wrapedFlag != "true") {
                    pp_node = currentNode.parentNode;
                    currentNode = subNode;
                    foundNotActionedNode = true;
                    break;//断开循环
                }
            }
            if (index == currentNode.childNodes.length - 1) {
                iteratorOver = true;
            }
        }
        
        if (iteratorOver) {//遍历完了
            break;
        }
    }
    
    if (aNode.isSameNode(currentNode.parentNode)) {
        addWrapedAttributeToNode(currentNode);//当前节点是aNode的子节点, 并且当前节点没有子节点, 遍历下一个兄弟节点
        aNode.appendChild(currentNode);
        
        return foundNotActionedNode;
    }
    
    if (foundNotActionedNode == false) {
        return foundNotActionedNode;
    }
    
    try {
        var clone_parentNode = cloneNodeWithOutSubNode(currentNode.parentNode);
        
        //走到这里说明currentNode没有子node
        var brotherNodes = currentNode.parentNode.childNodes;//收集他的兄弟node
        var parentText = currentNode.parentNode.innerHTML;//父node的文本
        var previonsText = "";
        pp_node.removeChild(currentNode.parentNode);
        
        for (var index = 0; index < brotherNodes.length; index++) {
            var node = brotherNodes[index];
            if (node.tagName == undefined) {//通常为文本对象
                continue;
            }
            
            addWrapedAttributeToNode(node);
            var startText = "<" + node.tagName.toLowerCase();
            var startIndex = parentText.indexOf(startText);
            var endText = "</" + node.tagName.toLowerCase() + ">";
            var endIndex = parentText.indexOf(endText);
            previonsText = parentText.substr(0, startIndex);
            
            if (previonsText.length > 0) {
                var spanNode = document.createElement("span");
                spanNode.innerText = previonsText;
                clone_parentNode.appendChild(spanNode);
                addWrapedAttributeToNode(spanNode);
                clone_parentNode.appendChild(node);
            } else {
                clone_parentNode.appendChild(node);
            }
            parentText = parentText.substring(endIndex+endText.length);
            
        }
        
        //处理尾巴
        if (parentText.length > 0) {
            var spanNode = document.createElement("span");
            spanNode.innerText = parentText;
            clone_parentNode.appendChild(spanNode);
            addWrapedAttributeToNode(spanNode);
        }
        
        addWrapedAttributeToNode(clone_parentNode);
        pp_node.appendChild(clone_parentNode);
        
        return foundNotActionedNode;
    } catch(err) {
        alert("error " + count + currentNode.innerText + "-->" + currentNode.parentNode.innerText);
    }
}

function addWrapedAttributeToNode(aNode) {
    aNode.setAttribute("wraped", true);
    if (isExceptNode(aNode) == false) {
        alert(aNode.tagName);
        addActionToEveryWordWithNode(aNode);
    }
}

//克隆一个节点及其属性
function cloneNodeWithOutSubNode(aNode){
    var clone_node = document.createElement(aNode.tagName);//创建新的节点
    //复制属性
    var attributes = aNode.attributes;
    for (var index = 0; index < attributes.length; index++) {
        var attri = attributes[index];
        var name = attri.name;
        var value = attri.value;
        clone_node.setAttribute(name, value);
    }
    
    return clone_node;
}

function addActionToEveryWordWithNode(aNode) {
    if (aNode == undefined) {
        return;
    }
    if (aNode.hasChildNodes()) {
        //不能有子节点
        return;
    }
    if (isExceptNode(aNode)) {
        return;
    }
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
                        action_span.onclick = function () {
                            jsActionDelegate.textDidTouch(this.innerText);
                        }
                        spanArray[spanArray.length] = action_span;
                        i = j;
                    }
                } else {
                    var action_span = document.createElement('span');
                    action_span.innerText = word;
                    action_span.setAttribute("actionFlag", true);
                    action_span.onclick = function () {
                        jsActionDelegate.textDidTouch(this.innerText);
                    }
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

function isExceptNode(aNode) {
    var except = false;
    var exceptTags = new Array("table","caption","th", "tr", "td", "thead", "tbody", "tfoot", "col", "colgroup", "a", "image");
    for (var index = 0; index < exceptTags.length; index++) {
        var tagName = exceptTags[index];
        if (aNode.tagName.toLowerCase() == tagName) {
            except = true;
        }
    }
    
    return except;
}

var articleNodes = document.getElementsByTagName("article");
var article = articleNodes[0];
var found
do {
    found = wrapTextToNode(article);
} while (found);


