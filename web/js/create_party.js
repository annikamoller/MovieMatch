createParty().then( party => $("#code").text(party.code))

function updatePartylist(){
    getParty().then(party => {
        console.log(party.users)
        $('#partyMemberlist').empty()
        for(user in party.users){
            $('#partyMemberlist').append("<li>" + party.users[user] + "</li>")   
        }
    })
}

setInterval(updatePartylist, 1000)

function startClick() {
    console.log("start")
    activateParty()
    localStorage.removeItem("index")
    location.href = "./swipe.html"
}

$("#start_btn").click(startClick)