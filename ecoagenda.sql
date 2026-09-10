-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 10/09/2026 às 14:17
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
  `descricao` varchar(225) NOT NULL,
  `data_pedido` datetime NOT NULL DEFAULT current_timestamp(),
  `data_realizacao` date DEFAULT NULL,
  `horario_realizacao` time DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `foto_motorista` varchar(255) DEFAULT NULL,
  `endereco` varchar(500) NOT NULL,
  `morador_cpf` varchar(20) NOT NULL,
  `secretaria_email` varchar(255) DEFAULT NULL,
  `motorista_id` int(11) DEFAULT NULL,
  `status_id` int(11) NOT NULL DEFAULT 1,
  `criado_por` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `agendamento`
--

INSERT INTO `agendamento` (`id`, `descricao`, `data_pedido`, `data_realizacao`, `horario_realizacao`, `foto`, `foto_motorista`, `endereco`, `morador_cpf`, `secretaria_email`, `motorista_id`, `status_id`, `criado_por`) VALUES
(9, 'Tipo: madeira | Descrição: muita madeira', '2026-09-08 22:38:17', NULL, NULL, 'uploads/residuo_6aa0b8891f8ce3.41458151.jpg', NULL, 'Rua José Linhares, nº 112, casa com garagem, Jardim Amélia, Pinhais - PR, CEP: 83330-060', '100.766.749-40', 'secretaria@ecoagenda.com', NULL, 5, 'antoniohbdasilva@gmail.com'),
(10, 'Tipo: galhos | Quantidade aproximada: 15 galhos | Descrição: galhos jogados na rua', '2026-09-09 21:22:53', NULL, NULL, 'uploads/residuo_6aa1f85d5e25c7.27849432.webp', 'uploads/motorista_6aa1f8da8b0648.10747086.webp', 'Rua José Linhares, nº 112, casa com garagem, Jardim Amélia, Pinhais - PR, CEP: 83330-060', '100.766.749-40', 'secretaria@ecoagenda.com', 1, 4, 'antoniohbdasilva@gmail.com'),
(11, 'Tipo: galhos | Quantidade aproximada: 20 galhos | Descrição: galhos espalhados', '2026-09-09 21:31:16', '2026-09-09', '21:33:53', 'uploads/residuo_6aa1fa54ef11f8.58558682.webp', 'uploads/motorista_6aa1faf1d8f8f0.28544718.webp', 'Rua Salgado Filho, nº 67, casa com portao preto, Pineville, Pinhais - PR, CEP: 83320-332', '100.766.749-40', 'secretaria@ecoagenda.com', 1, 4, 'antoniohbdasilva@gmail.com'),
(12, 'Tipo: madeira | Quantidade aproximada: um caminhao cheio | Descrição: mta madeirinha', '2026-09-09 22:09:46', NULL, NULL, 'uploads/residuo_6aa2035a7ac468.74860202.webp', NULL, 'Rua Wanda dos Santos Mallmann, nº 67, apto, Centro, Pinhais - PR, CEP: 83323-400', '100.766.749-40', NULL, NULL, 1, 'antoniohbdasilva@gmail.com');

-- --------------------------------------------------------

--
-- Estrutura para tabela `endereco`
--

