-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 07/08/2026 às 04:52
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `ecoagenda`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamento`
--

CREATE TABLE `agendamento` (
  `ID` int(11) NOT NULL,
  `Horario` time NOT NULL,
  `Data` date NOT NULL,
  `Descricao` varchar(225) NOT NULL,
  `Endereco_Rua` varchar(45) NOT NULL,
  `Endereco_N` int(11) NOT NULL,
  `Endereco_Bairro` varchar(45) NOT NULL,
  `Endereco_CEP` varchar(45) NOT NULL,
  `Morador_CPF` char(16) NOT NULL,
  `status_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `agendamento`
--

INSERT INTO `agendamento` (`ID`, `Horario`, `Data`, `Descricao`, `Endereco_Rua`, `Endereco_N`, `Endereco_Bairro`, `Endereco_CEP`, `Morador_CPF`, `status_id`) VALUES
(1, '14:30:00', '2024-09-06', 'Coleta de móveis', 'Rua A', 123, 'Centro', '98765-890', '123.456.789-00', NULL);

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `agendamento`
--
ALTER TABLE `agendamento`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Morador_CPF` (`Morador_CPF`),
  ADD KEY `fk_status` (`status_id`);

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `agendamento`
--
ALTER TABLE `agendamento`
  ADD CONSTRAINT `fk_status` FOREIGN KEY (`status_id`) REFERENCES `status_agendamento` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
