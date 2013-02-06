<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<SeedSpeak.Model.Validation.AddSeed>" %>
 
<script src="../../Scripts/jquery.autocomplete.min.js" type="text/javascript"></script>
<script type="text/javascript">
    function getIds(id) {
        var temp = new Array();
        temp = id.split(',');
        var cId = document.getElementById('categoryIds');
        cId.value == "";
        var i = 0;
        for (i = 0; i < temp.length; i++) {
            var chk = document.getElementById(temp[i]);
            if (chk != null) {
                if (chk.checked) {
                    if (i == 0) {
                        cId.value = temp[i];
                    }
                    else {
                        cId.value = cId.value + ',' + temp[i];
                    }
                }
            }
        }
        var lblName = document.getElementById('SeedName');
        var lblTag = document.getElementById('Tag');
        var lblerr = document.getElementById('divErrMsg');
        var tagErr = "";
        if (lblTag.value != "") {
            $.getJSON("/Seed/CheckBadWord/?badWord=" + $("#Tag").attr("value"),
                        function (data) {
                            if (data.toString() == "true") {
                                tagErr = " and keyword";
                                
                            }
                        });
        }
        $.getJSON("/Seed/CheckBadWord/?badWord=" + $("#SeedName").attr("value"),
                        function (data) {
                            if (data.toString() == "true") {
                                var errMsg = "";
                                if (tagErr != "") {
                                    errMsg = "Bad Word found in seed title" + tagErr;
                                }
                                else {
                                    errMsg = "Bad Word found in seed title";
                                }
                                lblerr.innerHTML = errMsg;
                                return false;
                            }
                            else {
                                if (tagErr == " and keyword") {
                                    errMsg = "Bad Word found in keyword";
                                    lblerr.innerHTML = errMsg;
                                    return false;
                                }
                                else {
                                    $('#SeedInfo').submit();
                                }
                            }
                        });
        return false;
    }

    $(document).ready(function () {
        //Adding autocomplete to Tag input
        $("#Tag").autocomplete('<%: Url.Action("Tags", "Member") %>', {
            minChars: 0,
            //Don't fill the input while still selecting a value
            autoFill: false,
            //Only suggested values are valid
            mustMatch: false,
            //The comparison doesn't looks inside 
            matchContains: false,
            //The number of query results to store in cache
            cacheLength: 12,

            //Callback which will format items for autocomplete list
            formatItem: function (data, index, max) {
                //Display only descriptions in list
                return data[1];
            },
            //Callback which will format items for matching
            formatMatch: function (data, index, max) {
                //Match only descriptions
                return data[1];
            },
            //Callback which will format result
            formatResult: function (data, index, max) {
                //Display only description as result
                return data[1];
            }
            //Callback which will be called when user chooses value
        }).result(function (event, data, formatted) {
            //Set territory id as hidden input value
            if (data)
                $("#cityId").val(data[0]);
            else
                $("#cityId").val('-1')
        });
    });

</script>
<script type="text/javascript">
    $(document).ready(function () {
        $("#SeedInfo").validate({
            errorLabelContainer: $("ul", $('div.error-container')),
            wrapper: 'li',
            rules: {
                SeedName: {
                    required: true
                },
                Description: {
                    required: true
                }
            },
            messages: {
                SeedName: {
                    required: " Please specify Seed Name"
                },
                Description: {
                    required: " Please specify Description"
                }
            }
        });
    });
</script>
<script type="text/javascript">
    function toggle5(showHideDiv, switchImgTag) {
        var ele = document.getElementById(showHideDiv);
        var imageEle = document.getElementById(switchImgTag);
        if (ele.style.display == "block") {
            ele.style.display = "none";
            imageEle.innerHTML = '<img src="../../Content/images/plus.gif" />';
        }
        else {
            ele.style.display = "block";
            imageEle.innerHTML = '<img src="../../Content/images/minus.gif">';
        }
    }
</script>
<% using (Html.BeginForm("SeedInfo", "Seed", FormMethod.Post, new { id = "SeedInfo", style = "width:250px;border:0px solid #000" }))
   {%>
<fieldset>
    <div class="error-container" style="width: 250px;">
        <ul>
        </ul>
    </div>
    <div class="clear">
    </div>
    <div id="divErrMsg" class="error">
        <%: ViewData["SeedPlant"] %>
    </div>
    <div class="clear">
    </div>
    <label>
        Name your seed  <ins>(Max 40 Characters)</ins>
        <%: Html.TextBoxFor(model => model.SeedName, new { maxlength = 40,style = "width:100%;"   })%>
         
    </label>
    <div class="clear">
    </div>
    <label>
        Describe your seed
        <%: Html.TextAreaFor(model => model.Description, new { maxlength =1000,style="width:97%;height:70px"})%>
    </label>
    <div class="clear">
    </div>
    <label>
        Add some Keyword<br />
        <%: Html.TextBoxFor(model => model.Tag, new { maxlength = 40, style = "width:100%;" })%>
    </label>
    <%: Html.Hidden("cityId", -1) %>
    <%: Html.Hidden("StateCode") %>
    <div class="clear">
    </div><br />
    <div id="headerDivImg">
        <div id="titleTextImg">
            Select a category
        </div>
        <a id="imageDivLink" href="javascript:toggle5('contentDivImg', 'imageDivLink');"><img src="../../Content/images/plus.gif" alt="click "></a>
    </div>
    <div id="contentDivImg" style="display: none; padding-top: 10px;">
        <input type="hidden" id="categoryIds" name="categoryIds" />
        <%  if (ViewData["categoryId"] != null)
            {
                foreach (SeedSpeak.Model.Category c in ViewData["categoryId"] as List<SeedSpeak.Model.Category>)
                {%>
        <input type="checkbox" id="<%= c.id %>" name="category" value='"<%= c.id %>"' /><%= c.name%>
        <br />
        <% }
            } %>
    </div>
    <div class="clear">
    </div>
    <br />
    <br />
    <div class="btncontainer">
        <input type="submit" value="Step 2: Place on Map" onclick="javascript:return getIds('<%= ViewData["ids"] %>');"
            class="gbtnxl" />
    </div>
</fieldset>
<% } %>
