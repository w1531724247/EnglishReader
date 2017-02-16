//起始标签类
function startTagModel(startTagText, index) {
    this.tagType = 0;//标签类型, 0起始标签, 1闭合标签
    this.index = index;//起始位置
    this.endIndex = index + startTagText.length;//结束位置
    this.length = startTagText.length;//标签长度
    this.text = startTagText;
    this.flagText = function() {
        var tagName = "<";
        for (var i = 1; i < this.text.length; i++) {//从第一个字符开始跳过"<"
            var char = this.text.charAt(i);//第i个字符
            var str = /^[A-Za-z]*$/;
            if (str.test(char)) {//是字母
                tagName = tagName + char;
            } else {
                var re = /^[1-9]+[0-9]*]*$/; //判断正整数
                if(re.test(char)){
                    tagName = tagName + char;
                }else{
                    break;//停止循环
                }
            }
        }
        
        return tagName;
    };//起始标识
    
    this.tagName = function() {
        var tagName = "";
        for (var i = 1; i < this.text.length; i++) {//从第一个字符开始跳过"<"
            var char = this.text.charAt(i);//第i个字符
            var str = /^[A-Za-z]*$/;
            if (str.test(char)) {//是字母
                tagName = tagName + char;
            } else {
                var re = /^[1-9]+[0-9]*]*$/; //判断正整数
                if(re.test(char)){
                    tagName = tagName + char;
                }else{
                    break;//停止循环
                }
            }
        }
        
        return tagName;
    }
}

function creatStartTagModelWith(startTagText, index){
    var tag = new startTagModel(startTagText, index);
    return tag;
};

//结束标签类
function closeTagModel(closeTagText, index) {
    this.tagType = 1;//标签类型, 0起始标签, 1闭合标签
    this.index = index;//起始位置
    this.endIndex = index + closeTagText.length;//结束位置
    this.length = closeTagText.length;//标签长度
    this.text = closeTagText;
    this.tagName = function() {
        var tagName = "";
        for (var i = 2; i < this.text.length; i++) {//从第一个字符开始跳过"<"
            var char = this.text.charAt(i);//第i个字符
            var str = /^[A-Za-z]*$/;
            if (str.test(char)) {//是字母
                tagName = tagName + char;
            } else {
                var re = /^[1-9]+[0-9]*]*$/; //判断正整数
                if(re.test(char)){
                    tagName = tagName + char;
                }else{
                    break;//停止循环
                }
            }
        }
        
        return tagName;
    }
}

function creatCloseTagModelWith(closeTagText, index){
    var tag = new closeTagModel(closeTagText, index);
    return tag;
};

//去掉注释
function clearComment(aText) {
    var finalText = "";
    var startText = "<!";
    var endText = ">";
    var remainText = aText;
    var startIndex = remainText.indexOf(startText);
    
    while (startIndex >= 0) {
        var previonsText = remainText.substring(0, startIndex);
        finalText = finalText + previonsText;
        remainText = remainText.substr(startIndex);
        var endIndex = remainText.indexOf(endText);
        remainText = remainText.substr(endIndex+1);
        startIndex = remainText.indexOf(startText);
    }
    
    finalText = finalText + remainText;
    
    return finalText;
}

function isEmptyString(aString) {
    var empty = false;
    var text = aString.replace(/^\s+|\s+$/g,"");//去除所有的空格和换行符
    
    if (text.length <= 0) {
        empty = true;
    }
    return empty;
}

function isExceptTag(aText) {
    var compareString = "<";
    var isExcept = false;
    
    for (var i = 1; i < aText.length; i++) {//从第一个字符开始跳过"<"
        var char = aText.charAt(i);//第i个字符
        var str = /^[A-Za-z]*$/;
        if (str.test(char)) {//是字母
            compareString = compareString + char;
        } else {
            break;//停止循环
        }
    }
    
    var exceptTags = new Array("<script", "<a", "<table","<caption","<th", "<tr", "<td", "<thead", "<tbody", "<tfoot", "<col", "<colgroup", "<img", "<style", "");
    
    for (var index = 0; index < exceptTags.length; index++) {
        var text = exceptTags[index];
        if (compareString == text) {
            isExcept = true;
            break;
        }
    }
    
    return isExcept;
}

