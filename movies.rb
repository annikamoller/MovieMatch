Movie = Struct.new(:title, :img, :description, :rating)
harry_potter = Movie.new("Harry Potter", "example.com", "A boy and an owl", "4.5/5")
spiderman = Movie.new("Spiderman", "example.com", "A boy in a costume", "4/5")

$movies = {1 => harry_potter, 2 => spiderman}