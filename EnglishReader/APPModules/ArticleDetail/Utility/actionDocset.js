function wrapTextToNode(aNode) {
    var currentNode = aNode;
    var foundNotActionedNode = false;
    var pp_node;
    while (hasSubTags(currentNode)) {//等于1表示没有子节点, 但有一个隐式的文本节点, 文本也是一个节点
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
    
    if (aNode.isSameNode(currentNode.parentNode)){
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
        var wrapParent = wrapedParentNode(currentNode.parentNode);
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
        
        if (wrapParent) {
            addWrapedAttributeToNode(clone_parentNode);
        }
        pp_node.appendChild(clone_parentNode);
        
        return foundNotActionedNode;
    } catch(err) {
        alert("error " + currentNode.innerText + "-->" + currentNode.parentNode.innerText);
    }
}

function addWrapedAttributeToNode(aNode) {
    if (aNode.tagName != undefined) {
        aNode.setAttribute("wraped", true);
    }
    if (isExceptNode(aNode) == false) {
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
    
    if (hasSubTags(aNode)) {
        //不能有子标签
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
                            //                            jsActionDelegate.textDidTouch(this.innerText);
                            alert(this.innerText);
                        }
                        spanArray[spanArray.length] = action_span;
                        i = j;
                    }
                } else {
                    var action_span = document.createElement('span');
                    action_span.innerText = word;
                    action_span.setAttribute("actionFlag", true);
                    action_span.onclick = function () {
                        //                        jsActionDelegate.textDidTouch(this.innerText);
                        alert(this.innerText);
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

//判断一个标签是否有子标签
function hasSubTags(aNode){
    var has = false;
    if (aNode.childNodes.length > 1) {
        has = true;
    }
    
    if (aNode.childNodes.length == 1) {//只有文本没有, 子标签 或者只有一个子标签, 但除了子标签之外没有文本, childNodes.length = 1
        var subNode = aNode.childNodes[0];
        if (subNode.tagName != undefined) {
            has = true;
        }
    }
    
    return has;
}
//判断是否应给给这个节点添加wraped标识
function wrapedParentNode(aNode) {
    var add = true;
    if (aNode.childNodes.length == 1) {
        var firstNode = aNode.firstChild;
        if (aNode.innerText == firstNode.innerText) {
            add = false;//如果只有一个子节点, 并且自身没有文本, 不要给它加wraped标签, 以便下次遍历它的兄弟标签
        }
    }
    
    return add;
}

var articleNodes = document.getElementsByTagName("article");
var article = articleNodes[0];
var found
do {
    found = wrapTextToNode(article);
} while (found);


