function join_click(){
    alert("Joined")
    const code = $("#code").val()
    joinParty(code).catch(err => alert(err))
}

$("#join_btn").click(join_click)