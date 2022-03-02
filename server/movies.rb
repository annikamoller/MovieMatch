Movie = Struct.new(:id, :title, :img, :description, :rating)
harry_potter = Movie.new(1, "Harry Potter", "https://www.temashop.se/media/catalog/product/cache/cat_resized/1200/0/h/a/harry_potter_r_glasogon_tillbehor_glasogon.jpg", "A boy and an owl", "4.5/5")
spiderman = Movie.new(2, "Spiderman", "https://usercontent.one/wp/www.comparesweden.se/wp-content/uploads/2021/08/Spider-Man-No-Way-Home.jpg", "A boy in a costume", "4/5")

$movies = { 1 => harry_potter, 2 => spiderman }
