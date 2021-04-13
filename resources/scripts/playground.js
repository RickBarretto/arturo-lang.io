window.snippetId="";var editor=ace.edit("editor");function execCode(){var runbutton=document.getElementById("runbutton");runbutton.innerHTML.includes("notch")||editor.getValue()!=previousCode&&(previousCode=editor.getValue(),runbutton.innerHTML="<i class='fas fa-circle-notch fa-spin'></i>",runbutton.classList.add("working"),document.getElementById("terminal_output").innerHTML="",ajaxPost("https://arturo-lang.io/exec.php",function(got){got=JSON.parse(got);document.getElementById("terminal_output").innerHTML=got.text,window.snippetId=got.code,window.history.replaceState({code:got.code,text:got.text},`${got.code} - Playground | Arturo programming language`,`https://arturo-lang.io/playground/?${got.code}`),runbutton.innerHTML="<i class='far fa-play-circle'></i>",runbutton.classList.remove("working"),window.scroll.animateScroll(document.querySelector("#terminal"))},{c:editor.getValue(),i:window.snippetId}))}function getSnippet(cd){ajaxPost("https://arturo-lang.io/get.php",function(got){got=JSON.parse(got);editor.setValue(got.text),editor.clearSelection(),editor.gotoLine(1)},{i:cd})}function getExample(cd){ajaxPost("https://arturo-lang.io/example.php",function(got){got=JSON.parse(got);editor.setValue(got.text+"\n"),editor.clearSelection(),editor.gotoLine(1)},{i:cd})}function parse_query_string(query){for(var vars=query.split("&"),query_string={},i=0;i<vars.length;i++){var arr=vars[i].split("="),key=decodeURIComponent(arr[0]),value=decodeURIComponent(arr[1]);void 0===query_string[key]?query_string[key]=decodeURIComponent(value):"string"==typeof query_string[key]?(arr=[query_string[key],decodeURIComponent(value)],query_string[key]=arr):query_string[key].push(decodeURIComponent(value))}return query_string}function shareLink(){""!=window.snippetId&&Bulma().alert({type:"info",title:"Share this script",body:`<input id='snippet-link' class='input is-info' value='http://arturo-lang.io/playground?${window.snippetId}'>`,confirm:{label:"Copy link",onClick:function(){var copyText=document.getElementById("snippet-link");copyText.select(),copyText.setSelectionRange(0,99999),document.execCommand("copy"),(window.getSelection?window.getSelection():document.selection).empty(),Bulma().alert({type:"success",title:"Copied",body:"Ready to go!"})}},cancel:"Close"})}function toggleExpand(){window.expanded?(window.expanded=!1,document.querySelector(".doccols").style.display="flex",document.querySelector("#expanderIcon").classList.remove("fa-compress-alt"),document.querySelector("#expanderIcon").classList.add("fa-expand-alt"),document.querySelector("#runbutton").classList.remove("expanded"),document.querySelector("#sharebutton").classList.remove("expanded"),document.querySelector("#expander").classList.remove("expanded")):(window.expanded=!0,document.querySelector(".doccols").style.display="inherit",document.querySelector("#expanderIcon").classList.remove("fa-expand-alt"),document.querySelector("#expanderIcon").classList.add("fa-compress-alt"),document.querySelector("#runbutton").classList.add("expanded"),document.querySelector("#sharebutton").classList.add("expanded"),document.querySelector("#expander").classList.add("expanded"))}document.getElementsByTagName("textarea")[0].setAttribute("aria-label","code snippet"),editor.setTheme("ace/theme/monokai"),editor.getSession().setMode("ace/mode/arturo"),window.previousCode="",document.addEventListener("DOMContentLoaded",function(){var qs;""!=window.location.search&&(void 0!==(qs=parse_query_string(window.location.search.substring(1))).example?(getExample(qs.example),document.getElementById("scriptName").innerHTML=`${qs.example}.art`):getSnippet(window.location.search.replace("?","")))}),window.expanded=!1;