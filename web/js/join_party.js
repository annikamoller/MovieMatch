
function updatePartylist(){
    getParty().then(party => {
        console.log(party.users)
        if(party.active == true){
            startParty()
            location.href = "./swipe.html"
        }
        $('#partyMemberlist').empty()
        for(user in party.users){
            $('#partyMemberlist').append("<li>" + party.users[user] + "</li>")   
        }
    })
}

function join_click(){
    alert("Joined")
    const code = $("#code").val()
    startParty()
    joinParty(code).then(party => {
        $("#partyInfo").removeClass("hidden")
        $("#joinForm").addClass("hidden")
        $("#partyCode").text(party.code)
        setInterval(updatePartylist, 1000)
    }).catch(err => alert(err))

}

$("#join_btn").click(join_click)