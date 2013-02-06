 
    function HideContent(d) {
        document.getElementById(d).style.display = "none";
    }
    function ShowContent(d) {
        document.getElementById(d).style.display = "block";
    }
    function ReverseDisplay(d, type) {
        if (document.getElementById(d).style.display == "none") {
            document.getElementById(d).style.display = "block";

            var dv = document.getElementById(d);

            //call method using json
            if (type == "comments") {
                $.getJSON("/Member/CheckUnreadComments/?ids=" + $("#hdCommentsId").attr("value"),
                function (data) {
                    var lnk = document.getElementById('lnkComments');
                    lnk.innerHTML = 0;

                });
            }
            else if (type == "commitment") {
                $.getJSON("/Member/CheckUnreadCommitment/?ids=" + $("#hdCommitmentId").attr("value"),
                function (data) {
                    var lnk = document.getElementById('lnkcommitments');
                    lnk.innerHTML = 0;
                });
            }
            else if (type == "like") {
                $.getJSON("/Member/CheckUnreadLikes/?ids=" + $("#hdLikeId").attr("value"),
                function (data) {
                    var lnk = document.getElementById('lnkLikes');
                    lnk.innerHTML = 0;
                });
            }
            else {
                $.getJSON("/Member/CheckUnreadFlags/?ids=" + $("#hdFlagId").attr("value"),
                function (data) {
                    var lnk = document.getElementById('lnkFlag');
                    lnk.innerHTML = 0;
                });
            }
            //End Calling
        }
        else {
            document.getElementById(d).style.display = "none";
        }
    }


