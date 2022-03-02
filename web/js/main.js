getUser().then(username => $("#username").text(username))

$("#createParty").click(() => {
    createParty().then(party => {
        console.log(party)
    })
})

$("#joinParty").click(() => {
    const code = $("#inputCode").val()
    joinParty(code).then((party) => {
        alert("Success")
        console.log(party)
    }).catch(err => console.log(err.data))
})
