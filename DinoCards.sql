
create database if not exists dinocards;

use dinocards;

drop table if exists colecciones;
drop table if exists usuarios;
drop table if exists dinosaurios;

create table usuarios(
id int primary key auto_increment,
username varchar(64) unique,
email varchar(255) unique,
password_hash varchar(1024),
fecha_obtencion datetime,
ultima_obtencion date
);

delimiter $$
drop procedure if exists Registro2$$
create procedure Registro2(in _username varchar(64), in _email varchar(255), in _password_hash varchar(255), out eror int)
begin
  if _username = '' then set eror = -1;
  elseif exists (select 1 from usuarios where username = _username) then set eror = -2;
  elseif _password_hash = '' then set eror = -3;
  else
    insert into usuarios(username, email, password_hash) values (_username, _email, _password_hash);
    set eror = 0;
  end if;
end$$
delimiter;

delimiter $$
drop procedure if exists login2$$
create procedure login2(in _username varchar(30), in _password_hash varchar(30), out eror int)
begin
declare coincidencias int default 0;
	select count(*) into coincidencias from staff where username = _username and password = _password_hash;

    if coincidencias > 0 then
        set eror = 0;   
    else
        set eror = -1;  
    end if;
end$$
delimiter ;

delimiter $$
drop procedure if exists ObtenerDinosaurios$$
create procedure ObtenerDinosaurios()
begin
  select nombre, especie, periodo, imagen_url as imagenUrl,
         altura, largo, peso, hp, vigor, ataque, defensa, agilidad
  from dinosaurios;
end$$
delimiter ;

delimiter $$
drop procedure if exists ObtenerColeccion$$
create procedure ObtenerColeccion(in p_username varchar(64))
begin
  select d.nombre, d.especie, d.periodo, d.imagen_url as imagenUrl,
         d.altura, d.largo, d.peso, d.hp, d.vigor, d.ataque, d.defensa, d.agilidad
  from colecciones c
  join usuarios u on u.id = c.usuario_id
  join dinosaurios d on d.id = c.dinosaurio_id
  where u.username = p_username
  order by c.id;
end$$
delimiter ;

create table dinosaurios(
id int primary key auto_increment,
nombre varchar(1024),
especie varchar(1024),
periodo varchar(1024),
imagen_url varchar(1024),
altura decimal(4,2),
largo decimal(4,2),
peso decimal(6,2),
hp int,
vigor int,
ataque int,
defensa int,
agilidad int
);


create table colecciones(
id int primary key auto_increment,
usuario_id int,
dinosaurio_id int,
fecha_adquisicion datetime,
foreign key (usuario_id) references usuarios(id),
foreign key (dinosaurio_id) references dinosaurios(id)
);


