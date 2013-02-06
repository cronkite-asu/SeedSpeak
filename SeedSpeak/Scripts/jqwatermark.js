
$(document).ready(function(){  
     //Initialization
//Applies "waterMarkOn" style to all elements denoted with "waterMark" Class and assigns
//custom attribute entry (compliance battle ensues)
$(".waterMark").each(function(index){
$(this).addClass("watermarkOn");
$(this).val($(this).attr("title"));
}); 
//Select for Entry
//Removes waterMarkOn style and data of element denoted with "waterMark" data default title or 
//empty-triggered by focus
    $(".waterMark").bind('focus',function() {
        $(this).filter(function() {
var val2=jQuery.trim($(this).val());
return val2 == "" || val2 == $(this).attr("title")
        }).removeClass("watermarkOn").val("");
    });
    
//Reset Data
//Re-applies "waterMarkOn" style to all elements denoted with "waterMark" Class and assigns
//custom attribute entry (compliance battle ensues)- but not before trimming whitespace
$(".waterMark").bind('blur',function() {
        $(this).filter(function() {
var val2=jQuery.trim($(this).val());
            return val2 == ""
        }).addClass("watermarkOn").val($(this).attr("title"));
    });

  //Clears the data of watermark values that have default waterMarks values //before submission 
$('form').bind('submit',function(){
$(".waterMark").each(function(index){
var val2=jQuery.trim($(this).val());
if (val2 == $(this).attr("title")) {
$(this).val(""); 
}
});
});

});

