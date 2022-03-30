createParty().then( party => $("#code").text(party.code))

function updatePartylist(){
    getParty().then(party => {
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
    startParty()
    location.href = "./swipe.html"
}

$("#start_btn").click(startClick)

function settingsClick() {
    $("#genres_container").toggleClass("hidden")
}

$("#settings_img").click(settingsClick)

const genres = ["comedy", "horror", "action", "romance"]

function doneClick() {
    // hides settings container
    $("#genres_container").addClass("hidden")
    
    let genres_picked = []

    // finds picked genres
    for(let i = 0; i < genres.length; i++) {
        if ($("#"+genres[i]).is(":checked")) {
            genres_picked.push(genres[i])
        }
    }

    console.log(genres_picked)
    saveGenres(genres_picked)
}

$("#settings_done").click(doneClick)