INSERT INTO dinosaurios (nombre, especie, periodo, imagen_url, altura, largo, peso, hp, vigor, ataque, defensa, agilidad) VALUES
('Tyrannosaurus', 'Tyrannosaurus rex', 'cretacico', 'https://example.com/dinosaurios/tyrannosaurus.jpg', 3.66, 12.30, 8.40, 950, 80, 98, 70, 55),
('Allosaurus', 'Allosaurus fragilis', 'jurasico', 'https://example.com/dinosaurios/allosaurus.jpg', 4.00, 8.50, 2.30, 700, 78, 88, 55, 68),
('Spinosaurus', 'Spinosaurus aegyptiacus', 'cretacico', 'https://example.com/dinosaurios/spinosaurus.jpg', 7.00, 14.00, 7.40, 900, 82, 95, 65, 50),
('Velociraptor', 'Velociraptor mongoliensis', 'cretacico', 'https://example.com/dinosaurios/velociraptor.jpg', 0.50, 2.00, 0.02, 120, 90, 65, 25, 95),
('Giganotosaurus', 'Giganotosaurus carolinii', 'cretacico', 'https://example.com/dinosaurios/giganotosaurus.jpg', 4.00, 12.00, 8.00, 920, 75, 96, 68, 52),
('Carnotaurus', 'Carnotaurus sastrei', 'cretacico', 'https://example.com/dinosaurios/carnotaurus.jpg', 2.80, 8.00, 1.50, 640, 85, 82, 50, 80),
('Utahraptor', 'Utahraptor ostrommaysorum', 'cretacico', 'https://example.com/dinosaurios/utahraptor.jpg', 1.80, 6.00, 0.50, 400, 88, 85, 45, 85),
('Deinonychus', 'Deinonychus antirrhopus', 'cretacico', 'https://example.com/dinosaurios/deinonychus.jpg', 1.00, 3.40, 0.07, 220, 90, 72, 30, 92),
('Dilophosaurus', 'Dilophosaurus wetherilli', 'jurasico', 'https://example.com/dinosaurios/dilophosaurus.jpg', 2.40, 7.00, 0.40, 380, 70, 68, 35, 75),
('Ceratosaurus', 'Ceratosaurus nasicornis', 'jurasico', 'https://example.com/dinosaurios/ceratosaurus.jpg', 3.00, 6.00, 0.60, 450, 72, 74, 42, 72),
('Carcharodontosaurus', 'Carcharodontosaurus saharicus', 'cretacico', 'https://example.com/dinosaurios/carcharodontosaurus.jpg', 4.00, 12.00, 6.20, 880, 74, 92, 64, 50),
('Baryonyx', 'Baryonyx walkeri', 'cretacico', 'https://example.com/dinosaurios/baryonyx.jpg', 3.00, 10.00, 1.70, 600, 70, 78, 50, 62),
('Albertosaurus', 'Albertosaurus sarcophagus', 'cretacico', 'https://example.com/dinosaurios/albertosaurus.jpg', 3.40, 9.00, 2.50, 680, 82, 85, 55, 70),
('Gorgosaurus', 'Gorgosaurus libratus', 'cretacico', 'https://example.com/dinosaurios/gorgosaurus.jpg', 3.00, 8.60, 2.00, 620, 83, 83, 52, 72),
('Compsognathus', 'Compsognathus longipes', 'jurasico', 'https://example.com/dinosaurios/compsognathus.jpg', 0.25, 1.00, 0.01, 30, 85, 20, 10, 98),
('Coelophysis', 'Coelophysis bauri', 'triasico', 'https://example.com/dinosaurios/coelophysis.jpg', 1.00, 3.00, 0.02, 90, 88, 35, 15, 96),
('Herrerasaurus', 'Herrerasaurus ischigualastensis', 'triasico', 'https://example.com/dinosaurios/herrerasaurus.jpg', 1.10, 4.00, 0.20, 200, 80, 55, 30, 85),
('Gallimimus', 'Gallimimus bullatus', 'cretacico', 'https://example.com/dinosaurios/gallimimus.jpg', 1.90, 6.00, 0.44, 260, 95, 25, 30, 97),
('Ornithomimus', 'Ornithomimus edmonticus', 'cretacico', 'https://example.com/dinosaurios/ornithomimus.jpg', 2.00, 3.80, 0.17, 180, 93, 22, 28, 96),
('Therizinosaurus', 'Therizinosaurus cheloniformis', 'cretacico', 'https://example.com/dinosaurios/therizinosaurus.jpg', 5.00, 10.00, 5.00, 700, 60, 90, 72, 30),
('Oviraptor', 'Oviraptor philoceratops', 'cretacico', 'https://example.com/dinosaurios/oviraptor.jpg', 0.90, 2.00, 0.03, 140, 82, 40, 22, 88),
('Troodon', 'Troodon formosus', 'cretacico', 'https://example.com/dinosaurios/troodon.jpg', 1.00, 2.40, 0.05, 130, 84, 45, 20, 93),
('Microraptor', 'Microraptor gui', 'cretacico', 'https://example.com/dinosaurios/microraptor.jpg', 0.30, 0.80, 0.01, 40, 78, 22, 8, 97),
('Archaeopteryx', 'Archaeopteryx lithographica', 'jurasico', 'https://example.com/dinosaurios/archaeopteryx.jpg', 0.30, 0.50, 0.01, 35, 60, 15, 6, 90),
('Suchomimus', 'Suchomimus tenerensis', 'cretacico', 'https://example.com/dinosaurios/suchomimus.jpg', 4.00, 11.00, 3.80, 720, 70, 80, 55, 58),
('Acrocanthosaurus', 'Acrocanthosaurus atokensis', 'cretacico', 'https://example.com/dinosaurios/acrocanthosaurus.jpg', 4.00, 11.50, 6.00, 820, 74, 90, 62, 55),
('Mapusaurus', 'Mapusaurus roseae', 'cretacico', 'https://example.com/dinosaurios/mapusaurus.jpg', 4.20, 12.00, 5.00, 800, 74, 91, 63, 56),
('Majungasaurus', 'Majungasaurus crenatissimus', 'cretacico', 'https://example.com/dinosaurios/majungasaurus.jpg', 3.00, 7.00, 1.10, 560, 78, 80, 50, 68),
('Yutyrannus', 'Yutyrannus huali', 'cretacico', 'https://example.com/dinosaurios/yutyrannus.jpg', 2.50, 9.00, 1.40, 590, 75, 79, 48, 66),
('Tarbosaurus', 'Tarbosaurus bataar', 'cretacico', 'https://example.com/dinosaurios/tarbosaurus.jpg', 3.50, 10.00, 4.50, 800, 80, 90, 62, 58),
('Daspletosaurus', 'Daspletosaurus torosus', 'cretacico', 'https://example.com/dinosaurios/daspletosaurus.jpg', 3.50, 9.00, 3.80, 760, 79, 88, 60, 60),
('Megalosaurus', 'Megalosaurus bucklandii', 'jurasico', 'https://example.com/dinosaurios/megalosaurus.jpg', 3.00, 9.00, 1.00, 540, 70, 76, 48, 65),
('Torvosaurus', 'Torvosaurus tanneri', 'jurasico', 'https://example.com/dinosaurios/torvosaurus.jpg', 3.50, 10.00, 4.00, 780, 72, 89, 58, 55),
('Gigantoraptor', 'Gigantoraptor erlianensis', 'cretacico', 'https://example.com/dinosaurios/gigantoraptor.jpg', 5.00, 8.00, 1.40, 500, 78, 68, 40, 78),
('Dromaeosaurus', 'Dromaeosaurus albertensis', 'cretacico', 'https://example.com/dinosaurios/dromaeosaurus.jpg', 0.90, 1.80, 0.02, 110, 88, 58, 24, 90),
('Zhenyuanlong', 'Zhenyuanlong suni', 'cretacico', 'https://example.com/dinosaurios/zhenyuanlong.jpg', 0.80, 1.65, 0.02, 100, 85, 52, 20, 92),
('Sinosauropteryx', 'Sinosauropteryx prima', 'cretacico', 'https://example.com/dinosaurios/sinosauropteryx.jpg', 0.30, 1.07, 0.01, 35, 80, 18, 8, 95),
('Cryolophosaurus', 'Cryolophosaurus ellioti', 'jurasico', 'https://example.com/dinosaurios/cryolophosaurus.jpg', 2.50, 6.50, 0.46, 400, 68, 70, 40, 70),
('Irritator', 'Irritator challengeri', 'cretacico', 'https://example.com/dinosaurios/irritator.jpg', 2.50, 8.00, 1.00, 480, 68, 74, 44, 64),
('Deltadromeus', 'Deltadromeus agilis', 'cretacico', 'https://example.com/dinosaurios/deltadromeus.jpg', 2.00, 8.00, 1.00, 420, 88, 65, 38, 90),
('Brachiosaurus', 'Brachiosaurus altithorax', 'jurasico', 'https://example.com/dinosaurios/brachiosaurus.jpg', 9.00, 22.00, 35.00, 1000, 60, 40, 90, 20),
('Diplodocus', 'Diplodocus carnegii', 'jurasico', 'https://example.com/dinosaurios/diplodocus.jpg', 5.00, 26.00, 15.00, 950, 62, 55, 78, 28),
('Apatosaurus', 'Apatosaurus ajax', 'jurasico', 'https://example.com/dinosaurios/apatosaurus.jpg', 4.50, 22.00, 22.00, 980, 60, 50, 85, 22),
('Argentinosaurus', 'Argentinosaurus huinculensis', 'cretacico', 'https://example.com/dinosaurios/argentinosaurus.jpg', 7.00, 35.00, 80.00, 1000, 55, 45, 95, 12),
('Brontosaurus', 'Brontosaurus excelsus', 'jurasico', 'https://example.com/dinosaurios/brontosaurus.jpg', 4.60, 22.00, 15.00, 940, 60, 48, 82, 25),
('Camarasaurus', 'Camarasaurus lentus', 'jurasico', 'https://example.com/dinosaurios/camarasaurus.jpg', 5.00, 15.00, 18.00, 850, 62, 42, 78, 30),
('Patagotitan', 'Patagotitan mayorum', 'cretacico', 'https://example.com/dinosaurios/patagotitan.jpg', 6.00, 37.00, 57.00, 1000, 55, 46, 94, 12),
('Supersaurus', 'Supersaurus vivini', 'jurasico', 'https://example.com/dinosaurios/supersaurus.jpg', 10.00, 34.00, 35.00, 990, 55, 44, 90, 14),
('Sauroposeidon', 'Sauroposeidon proteles', 'cretacico', 'https://example.com/dinosaurios/sauroposeidon.jpg', 17.00, 30.00, 50.00, 980, 50, 35, 88, 15),
('Mamenchisaurus', 'Mamenchisaurus hochuanensis', 'jurasico', 'https://example.com/dinosaurios/mamenchisaurus.jpg', 6.00, 22.00, 18.00, 880, 58, 40, 76, 26),
('Amargasaurus', 'Amargasaurus cazaui', 'cretacico', 'https://example.com/dinosaurios/amargasaurus.jpg', 2.50, 10.00, 2.60, 480, 65, 38, 60, 45),
('Saltasaurus', 'Saltasaurus loricatus', 'cretacico', 'https://example.com/dinosaurios/saltasaurus.jpg', 2.50, 9.00, 7.00, 500, 62, 35, 82, 40),
('Dreadnoughtus', 'Dreadnoughtus schrani', 'cretacico', 'https://example.com/dinosaurios/dreadnoughtus.jpg', 6.00, 26.00, 59.00, 1000, 54, 42, 96, 12),
('Nigersaurus', 'Nigersaurus taqueti', 'cretacico', 'https://example.com/dinosaurios/nigersaurus.jpg', 3.00, 9.00, 4.00, 420, 65, 25, 55, 50),
('Rebbachisaurus', 'Rebbachisaurus garasbae', 'cretacico', 'https://example.com/dinosaurios/rebbachisaurus.jpg', 5.00, 20.00, 20.00, 800, 58, 40, 70, 28),
('Barosaurus', 'Barosaurus lentus', 'jurasico', 'https://example.com/dinosaurios/barosaurus.jpg', 6.00, 27.00, 20.00, 900, 60, 45, 76, 24),
('Cetiosaurus', 'Cetiosaurus oxoniensis', 'jurasico', 'https://example.com/dinosaurios/cetiosaurus.jpg', 4.00, 16.00, 11.00, 760, 60, 40, 74, 30),
('Plateosaurus', 'Plateosaurus engelhardti', 'triasico', 'https://example.com/dinosaurios/plateosaurus.jpg', 2.50, 8.00, 0.70, 360, 68, 30, 45, 55),
('Massospondylus', 'Massospondylus carinatus', 'jurasico', 'https://example.com/dinosaurios/massospondylus.jpg', 1.50, 5.00, 0.13, 200, 70, 28, 30, 62),
('Eoraptor', 'Eoraptor lunensis', 'triasico', 'https://example.com/dinosaurios/eoraptor.jpg', 0.40, 1.00, 0.01, 40, 82, 22, 8, 90),
('Titanosaurus', 'Titanosaurus indicus', 'cretacico', 'https://example.com/dinosaurios/titanosaurus.jpg', 5.00, 12.00, 13.00, 680, 58, 34, 70, 30),
('Alamosaurus', 'Alamosaurus sanjuanensis', 'cretacico', 'https://example.com/dinosaurios/alamosaurus.jpg', 7.00, 25.00, 30.00, 930, 56, 40, 86, 16),
('Isanosaurus', 'Isanosaurus attavipachi', 'triasico', 'https://example.com/dinosaurios/isanosaurus.jpg', 4.00, 15.00, 12.00, 700, 58, 36, 70, 28),
('Iguanodon', 'Iguanodon bernissartensis', 'cretacico', 'https://example.com/dinosaurios/iguanodon.jpg', 3.50, 10.00, 3.50, 620, 68, 45, 60, 50),
('Parasaurolophus', 'Parasaurolophus walkeri', 'cretacico', 'https://example.com/dinosaurios/parasaurolophus.jpg', 4.90, 10.00, 3.50, 600, 70, 40, 58, 58),
('Edmontosaurus', 'Edmontosaurus regalis', 'cretacico', 'https://example.com/dinosaurios/edmontosaurus.jpg', 3.50, 12.00, 4.00, 680, 70, 38, 62, 55),
('Maiasaura', 'Maiasaura peeblesorum', 'cretacico', 'https://example.com/dinosaurios/maiasaura.jpg', 2.50, 9.00, 3.00, 560, 66, 32, 55, 52),
('Corythosaurus', 'Corythosaurus casuarius', 'cretacico', 'https://example.com/dinosaurios/corythosaurus.jpg', 3.00, 9.00, 4.00, 570, 68, 33, 56, 56),
('Lambeosaurus', 'Lambeosaurus lambei', 'cretacico', 'https://example.com/dinosaurios/lambeosaurus.jpg', 3.50, 9.00, 4.00, 580, 68, 34, 58, 54),
('Hypsilophodon', 'Hypsilophodon foxii', 'cretacico', 'https://example.com/dinosaurios/hypsilophodon.jpg', 0.60, 2.00, 0.02, 80, 88, 12, 10, 94),
('Tenontosaurus', 'Tenontosaurus tilletti', 'cretacico', 'https://example.com/dinosaurios/tenontosaurus.jpg', 2.00, 7.00, 1.00, 400, 70, 30, 42, 66),
('Shantungosaurus', 'Shantungosaurus giganteus', 'cretacico', 'https://example.com/dinosaurios/shantungosaurus.jpg', 5.00, 15.00, 13.00, 780, 66, 36, 68, 36),
('Muttaburrasaurus', 'Muttaburrasaurus langdoni', 'cretacico', 'https://example.com/dinosaurios/muttaburrasaurus.jpg', 3.00, 8.00, 2.80, 480, 68, 34, 52, 52),
('Ouranosaurus', 'Ouranosaurus nigeriensis', 'cretacico', 'https://example.com/dinosaurios/ouranosaurus.jpg', 3.00, 8.00, 4.00, 520, 66, 38, 56, 48),
('Psittacosaurus', 'Psittacosaurus mongoliensis', 'cretacico', 'https://example.com/dinosaurios/psittacosaurus.jpg', 0.80, 2.00, 0.02, 90, 80, 14, 22, 80),
('Heterodontosaurus', 'Heterodontosaurus tucki', 'jurasico', 'https://example.com/dinosaurios/heterodontosaurus.jpg', 0.45, 1.20, 0.01, 50, 84, 18, 10, 92),
('Triceratops', 'Triceratops horridus', 'cretacico', 'https://example.com/dinosaurios/triceratops.jpg', 3.00, 9.00, 6.00, 820, 72, 80, 88, 40),
('Styracosaurus', 'Styracosaurus albertensis', 'cretacico', 'https://example.com/dinosaurios/styracosaurus.jpg', 1.80, 5.50, 2.70, 560, 72, 70, 80, 46),
('Pachyrhinosaurus', 'Pachyrhinosaurus lakustai', 'cretacico', 'https://example.com/dinosaurios/pachyrhinosaurus.jpg', 2.00, 6.00, 4.00, 640, 70, 72, 82, 42),
('Protoceratops', 'Protoceratops andrewsi', 'cretacico', 'https://example.com/dinosaurios/protoceratops.jpg', 0.60, 1.80, 0.18, 150, 78, 35, 45, 68),
('Centrosaurus', 'Centrosaurus apertus', 'cretacico', 'https://example.com/dinosaurios/centrosaurus.jpg', 1.80, 6.00, 2.50, 540, 72, 66, 76, 48),
('Torosaurus', 'Torosaurus latus', 'cretacico', 'https://example.com/dinosaurios/torosaurus.jpg', 2.70, 8.00, 6.00, 780, 70, 76, 85, 38),
('Pentaceratops', 'Pentaceratops sternbergii', 'cretacico', 'https://example.com/dinosaurios/pentaceratops.jpg', 2.50, 7.00, 5.00, 720, 70, 74, 84, 40),
('Chasmosaurus', 'Chasmosaurus belli', 'cretacico', 'https://example.com/dinosaurios/chasmosaurus.jpg', 2.00, 5.00, 2.00, 500, 72, 64, 74, 50),
('Einiosaurus', 'Einiosaurus procurvicornis', 'cretacico', 'https://example.com/dinosaurios/einiosaurus.jpg', 1.80, 6.00, 1.30, 480, 70, 62, 70, 50),
('Kosmoceratops', 'Kosmoceratops richardsoni', 'cretacico', 'https://example.com/dinosaurios/kosmoceratops.jpg', 1.80, 4.50, 1.20, 460, 70, 66, 72, 50),
('Stegosaurus', 'Stegosaurus stenops', 'jurasico', 'https://example.com/dinosaurios/stegosaurus.jpg', 4.00, 9.00, 5.00, 720, 65, 70, 82, 32),
('Ankylosaurus', 'Ankylosaurus magniventris', 'cretacico', 'https://example.com/dinosaurios/ankylosaurus.jpg', 1.70, 8.00, 6.00, 800, 62, 78, 98, 20),
('Kentrosaurus', 'Kentrosaurus airoensis', 'jurasico', 'https://example.com/dinosaurios/kentrosaurus.jpg', 1.50, 5.00, 1.00, 400, 68, 60, 65, 52),
('Euoplocephalus', 'Euoplocephalus tutus', 'cretacico', 'https://example.com/dinosaurios/euoplocephalus.jpg', 1.70, 6.00, 2.00, 560, 62, 66, 90, 28),
('Pachycephalosaurus', 'Pachycephalosaurus wyomingensis', 'cretacico', 'https://example.com/dinosaurios/pachycephalosaurus.jpg', 2.50, 4.50, 0.45, 340, 78, 72, 55, 68),
('Nodosaurus', 'Nodosaurus textilis', 'cretacico', 'https://example.com/dinosaurios/nodosaurus.jpg', 1.50, 6.00, 3.50, 520, 60, 45, 88, 26),
('Sauropelta', 'Sauropelta edwardsorum', 'cretacico', 'https://example.com/dinosaurios/sauropelta.jpg', 2.00, 7.60, 1.50, 510, 62, 55, 86, 28),
('Polacanthus', 'Polacanthus foxii', 'cretacico', 'https://example.com/dinosaurios/polacanthus.jpg', 1.50, 5.00, 1.50, 450, 62, 52, 84, 30),
('Huayangosaurus', 'Huayangosaurus taibaii', 'jurasico', 'https://example.com/dinosaurios/huayangosaurus.jpg', 1.50, 4.50, 0.70, 320, 68, 45, 60, 52),
('Scelidosaurus', 'Scelidosaurus harrisonii', 'jurasico', 'https://example.com/dinosaurios/scelidosaurus.jpg', 1.20, 4.00, 0.27, 280, 64, 30, 62, 40),
('Gastonia', 'Gastonia burgei', 'cretacico', 'https://example.com/dinosaurios/gastonia.jpg', 1.50, 5.00, 1.50, 430, 62, 50, 84, 30),
('Stegoceras', 'Stegoceras validum', 'cretacico', 'https://example.com/dinosaurios/stegoceras.jpg', 0.80, 2.00, 0.04, 110, 80, 30, 20, 84),
('Wuerhosaurus', 'Wuerhosaurus homheni', 'cretacico', 'https://example.com/dinosaurios/wuerhosaurus.jpg', 2.00, 6.00, 4.00, 600, 62, 55, 78, 30),
('Dracorex', 'Dracorex hogwartsia', 'cretacico', 'https://example.com/dinosaurios/dracorex.jpg', 1.50, 3.00, 0.30, 200, 78, 40, 24, 76);