CREATE TABLE `endereco` (
  `id` int(11) NOT NULL,
  `morador_cpf` varchar(20) NOT NULL,
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

INSERT INTO `endereco` (`id`, `morador_cpf`, `cep`, `estado`, `cidade`, `rua`, `bairro`, `numero`, `complemento`) VALUES
(1, '100.766.749-40', '82840320', 'PR', 'Curitiba', 'Rua Rio Guaporé', 'Bairro Alto', '1431', 'sobrado');

-- --------------------------------------------------------

--
-- Estrutura para tabela `historico_agendamento`
--

CREATE TABLE `historico_agendamento` (
  `id` int(11) NOT NULL,
  `data_hora` datetime NOT NULL DEFAULT current_timestamp(),
  `cpf_morador` varchar(20) NOT NULL,
  `agendamento_id` int(11) NOT NULL,
  `usuario_email` varchar(255) DEFAULT NULL,
  `acao` varchar(100) NOT NULL,
  `campo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `historico_agendamento`
--

INSERT INTO `historico_agendamento` (`id`, `data_hora`, `cpf_morador`, `agendamento_id`, `usuario_email`, `acao`, `campo`) VALUES
(1, '2026-09-08 22:38:17', '100.766.749-40', 9, 'antoniohbdasilva@gmail.com', 'Pedido criado', NULL),
(2, '2026-09-09 20:17:15', '100.766.749-40', 9, 'secretaria@ecoagenda.com', 'Pedido encaminhado ao motorista', 'motorista_id / status_id'),
(3, '2026-09-09 20:18:45', '100.766.749-40', 9, 'secretaria@ecoagenda.com', 'Pedido cancelado pela Secretaria', 'status'),
(4, '2026-09-09 21:22:53', '100.766.749-40', 10, 'antoniohbdasilva@gmail.com', 'Pedido criado', NULL),
(5, '2026-09-09 21:24:05', '100.766.749-40', 10, 'secretaria@ecoagenda.com', 'Pedido encaminhado ao motorista', 'motorista_id / status_id'),
(6, '2026-09-09 21:24:39', '100.766.749-40', 10, 'motorista@ecoagenda.com', 'Coleta iniciada pelo Motorista', 'status_id'),
(7, '2026-09-09 21:24:58', '100.766.749-40', 10, 'motorista@ecoagenda.com', 'Coleta concluída pelo Motorista', 'status_id, foto_motorista'),
(8, '2026-09-09 21:31:16', '100.766.749-40', 11, 'antoniohbdasilva@gmail.com', 'Pedido criado', NULL),
(9, '2026-09-09 21:32:29', '100.766.749-40', 11, 'secretaria@ecoagenda.com', 'Pedido encaminhado ao motorista', 'motorista_id / status_id'),
(10, '2026-09-09 21:33:41', '100.766.749-40', 11, 'motorista@ecoagenda.com', 'Coleta iniciada pelo Motorista', 'status_id'),
(11, '2026-09-09 21:33:53', '100.766.749-40', 11, 'motorista@ecoagenda.com', 'Coleta concluída pelo Motorista', 'status_id, foto_motorista'),
(12, '2026-09-09 22:09:46', '100.766.749-40', 12, 'antoniohbdasilva@gmail.com', 'Pedido criado', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `morador`
--

CREATE TABLE `morador` (
  `cpf` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `nascimento` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `morador`
--

INSERT INTO `morador` (`cpf`, `email`, `telefone`, `nascimento`) VALUES
('100.766.749-40', 'antoniohbdasilva@gmail.com', '41995686212', '2008-03-08');

-- --------------------------------------------------------

--
-- Estrutura para tabela `motorista`
--

CREATE TABLE `motorista` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `cpf` varchar(20) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `motorista`
--

INSERT INTO `motorista` (`id`, `email`, `cpf`, `telefone`, `ativo`) VALUES
(1, 'motorista@ecoagenda.com', '11111111111', '(41) 99999-1111', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `secretaria`
--

CREATE TABLE `secretaria` (
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `secretaria`
--

INSERT INTO `secretaria` (`email`) VALUES
('secretaria@ecoagenda.com');

-- --------------------------------------------------------

--
-- Estrutura para tabela `status_agendamento`
--

CREATE TABLE `status_agendamento` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `status_agendamento`
--

INSERT INTO `status_agendamento` (`id`, `nome`) VALUES
(5, 'Cancelado'),
(4, 'Concluído'),
(2, 'Confirmado'),
(3, 'Em andamento'),
(1, 'Pendente');

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `email` varchar(255) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `perfil` varchar(20) NOT NULL
) ;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`email`, `senha`, `nome`, `perfil`) VALUES
('admin@ecoagenda.com', '$2y$12$LhKQ8Q8udwq5ZEHshBZu3OpU53665eYLErjv7YLak5Afr/MQJTPF.', 'Administrador EcoAgenda', 'administrador'),
('antoniohbdasilva@gmail.com', '$2y$10$n2/eN8TjaJvmPOs9LulIdOjvwRKnDt2QhTpGKIsM0etUcysfNZhs6', 'antonio honorio', 'morador'),
('motorista@ecoagenda.com', '$2y$12$LhKQ8Q8udwq5ZEHshBZu3OpU53665eYLErjv7YLak5Afr/MQJTPF.', 'Motorista EcoAgenda', 'motorista'),
('secretaria@ecoagenda.com', '$2y$12$LhKQ8Q8udwq5ZEHshBZu3OpU53665eYLErjv7YLak5Afr/MQJTPF.', 'Secretaria EcoAgenda', 'secretaria');

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
  ADD KEY `fk_agendamento_morador` (`morador_cpf`),
  ADD KEY `fk_agendamento_secretaria` (`secretaria_email`),
  ADD KEY `fk_agendamento_motorista` (`motorista_id`),
  ADD KEY `fk_agendamento_status` (`status_id`),
  ADD KEY `fk_agendamento_criado_por` (`criado_por`);

--
-- Índices de tabela `endereco`
--
ALTER TABLE `endereco`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_endereco_morador` (`morador_cpf`);

--
-- Índices de tabela `historico_agendamento`
--
ALTER TABLE `historico_agendamento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_historico_morador` (`cpf_morador`),
  ADD KEY `fk_historico_agendamento` (`agendamento_id`),
  ADD KEY `fk_historico_usuario` (`usuario_email`);

--
-- Índices de tabela `morador`
--
ALTER TABLE `morador`
  ADD PRIMARY KEY (`cpf`),
  ADD UNIQUE KEY `uq_morador_email` (`email`);

--
-- Índices de tabela `motorista`
--
ALTER TABLE `motorista`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_motorista_email` (`email`);

--
-- Índices de tabela `secretaria`
--
ALTER TABLE `secretaria`
  ADD PRIMARY KEY (`email`);

--
-- Índices de tabela `status_agendamento`
--
ALTER TABLE `status_agendamento`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_status_nome` (`nome`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `endereco`
--
ALTER TABLE `endereco`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `historico_agendamento`
--
ALTER TABLE `historico_agendamento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `motorista`
--
ALTER TABLE `motorista`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `status_agendamento`
--
ALTER TABLE `status_agendamento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  ADD CONSTRAINT `fk_agendamento_morador` FOREIGN KEY (`morador_cpf`) REFERENCES `morador` (`cpf`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_agendamento_motorista` FOREIGN KEY (`motorista_id`) REFERENCES `motorista` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_agendamento_secretaria` FOREIGN KEY (`secretaria_email`) REFERENCES `secretaria` (`email`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_agendamento_status` FOREIGN KEY (`status_id`) REFERENCES `status_agendamento` (`id`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `endereco`
--
ALTER TABLE `endereco`
  ADD CONSTRAINT `fk_endereco_morador` FOREIGN KEY (`morador_cpf`) REFERENCES `morador` (`cpf`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `historico_agendamento`
--
ALTER TABLE `historico_agendamento`
  ADD CONSTRAINT `fk_historico_agendamento` FOREIGN KEY (`agendamento_id`) REFERENCES `agendamento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_historico_morador` FOREIGN KEY (`cpf_morador`) REFERENCES `morador` (`cpf`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_historico_usuario` FOREIGN KEY (`usuario_email`) REFERENCES `usuario` (`email`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Restrições para tabelas `morador`
--
ALTER TABLE `morador`
  ADD CONSTRAINT `fk_morador_usuario` FOREIGN KEY (`email`) REFERENCES `usuario` (`email`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `motorista`
--
ALTER TABLE `motorista`
  ADD CONSTRAINT `fk_motorista_usuario` FOREIGN KEY (`email`) REFERENCES `usuario` (`email`) ON UPDATE CASCADE;

--
-- Restrições para tabelas `secretaria`
--
ALTER TABLE `secretaria`
  ADD CONSTRAINT `fk_secretaria_usuario` FOREIGN KEY (`email`) REFERENCES `usuario` (`email`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
