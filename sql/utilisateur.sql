-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Sam 11 Mars 2017 à 23:55
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `gsb`
--

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE IF NOT EXISTS `utilisateur` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) NOT NULL,
  `mdp` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `telephone_interne` int(3) DEFAULT NULL,
  `adresse` varchar(255) NOT NULL,
  `commune_id` int(11) DEFAULT NULL,
  `date_embauche` date DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uti_login` (`login`),
  UNIQUE KEY `uti_email` (`email`),
  KEY `uti_role` (`role_id`),
  KEY `uti_commune` (`commune_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

--
-- Contenu de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `login`, `mdp`, `role_id`, `email`, `token`, `nom`, `prenom`, `telephone`, `telephone_interne`, `adresse`, `commune_id`, `date_embauche`, `image`) VALUES
(1, 'bruno', '$2y$10$GHEZOs6mcWHRjT4D3aljvOqH0K1JA7QPYqM5LP9Y3BRImkDZA9Jgm', 2, 'avinint@hotmail.com', '', 'Avinint', 'Bruno', '0672785124', 457, '186 rue de l''ouest', 32194, '2003-09-01', '5899e60240a64.jpg'),
(2, 'shinta', '$2y$10$bqrrnbOB2yeBM6vETsUPmuvZ9nPubdvJQxXB8zyqgKuElmWbfLF5u', 2, 'shinta42@hotmail.com', '', 'Zeghouani', 'Haitem', '0628571534', 555, '1 rue du 22 octobre', 32252, '2010-07-01', '5899e616480a1.jpg'),
(3, 'tom', '$2y$10$79fUByc1newAgf.7ApUkIORlMVUfMKl.S/lwpd7y0tRZ6kK38Y6ye', 2, 'thomas.duport1@gmail.com', '', 'Duport', 'Thomas', '0622574897', 0, 'Les Sauvageons', 32532, '2016-04-01', '5899e66fc06c3.jpg'),
(4, 'kim', '$2y$10$cFRypF3e67JgNtRgpLUe4epDaEtH4jgzPaijzytsIpiRfjbrK7r7C', 3, 'kim42.gsb@gmail.com', '', 'Chabannes', 'Kim', '0477514257', 0, '52, rue de la guenille', 32252, '2016-09-01', NULL),
(5, 'lvillachane', '$2y$10$7dkZ.WHawp4mDckkUjxpTeKnmDsse4vnxcxKthtK1qPd94EZs5FbG', 3, 'lvillachane@gsb.fr', '', 'Villechalane', 'Louis', '0127541728', 0, '8 rue des Charmes', 33349, '2005-12-21', NULL),
(6, 'dandre', '$2y$10$9g6L8L4dN9dKIWJ0sbTs/euDDnkg5V2QFCAbPz5bQuDE4sCRAQS8K', 3, 'dandre@gsb.fr', '', 'Andre', 'David', '0112345644', 0, '1 rue Petit', 33509, '1998-11-23', NULL),
(7, 'cbedos', '$2y$10$WQrTPl4VJWXAYR4DgR4M/Ov2Q61nnTwVPf9nHs12b/0Q3gdl4sX.6', 3, 'cbedos@gsb.fr', '', 'Bedos', 'Christian', '0723545789', 0, '1 rue Peranud', 33678, '1995-01-12', NULL),
(8, 'ltusseau', '$2y$10$m7m9dmXxy5hUbn.bMAq6Fu859d56r2RAdpfvRGbhHZfK7uyy.L8tu', 3, 'ltusseau@gsb.fr', '', 'Tusseau', 'Louis', '0174742525', 0, '22 rue des Ternes', 33636, '2000-05-01', NULL),
(9, 'pbentot', '$2y$10$5jjIvlQxpqIiozXeYIJ.mOUUGMrdVArqygj231rMI0gNSR9jog3hC', 3, 'pbentot@gsb.fr', '', 'Bentot', 'Pascal', '0985745123', 0, '11 allée des Cerises', 48212, '1992-07-09', NULL),
(11, 'fbunisset', '$2y$10$5VWokr0xkcAbNQa5hJfRm.llrIx3rHwz5MhkJJrIQuh6vA7f9SvjW', 3, 'fbunisset@gsb.fr', '', 'Bunisset', 'Francis', '0745681239', 0, '10 rue des Perles', 52206, '1987-10-21', NULL),
(12, 'dbunisset', '$2y$10$NCABkHDRjDzodVXqGVjqw.syi6lL8qPEu95Zp6.mndrlkimfnb/YS', 3, 'dbunisset@gsb.fr', '', 'Bunisset', 'Denise', '+654197588', 0, '23 rue Manin', 46683, '2010-12-05', NULL),
(13, 'bcacheux', '$2y$10$zrcCI2i50OGRT7t73CSzIeVuc1KyxEKeGdXyehZUy8i97Tftc0knu', 3, 'bcacheux@gsb.fr', '', 'Cacheux', 'Bernard', '+725684331', 0, '114 rue Blanche', 46681, '2009-11-12', NULL),
(14, 'ecadic', '$2y$10$MIca3.fCmGBRDc1jarak1eTOUgEGOXDrz0FjkAsWT36rwZ5El6L3S', 3, 'ecadic@gsb.fr', '', 'Cadic', 'Eric', '0175849020', 0, '123 avenue de la République', 46675, '2008-09-23', NULL),
(15, 'ccharoze', '$2y$10$o9Xzp5tQJh8t8QhdieUcfuUs4oFL19mwR1RXFtHamokSibPOHAzLa', 3, 'ccharoze@gsb.fr', '', 'Charoze', 'Catherine', '0144728193', 0, '100 rue Petit', 46683, '2005-11-12', NULL),
(16, 'cclepkens', '$2y$10$cLmrEsNW7lQvRy46SHvwyOJ.NBqXwg2tC.S/5InBGM9UD67DkPTPC', 3, 'cclepkens@gsb.fr', '', 'Clepkens', 'Christophe', '0150307721', 0, '12 allée des Anges', 52212, '2003-08-11', NULL),
(17, 'vcottin', '$2y$10$sbMMWvJqjBqVDwpg5eoE.OzJXRzCSGQMhsfxG.ehcNN11ENGphZ.y', 3, 'vcottin@gsb.fr', '', 'Cottin', 'Vincenne', '0672337457', 0, '36 rue Des Roches', 52206, '2001-11-18', NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
