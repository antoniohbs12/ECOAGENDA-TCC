-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 15/10/2026 às 22:30
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
-- Estrutura para tabela `administrador`
--

CREATE TABLE `administrador` (
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `administrador`
--

INSERT INTO `administrador` (`email`) VALUES
('admin@ecoagenda.com');

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamento`
--

CREATE TABLE `agendamento` (
  `id` int(11) NOT NULL,
  `criado_por` varchar(255) DEFAULT NULL,
  `descricao` varchar(225) NOT NULL,
  `data_pedido` datetime NOT NULL DEFAULT current_timestamp(),
  `foto` varchar(255) DEFAULT NULL,
  `morador_email` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `agendamento`
--
DELIMITER $$
CREATE TRIGGER `trg_agendamento_update` AFTER UPDATE ON `agendamento` FOR EACH ROW BEGIN
    INSERT INTO agendamento_historico (
        agendamento_id,
        criado_por,
        descricao,
        data_pedido,
        foto,
        morador_email,
        status,
        comando,
        data_comando,
        usuario_logado
    )
    VALUES (
        OLD.id,
        OLD.criado_por,
        OLD.descricao,
        OLD.data_pedido,
        OLD.foto,
        OLD.morador_email,
        OLD.status,
        'UPDATE',
        NOW(),
        @usuario_logado
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamento_historico`
--

CREATE TABLE `agendamento_historico` (
  `id` int(11) NOT NULL,
  `agendamento_id` int(11) DEFAULT NULL,
  `criado_por` varchar(255) NOT NULL,
  `descricao` varchar(225) NOT NULL,
  `data_pedido` datetime NOT NULL DEFAULT current_timestamp(),
  `foto` varchar(255) DEFAULT NULL,
  `morador_email` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL,
  `comando` varchar(45) NOT NULL,
  `data_comando` datetime NOT NULL,
  `usuario_logado` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamento_morador_endereco`
--

CREATE TABLE `agendamento_morador_endereco` (
  `agendamento_id` int(11) NOT NULL,
  `endereco_id` int(11) NOT NULL,
  `morador_email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `coleta`
--

CREATE TABLE `coleta` (
  `motorista_email` varchar(255) NOT NULL,
  `agendamento_id` int(11) NOT NULL,
  `data_inicio` datetime NOT NULL,
  `data_chegada` datetime DEFAULT NULL,
  `data_finalizacao` datetime DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `endereco`
--

CREATE TABLE `endereco` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `cep` varchar(20) NOT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  `rua` varchar(150) DEFAULT NULL,
  `bairro` varchar(100) DEFAULT NULL,
  `numero` varchar(20) NOT NULL,
  `complemento` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `endereco`
--

INSERT INTO `endereco` (`id`, `email`, `cep`, `estado`, `cidade`, `rua`, `bairro`, `numero`, `complemento`) VALUES
(9, 'adrianahbdasilva@gmail.com', '82840320', 'PR', 'Curitiba', 'Rua Rio Guaporé', 'Bairro Alto', '1431', 'sobrado'),
(10, 'adrianahbdasilva@gmail.com', '83320354', 'PR', 'Pinhais', 'Rua Salgado Filho', 'Centro', '2355', 'esquina com terra rica');

-- --------------------------------------------------------

--
-- Estrutura para tabela `morador`
--

CREATE TABLE `morador` (
  `email` varchar(255) NOT NULL,
  `cpf` varchar(20) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `nascimento` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `morador`
--

INSERT INTO `morador` (`email`, `cpf`, `telefone`, `nascimento`) VALUES
('adrianahbdasilva@gmail.com', '03334413977', '41996894403', '1981-07-20');

-- --------------------------------------------------------

--
-- Estrutura para tabela `morador_endereco`
--

CREATE TABLE `morador_endereco` (
  `endereco_id` int(11) NOT NULL,
  `morador_email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `morador_endereco`
--

INSERT INTO `morador_endereco` (`endereco_id`, `morador_email`) VALUES
(9, 'adrianahbdasilva@gmail.com'),
(10, 'adrianahbdasilva@gmail.com');

-- --------------------------------------------------------

--
-- Estrutura para tabela `motorista`
--

CREATE TABLE `motorista` (
  `email` varchar(255) NOT NULL,
  `cnh` char(11) NOT NULL,
  `cpf` varchar(20) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `motorista`
--

INSERT INTO `motorista` (`email`, `cnh`, `cpf`, `telefone`, `ativo`) VALUES
('motorista@ecoagenda.com', '12345678901', '11122233344', '(41) 99999-1111', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `secretaria`
--

CREATE TABLE `secretaria` (
  `email` varchar(255) NOT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `secretaria`
--

INSERT INTO `secretaria` (`email`, `ativo`) VALUES
('secretaria@ecoagenda.com', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `secretaria_agendamento`
--

CREATE TABLE `secretaria_agendamento` (
  `secretaria_email` varchar(255) NOT NULL,
  `agendamento_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `status_agendamento`
--

CREATE TABLE `status_agendamento` (
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `status_agendamento`
--

INSERT INTO `status_agendamento` (`status`) VALUES
('A caminho'),
('Concluído'),
('Em análise'),
('Em andamento'),
('Encaminhado'),
('Suspenso');

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `email` varchar(255) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `nome` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`email`, `senha`, `nome`) VALUES
('admin@ecoagenda.com', '$2y$12$l7VXBTAehG5/w0A5gKUKru80OIQXL/Jz5.gEWox2tvPKWVTHVri.i', 'Administrador EcoAgenda'),
('adrianahbdasilva@gmail.com', '$2y$10$W7XAVwSUM3AzJmzdPSyjy.HaX/dzlqQ6OFjhxC8mBDN6HryBGgLFe', 'ADRIANA HONORIO BUENO'),
('motorista@ecoagenda.com', '$2y$12$l7VXBTAehG5/w0A5gKUKru80OIQXL/Jz5.gEWox2tvPKWVTHVri.i', 'Motorista EcoAgenda'),
('secretaria@ecoagenda.com', '$2y$12$l7VXBTAehG5/w0A5gKUKru80OIQXL/Jz5.gEWox2tvPKWVTHVri.i', 'Secretaria EcoAgenda');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `administrador`
--
ALTER TABLE `administrador`
  ADD PRIMARY KEY (`email`);

--
-- Índices de tabela `agendamento`
--
ALTER TABLE `agendamento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_agendamento_criado_por_idx` (`criado_por`),
  ADD KEY `fk_agendamento_status_agendamento1_idx` (`status`),
  ADD KEY `fk_agendamento_morador1_idx` (`morador_email`);

--
-- Índices de tabela `agendamento_historico`
--
ALTER TABLE `agendamento_historico`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `agendamento_morador_endereco`
--
ALTER TABLE `agendamento_morador_endereco`
  ADD PRIMARY KEY (`agendamento_id`,`endereco_id`,`morador_email`),
  ADD KEY `fk_agendamento_has_morador_endereco_agendamento1_idx` (`agendamento_id`),
  ADD KEY `fk_agendamento_has_morador_endereco_morador_endereco1_idx` (`endereco_id`,`morador_email`);

--
-- Índices de tabela `coleta`
--
ALTER TABLE `coleta`
  ADD PRIMARY KEY (`motorista_email`,`agendamento_id`,`data_inicio`),
  ADD KEY `fk_motorista_has_agendamento_motorista1_idx` (`motorista_email`),
  ADD KEY `fk_motorista_has_agendamento_agendamento1_idx` (`agendamento_id`);

--
-- Índices de tabela `endereco`
--
ALTER TABLE `endereco`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_endereco_morador1_idx` (`email`);

--
-- Índices de tabela `morador`
--
ALTER TABLE `morador`
  ADD PRIMARY KEY (`email`),
  ADD UNIQUE KEY `uq_morador_email` (`email`),
  ADD UNIQUE KEY `cpf_UNIQUE` (`cpf`);

--
-- Índices de tabela `morador_endereco`
--
ALTER TABLE `morador_endereco`
  ADD PRIMARY KEY (`endereco_id`,`morador_email`),
  ADD KEY `fk_endereco_has_morador_endereco1_idx` (`endereco_id`),
  ADD KEY `fk_endereco_has_morador_morador1_idx` (`morador_email`);

--
-- Índices de tabela `motorista`
--
ALTER TABLE `motorista`
  ADD PRIMARY KEY (`email`),
  ADD UNIQUE KEY `cnh_UNIQUE` (`cnh`),
  ADD UNIQUE KEY `cpf_motorista_UNIQUE` (`cpf`);

--
-- Índices de tabela `secretaria`
--
ALTER TABLE `secretaria`
  ADD PRIMARY KEY (`email`);

--
-- Índices de tabela `secretaria_agendamento`
--
ALTER TABLE `secretaria_agendamento`
  ADD PRIMARY KEY (`secretaria_email`,`agendamento_id`),
  ADD KEY `fk_secretaria_has_agendamento_secretaria1_idx` (`secretaria_email`),
  ADD KEY `fk_secretaria_has_agendamento_agendamento1_idx` (`agendamento_id`);

--
-- Índices de tabela `status_agendamento`
--
ALTER TABLE `status_agendamento`
  ADD PRIMARY KEY (`status`),
  ADD UNIQUE KEY `uq_status_nome` (`status`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `agendamento`
--
ALTER TABLE `agendamento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `agendamento_historico`
--
ALTER TABLE `agendamento_historico`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT de tabela `endereco`
--
ALTER TABLE `endereco`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `administrador`
--
ALTER TABLE `administrador`
  ADD CONSTRAINT `fk_administrador_usuario` FOREIGN KEY (`email`) REFERENCES `usuario` (`email`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `agendamento`
--
ALTER TABLE `agendamento`
  ADD CONSTRAINT `fk_agendamento_criado_por` FOREIGN KEY (`criado_por`) REFERENCES `usuario` (`email`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_agendamento_morador1` FOREIGN KEY (`morador_email`) REFERENCES `morador` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_agendamento_status_agendamento1` FOREIGN KEY (`status`) REFERENCES `status_agendamento` (`status`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `agendamento_morador_endereco`
--
ALTER TABLE `agendamento_morador_endereco`
  ADD CONSTRAINT `fk_agendamento_has_morador_endereco_agendamento1` FOREIGN KEY (`agendamento_id`) REFERENCES `agendamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_agendamento_has_morador_endereco_morador_endereco1` FOREIGN KEY (`endereco_id`,`morador_email`) REFERENCES `morador_endereco` (`endereco_id`, `morador_email`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `coleta`
--
ALTER TABLE `coleta`
  ADD CONSTRAINT `fk_motorista_has_agendamento_agendamento1` FOREIGN KEY (`agendamento_id`) REFERENCES `agendamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_motorista_has_agendamento_motorista1` FOREIGN KEY (`motorista_email`) REFERENCES `motorista` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `endereco`
--
ALTER TABLE `endereco`
  ADD CONSTRAINT `fk_endereco_morador1` FOREIGN KEY (`email`) REFERENCES `morador` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `morador`
--
ALTER TABLE `morador`
  ADD CONSTRAINT `fk_morador_usuario` FOREIGN KEY (`email`) REFERENCES `usuario` (`email`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `morador_endereco`
--
ALTER TABLE `morador_endereco`
  ADD CONSTRAINT `fk_endereco_has_morador_endereco1` FOREIGN KEY (`endereco_id`) REFERENCES `endereco` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_endereco_has_morador_morador1` FOREIGN KEY (`morador_email`) REFERENCES `morador` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `motorista`
--
ALTER TABLE `motorista`
  ADD CONSTRAINT `fk_motorista_usuario1` FOREIGN KEY (`email`) REFERENCES `usuario` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Restrições para tabelas `secretaria`
--
ALTER TABLE `secretaria`
  ADD CONSTRAINT `fk_secretaria_usuario` FOREIGN KEY (`email`) REFERENCES `usuario` (`email`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `secretaria_agendamento`
--
ALTER TABLE `secretaria_agendamento`
  ADD CONSTRAINT `fk_secretaria_has_agendamento_agendamento1` FOREIGN KEY (`agendamento_id`) REFERENCES `agendamento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_secretaria_has_agendamento_secretaria1` FOREIGN KEY (`secretaria_email`) REFERENCES `secretaria` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
