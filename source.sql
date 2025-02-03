CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  image_url VARCHAR(255)
);

INSERT INTO products (name, description, price, image_url) VALUES
('Blonde Artisanale', 'Une bière blonde rafraîchissante possédant une légère amertume.
Brassée avec des ingrédients locaux pour une saveur unique.
Parfaite pour accompagner des grillades ou des fruits de mer.', 4.50, 'https://example.com/blonde.jpg'),

('Ambrée Caramélisée', 'Une bière ambrée aux arômes de caramel et de malt grillé.
Son goût riche et légèrement sucré ravira les amateurs de bières de caractère.
Idéale avec des fromages affinés ou des viandes rôties.', 5.00, 'https://example.com/ambree.jpg'),

('Brune Intense', 'Une bière brune aux saveurs de chocolat noir et de café torréfié.
Sa texture onctueuse et son amertume maîtrisée en font un choix parfait pour cette saison.
À déguster avec un dessert au chocolat ou en apéritif.', 5.50, 'https://example.com/brune.jpg'),

('IPA Houblonnée', 'Une IPA explosive en houblon avec des notes de fruits tropicaux et une amertume marquée.
Parfaite pour les amateurs de bières audacieuses.
Elle accompagne idéalement les plats épicés et les burgers.', 6.00, 'https://example.com/ipa.jpg'),

('Triple Forte', 'Une bière triple puissante avec des notes épicées et une belle rondeur en bouche.
Sa fermentation haute lui confère une richesse aromatique exceptionnelle.
Idéale pour les amateurs de bières belges.', 6.50, 'https://example.com/triple.jpg'),

('Blanche Légère', 'Une bière blanche légère et fruitée avec des arômes de coriandre.
Parfaite pour les journées chaudes grâce à sa fraîcheur désaltérante.
À déguster bien fraîche avec des fruits de mer.', 4.00, 'https://example.com/blanche.jpg');