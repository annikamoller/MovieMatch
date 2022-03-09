let movieId=0
nextMovie().then(movie => {
    movieId = movie.id
    console.log(movie)
    $("#title").text(movie.title)
    $("#rating").text(movie.rating)
    $("#description").text(movie.description)
    $("#movieimg").attr("src", movie.img)
})

$("#dissBtn").click(()=> location.reload())
$("#likeBtn").click(()=> {
    likeMovie(movieId).then(data => console.log(data))
    location.reload()
})
$("#closeBtn").click(()=> {
    $("#modal").removeClass("active")  
})
setInterval(()=>{
    getParty().then((party)=>{
        if(party.matches.length != localStorage.getItem("matches").length){
           console.log("New match!")
           getMovie(party.matches[party.matches.length-1]).then(movie => {
            $("#matchtitle").text(movie.title)
           })
           $("#modal").addClass("active")
           localStorage.setItem("matches", party.matches) 
        }
    })

}, 1000)