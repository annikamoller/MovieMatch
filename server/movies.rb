Movie = Struct.new(:id, :title, :img, :description, :rating)
harry_potter = Movie.new(1, "Harry Potter", "example.com", "A boy and an owl", "4.5/5")
spiderman = Movie.new(2, "Spiderman", "example.com", "A boy in a costume", "4/5")

$movies = { 1 => harry_potter, 2 => spiderman }
