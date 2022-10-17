-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.12-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win32
-- HeidiSQL Versão:              10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para wk
CREATE DATABASE IF NOT EXISTS `wk` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `wk`;

-- Copiando estrutura para tabela wk.endereco
CREATE TABLE IF NOT EXISTS `endereco` (
  `idendereco` bigint(20) NOT NULL,
  `idpessoa` bigint(20) NOT NULL,
  `dscep` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`idendereco`),
  KEY `endereco_idpessoa` (`idpessoa`),
  CONSTRAINT `endereco_fk_pessoa` FOREIGN KEY (`idpessoa`) REFERENCES `pessoa` (`idpessoa`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela wk.endereco_integracao
CREATE TABLE IF NOT EXISTS `endereco_integracao` (
  `idendereco` bigint(20) NOT NULL,
  `dsuf` varchar(50) DEFAULT NULL,
  `nmcidade` varchar(100) DEFAULT NULL,
  `nmlogradouro` varchar(50) DEFAULT NULL,
  `dscomplemento` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idendereco`),
  CONSTRAINT `enderecointegracao_fk_endereco` FOREIGN KEY (`idendereco`) REFERENCES `endereco` (`idendereco`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela wk.pessoa
CREATE TABLE IF NOT EXISTS `pessoa` (
  `idpessoa` bigint(20) NOT NULL,
  `flnatureza` int(11) NOT NULL,
  `dsdocumento` varchar(20) NOT NULL,
  `nmprimeiro` varchar(100) NOT NULL,
  `nmsegundo` varchar(100) NOT NULL,
  `dtregistro` date DEFAULT current_timestamp(),
  PRIMARY KEY (`idpessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
