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