//处理body
function handleBodyNode() {
    var bodyNode = document.body;
    var bodySubNodes = bodyNode.childNodes;
    
    for (var index = 0; index < bodySubNodes.length; index++) {
        var subNode = bodySubNodes[index];
        if (subNode == undefined) {
            continue;
        }
        if (subNode.tagName == undefined) {
            continue;
        }
        if (subNode.getAttribute("wraped") == "true"){
            continue;
        }
        
        var htmlString = subNode.innerHTML;
        htmlString = clearComment(htmlString);
        
        var clone_hmtl_string = new String(htmlString);
        
        //提取标签数组
        var tagArray = new Array();
        var cutString = "";
        do {
            if (isEmptyString(htmlString)) {
                break;
            }
            
            //找到标签的开始标志"<"的位置
            var startIndex = htmlString.indexOf("<");//标签的开始标识符
            if (startIndex < 0) {//只有文字没有子标签
                if (isEmptyString(htmlString) == false){//并且htmlString不为空
                    
                }
                htmlString = "";
                continue;
            }
            
            var endIndex = htmlString.indexOf(">");
            var tagText = htmlString.substring(startIndex, endIndex+1);//标签文本
            
            if (tagText.charAt(1) == "/") {//是闭合标签
                var closeTagModel = creatCloseTagModelWith(tagText, startIndex+cutString.length);
                tagArray[tagArray.length] = closeTagModel;
            } else {//是起始标签
                var startTagModel = creatStartTagModelWith(tagText, startIndex+cutString.length);
                tagArray[tagArray.length] = startTagModel;
            }
            cutString = cutString + htmlString.substr(0, endIndex+1);;
            //            alert(cutString.substr(cutString.length - tagText.length, tagText.length)+ " : " +  tagText);
            htmlString = htmlString.substr(endIndex+1);//截取中间的文字
            
        } while(isEmptyString(htmlString) == false);//HTMLString不是空字符串,就继续处理
        
        var newHTMLString = "";
        var spanStart = "<span>";
        var spanEnd = "</span>";
        
        if (tagArray.length < 2) {//没有子标签
            if (isEmptyString(clone_hmtl_string) == false) {
                continue;
            } else {
                newHTMLString = spanStart + clone_hmtl_string + spanEnd;
            }
        }
        
        for (var i = 0; i < tagArray.length - 1; i++) {
            var startTag = tagArray[i];
            var closeTag = tagArray[i+1];
            
            if (index == 0) {//第一个要看他前面有没有文本
                var text = clone_hmtl_string.substring(0, startTag.index);
                if (isEmptyString(text) == false) {
                    newHTMLString = spanStart + text + spanEnd;
                    newHTMLString = newHTMLString + startTag.text;//加上前一个标签
                } else {
                    newHTMLString = newHTMLString + startTag.text;//加上前一个标签
                    newHTMLString = newHTMLString + text;
                }
            }
            
            if (isExceptTag(startTag.text) == true) {
                newHTMLString = newHTMLString + clone_hmtl_string.substring(startTag.index, closeTag.index);//加上前一个标签,和无需处理的文本
                continue;
            }
            
            var nodeText = clone_hmtl_string.substring(startTag.endIndex, closeTag.index);
            
            if (isEmptyString(nodeText)) {
                newHTMLString = newHTMLString + startTag.text;//加上前一个标签
                newHTMLString = newHTMLString + nodeText;
            } else {
                newHTMLString = newHTMLString + startTag.text;//加上前一个标签
                newHTMLString = newHTMLString + spanStart + nodeText + spanEnd;
            }
            
            if (index == tagArray.length - 2) {//最后一个要看它后面又没有文字
                newHTMLString = newHTMLString + closeTag.text;//加上后一个标签
                var text = clone_hmtl_string.substr(closeTag.endIndex);
                if (isEmptyString(text) == false) {
                    newHTMLString = newHTMLString + spanStart + text + spanEnd;
                    continue;
                } else {
                    newHTMLString = newHTMLString + text;
                }
            }
        }
        
        subNode.innerHTML = newHTMLString;
        subNode.setAttribute("wraped", true);
    }
}

handleBodyNode();
