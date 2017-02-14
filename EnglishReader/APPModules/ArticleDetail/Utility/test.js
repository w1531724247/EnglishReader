//1.把body里所有的文本提取出来, 按顺序放在一个数组里
var textArray = new Array();

var bodyNode = document.body;
var bodyHTML = bodyNode.innerHTML;

var newBodyHTML = "";
//2.找到第一个结束标签>的位置
var textStartIndex = bodyHTML.indexOf(">");
textStartIndex = textStartIndex + 1;//标签结束的位置就是, 文本开始的位置

newBodyHTML = newBodyHTML + bodyHTML.substring(0, textStartIndex);
var remainString = bodyHTML.substr(textStartIndex);

do {
    var textEndIndex = remainString.indexOf("<");//闭合标签开始的位置就是文本结束的位置
    //获取闭合标签文本, 用来判断此标签类型
    var closeFlagIndex = remainString.indexOf(">");
    var closeTag = remainString.substring(textEndIndex, closeFlagIndex + 1);
    
    if (isExceptTag(closeTag)) {
        newBodyHTML = newBodyHTML + remainString.substring(0, closeFlagIndex+1);
        remainString = remainString.substr(closeFlagIndex+1);
        continue;
    }
    var targetText = remainString.substring(0, textEndIndex);
    
    if (targetText.replace(/(^s*)|(s*$)/g, "").length > 0)
    {
        newBodyHTML = newBodyHTML + "<span>";
        newBodyHTML = newBodyHTML + targetText;
        newBodyHTML = newBodyHTML + "</span>";
        textArray[textArray.length] = targetText;
    } else {
        newBodyHTML = newBodyHTML + targetText;
    }
    
    newBodyHTML = newBodyHTML + closeTag;
    
    textStartIndex = remainString.indexOf(">");
    textStartIndex = textStartIndex + 1;
    remainString = remainString.substr(textStartIndex);
} while(remainString.length > 1);

bodyNode.innerHTML = newBodyHTML;
handleSpans();

function isExceptTag(aText) {
    var isExcept = false;
    var exceptTags = new Array("</script>", "</a>", "</table>","</caption>","</th>", "</tr>", "</td>", "</thead>", "</tbody>", "</tfoot>", "</col>", "</colgroup>", "</img>");
    if (aText.substring(0, 2) == "<!") {//是注释
        isExcept = true;
        return isExcept;
    }
    
    for (var index = 0; index < exceptTags.length; index++) {
        var text = exceptTags[index];
        if (text == aText) {
            isExcept = true;
        }
    }
    
    return isExcept;
}

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
//        jsActionDelegate.textDidTouch(this.innerText);
        alert(this.innerText);
    }
}

