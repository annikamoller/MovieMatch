Movie = Struct.new(:id, :title, :img, :description, :rating)
harry_potter = Movie.new(1, "Harry Potter", "https://www.temashop.se/media/catalog/product/cache/cat_resized/1200/0/h/a/harry_potter_r_glasogon_tillbehor_glasogon.jpg", "A boy and an owl", "4.5/5")
spiderman = Movie.new(2, "Spiderman", "https://usercontent.one/wp/www.comparesweden.se/wp-content/uploads/2021/08/Spider-Man-No-Way-Home.jpg", "A boy in a costume", "4/5")
teletubbies = Movie.new(3, "Teletubbies", "https://i-viaplay-com.akamaized.net/viaplay-prod/333/352/1576593776-e0a1d5a59361b109a99d1a24b94f3815a679bfd7.jpg?width=400&height=600", "Little poeple running around", "3/5")



$movies = { 1 => harry_potter, 2 => spiderman, 3 => teletubbies}
