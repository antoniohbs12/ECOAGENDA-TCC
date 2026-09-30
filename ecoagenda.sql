-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 30/09/2026 às 04:55
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
-- Despejando dados para a tabela `agendamento`
--

INSERT INTO `agendamento` (`id`, `criado_por`, `descricao`, `data_pedido`, `foto`, `morador_email`, `status`) VALUES
(1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Concluído'),
(2, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: galhos | Quantidade aproximada: 13 galhos | Descrição: asdasdasdas', '2026-09-18 22:51:38', 'uploads/morador_6aadeaaac97ab1.39015246.jpg', 'antoniohbdasilva2@gmail.com', 'Em andamento'),
(3, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: armario de madeira | Quantidade aproximada: 1 armario | Descrição: peças desmontadas de madeira de um armario', '2026-09-19 01:26:37', 'uploads/morador_6aae0efd234539.40643675.jpg', 'antoniohbdasilva2@gmail.com', 'Concluído'),
(4, 'vitinlegal@gmail.com', 'Tipo de resíduo: madeira (pau) | Quantidade aproximada: 3 paus | Descrição: muito pau', '2026-09-22 19:54:13', 'uploads/morador_6ab30715750b34.02704664.jpg', 'vitinlegal@gmail.com', 'Concluído'),
(5, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: 2 moveis | Descrição: moveis de madeira', '2026-09-26 18:56:36', 'uploads/morador_6ab83f9476df49.01906560.webp', 'antoniohbdasilva2@gmail.com', 'Concluído'),
(6, 'vitinlegal@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: muitos moveis | Descrição: muitos moveis de madeira', '2026-09-28 18:49:37', 'uploads/morador_6abae0f186d893.24242621.jpg', 'vitinlegal@gmail.com', 'Em análise'),
(7, 'vivianjos@gmail.com', 'Tipo de resíduo: madeira | Quantidade aproximada: muita madeira | Descrição: bastante madeira', '2026-09-29 09:35:53', 'uploads/morador_6abbb0a94074d3.54264948.png', 'vivianjos@gmail.com', 'Em análise'),
(8, 'vivianjos@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: 1 metro cubico | Descrição: muitos moveis de madeira', '2026-09-29 17:37:20', 'uploads/morador_6abc21804bc6a8.21962931.png', 'vivianjos@gmail.com', 'Em análise'),
(9, 'vivianjos@gmail.com', 'Tipo de resíduo: teste | Quantidade aproximada: teste | Descrição: teste', '2026-09-29 17:37:58', NULL, 'vivianjos@gmail.com', 'Em análise'),
(10, 'vivianjos@gmail.com', 'Tipo de resíduo: teste 2 | Quantidade aproximada: teste 2 | Descrição: teste', '2026-09-29 17:42:17', NULL, 'vivianjos@gmail.com', 'Encaminhado'),
(11, 'vivianjos@gmail.com', 'Tipo de resíduo: teste 3 | Quantidade aproximada: teste 3 | Descrição: teste 3', '2026-09-29 17:46:32', NULL, 'vivianjos@gmail.com', 'Concluído');

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

--
-- Despejando dados para a tabela `agendamento_historico`
--

INSERT INTO `agendamento_historico` (`id`, `agendamento_id`, `criado_por`, `descricao`, `data_pedido`, `foto`, `morador_email`, `status`, `comando`, `data_comando`, `usuario_logado`) VALUES
(1, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Em análise', 'UPDATE', '2026-09-18 22:44:05', 'secretaria@ecoagenda.com'),
(2, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Em análise', 'PEDIDO_EDITADO', '2026-09-18 22:44:05', 'secretaria@ecoagenda.com'),
(3, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Em análise', 'UPDATE', '2026-09-18 22:44:26', 'secretaria@ecoagenda.com'),
(4, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Encaminhado', 'PEDIDO_ENCAMINHADO', '2026-09-18 22:44:26', 'secretaria@ecoagenda.com'),
(5, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Encaminhado', 'UPDATE', '2026-09-18 22:45:45', 'motorista@ecoagenda.com'),
(6, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Em andamento', 'COLETA_INICIADA', '2026-09-18 22:45:45', 'motorista@ecoagenda.com'),
(7, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Em andamento', 'UPDATE', '2026-09-18 22:46:17', 'motorista@ecoagenda.com'),
(8, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Concluído', 'COLETA_CONCLUIDA', '2026-09-18 22:46:17', 'motorista@ecoagenda.com'),
(9, 3, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: armario de madeira | Quantidade aproximada: 1 armario | Descrição: peças desmontadas de madeira de um armario', '2026-09-19 01:26:37', 'uploads/morador_6aae0efd234539.40643675.jpg', 'antoniohbdasilva2@gmail.com', 'Em análise', 'UPDATE', '2026-09-19 01:29:28', 'secretaria@ecoagenda.com'),
(10, 3, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: armario de madeira | Quantidade aproximada: 1 armario | Descrição: peças desmontadas de madeira de um armario', '2026-09-19 01:26:37', 'uploads/morador_6aae0efd234539.40643675.jpg', 'antoniohbdasilva2@gmail.com', 'Encaminhado', 'PEDIDO_ENCAMINHADO', '2026-09-19 01:29:28', 'secretaria@ecoagenda.com'),
(11, 2, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: galhos | Quantidade aproximada: 13 galhos | Descrição: asdasdasdas', '2026-09-18 22:51:38', 'uploads/morador_6aadeaaac97ab1.39015246.jpg', 'antoniohbdasilva2@gmail.com', 'Em análise', 'UPDATE', '2026-09-20 19:23:06', 'secretaria@ecoagenda.com'),
(12, 4, 'vitinlegal@gmail.com', 'Tipo de resíduo: madeira (pau) | Quantidade aproximada: 3 paus | Descrição: muito pau', '2026-09-22 19:54:13', 'uploads/morador_6ab30715750b34.02704664.jpg', 'vitinlegal@gmail.com', 'Em análise', 'UPDATE', '2026-09-22 19:56:05', 'secretaria@ecoagenda.com'),
(13, 4, 'vitinlegal@gmail.com', 'Tipo de resíduo: madeira (pau) | Quantidade aproximada: 3 paus | Descrição: muito pau', '2026-09-22 19:54:13', 'uploads/morador_6ab30715750b34.02704664.jpg', 'vitinlegal@gmail.com', 'Encaminhado', 'UPDATE', '2026-09-22 20:05:08', 'motorista@ecoagenda.com'),
(14, 4, 'vitinlegal@gmail.com', 'Tipo de resíduo: madeira (pau) | Quantidade aproximada: 3 paus | Descrição: muito pau', '2026-09-22 19:54:13', 'uploads/morador_6ab30715750b34.02704664.jpg', 'vitinlegal@gmail.com', 'Em andamento', 'UPDATE', '2026-09-22 20:05:40', 'motorista@ecoagenda.com'),
(15, 2, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: galhos | Quantidade aproximada: 13 galhos | Descrição: asdasdasdas', '2026-09-18 22:51:38', 'uploads/morador_6aadeaaac97ab1.39015246.jpg', 'antoniohbdasilva2@gmail.com', 'Em análise', 'UPDATE', '2026-09-26 18:30:46', 'SISTEMA_MIGRACAO_STATUS'),
(16, 3, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: armario de madeira | Quantidade aproximada: 1 armario | Descrição: peças desmontadas de madeira de um armario', '2026-09-19 01:26:37', 'uploads/morador_6aae0efd234539.40643675.jpg', 'antoniohbdasilva2@gmail.com', 'Encaminhado', 'UPDATE', '2026-09-26 18:30:46', 'SISTEMA_MIGRACAO_STATUS'),
(17, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Concluído', 'UPDATE', '2026-09-26 18:30:47', 'SISTEMA_MIGRACAO_STATUS'),
(18, 4, 'vitinlegal@gmail.com', 'Tipo de resíduo: madeira (pau) | Quantidade aproximada: 3 paus | Descrição: muito pau', '2026-09-22 19:54:13', 'uploads/morador_6ab30715750b34.02704664.jpg', 'vitinlegal@gmail.com', 'Concluído', 'UPDATE', '2026-09-26 18:30:47', 'SISTEMA_MIGRACAO_STATUS'),
(19, 3, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: armario de madeira | Quantidade aproximada: 1 armario | Descrição: peças desmontadas de madeira de um armario', '2026-09-19 01:26:37', 'uploads/morador_6aae0efd234539.40643675.jpg', 'antoniohbdasilva2@gmail.com', 'Encaminhado', 'UPDATE', '2026-09-26 18:44:09', 'motorista@ecoagenda.com'),
(20, 3, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: armario de madeira | Quantidade aproximada: 1 armario | Descrição: peças desmontadas de madeira de um armario', '2026-09-19 01:26:37', 'uploads/morador_6aae0efd234539.40643675.jpg', 'antoniohbdasilva2@gmail.com', 'Em andamento', 'UPDATE', '2026-09-26 18:44:18', 'motorista@ecoagenda.com'),
(21, 3, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: armario de madeira | Quantidade aproximada: 1 armario | Descrição: peças desmontadas de madeira de um armario', '2026-09-19 01:26:37', 'uploads/morador_6aae0efd234539.40643675.jpg', 'antoniohbdasilva2@gmail.com', 'Em andamento', 'UPDATE', '2026-09-26 18:44:30', 'motorista@ecoagenda.com'),
(22, 5, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: 2 moveis | Descrição: moveis de madeira', '2026-09-26 18:56:36', 'uploads/morador_6ab83f9476df49.01906560.webp', 'antoniohbdasilva2@gmail.com', 'Em análise', 'UPDATE', '2026-09-26 19:09:25', 'secretaria@ecoagenda.com'),
(23, 5, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: 2 moveis | Descrição: moveis de madeira', '2026-09-26 18:56:36', 'uploads/morador_6ab83f9476df49.01906560.webp', 'antoniohbdasilva2@gmail.com', 'Encaminhado', 'UPDATE', '2026-09-29 10:01:10', 'motorista@ecoagenda.com'),
(24, 5, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: 2 moveis | Descrição: moveis de madeira', '2026-09-26 18:56:36', 'uploads/morador_6ab83f9476df49.01906560.webp', 'antoniohbdasilva2@gmail.com', 'Em andamento', 'UPDATE', '2026-09-29 10:01:24', 'motorista@ecoagenda.com'),
(25, 5, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: 2 moveis | Descrição: moveis de madeira', '2026-09-26 18:56:36', 'uploads/morador_6ab83f9476df49.01906560.webp', 'antoniohbdasilva2@gmail.com', 'Em andamento', 'UPDATE', '2026-09-29 10:01:32', 'motorista@ecoagenda.com'),
(26, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Concluído', 'UPDATE', '2026-09-29 15:33:53', 'MIGRACAO_STATUS_ECOAGENDA'),
(27, 2, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: galhos | Quantidade aproximada: 13 galhos | Descrição: asdasdasdas', '2026-09-18 22:51:38', 'uploads/morador_6aadeaaac97ab1.39015246.jpg', 'antoniohbdasilva2@gmail.com', 'Em análise', 'UPDATE', '2026-09-29 15:33:53', 'MIGRACAO_STATUS_ECOAGENDA'),
(28, 3, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: armario de madeira | Quantidade aproximada: 1 armario | Descrição: peças desmontadas de madeira de um armario', '2026-09-19 01:26:37', 'uploads/morador_6aae0efd234539.40643675.jpg', 'antoniohbdasilva2@gmail.com', 'Concluído', 'UPDATE', '2026-09-29 15:33:53', 'MIGRACAO_STATUS_ECOAGENDA'),
(29, 4, 'vitinlegal@gmail.com', 'Tipo de resíduo: madeira (pau) | Quantidade aproximada: 3 paus | Descrição: muito pau', '2026-09-22 19:54:13', 'uploads/morador_6ab30715750b34.02704664.jpg', 'vitinlegal@gmail.com', 'Concluído', 'UPDATE', '2026-09-29 15:33:53', 'MIGRACAO_STATUS_ECOAGENDA'),
(30, 5, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: 2 moveis | Descrição: moveis de madeira', '2026-09-26 18:56:36', 'uploads/morador_6ab83f9476df49.01906560.webp', 'antoniohbdasilva2@gmail.com', 'Concluído', 'UPDATE', '2026-09-29 15:33:53', 'MIGRACAO_STATUS_ECOAGENDA'),
(31, 6, 'vitinlegal@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: muitos moveis | Descrição: muitos moveis de madeira', '2026-09-28 18:49:37', 'uploads/morador_6abae0f186d893.24242621.jpg', 'vitinlegal@gmail.com', 'Em análise', 'UPDATE', '2026-09-29 15:33:53', 'MIGRACAO_STATUS_ECOAGENDA'),
(32, 7, 'vivianjos@gmail.com', 'Tipo de resíduo: madeira | Quantidade aproximada: muita madeira | Descrição: bastante madeira', '2026-09-29 09:35:53', 'uploads/morador_6abbb0a94074d3.54264948.png', 'vivianjos@gmail.com', 'Em análise', 'UPDATE', '2026-09-29 15:33:53', 'MIGRACAO_STATUS_ECOAGENDA'),
(33, 1, 'victorm10upload@gmail.com', 'Tipo de resíduo: muita madeira | Quantidade aproximada: 1 madeira | Descrição: toras de madeira', '2026-09-18 22:43:17', 'uploads/morador_6aade8b5732203.36680789.webp', 'victorm10upload@gmail.com', 'Concluído', 'UPDATE', '2026-09-29 12:37:50', NULL),
(34, 2, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: galhos | Quantidade aproximada: 13 galhos | Descrição: asdasdasdas', '2026-09-18 22:51:38', 'uploads/morador_6aadeaaac97ab1.39015246.jpg', 'antoniohbdasilva2@gmail.com', 'Em análise', 'UPDATE', '2026-09-29 12:37:50', NULL),
(35, 3, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: armario de madeira | Quantidade aproximada: 1 armario | Descrição: peças desmontadas de madeira de um armario', '2026-09-19 01:26:37', 'uploads/morador_6aae0efd234539.40643675.jpg', 'antoniohbdasilva2@gmail.com', 'Concluído', 'UPDATE', '2026-09-29 12:37:50', NULL),
(36, 4, 'vitinlegal@gmail.com', 'Tipo de resíduo: madeira (pau) | Quantidade aproximada: 3 paus | Descrição: muito pau', '2026-09-22 19:54:13', 'uploads/morador_6ab30715750b34.02704664.jpg', 'vitinlegal@gmail.com', 'Concluído', 'UPDATE', '2026-09-29 12:37:50', NULL),
(37, 5, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: 2 moveis | Descrição: moveis de madeira', '2026-09-26 18:56:36', 'uploads/morador_6ab83f9476df49.01906560.webp', 'antoniohbdasilva2@gmail.com', 'Concluído', 'UPDATE', '2026-09-29 12:37:50', NULL),
(38, 6, 'vitinlegal@gmail.com', 'Tipo de resíduo: moveis de madeira | Quantidade aproximada: muitos moveis | Descrição: muitos moveis de madeira', '2026-09-28 18:49:37', 'uploads/morador_6abae0f186d893.24242621.jpg', 'vitinlegal@gmail.com', 'Em análise', 'UPDATE', '2026-09-29 12:37:50', NULL),
(39, 7, 'vivianjos@gmail.com', 'Tipo de resíduo: madeira | Quantidade aproximada: muita madeira | Descrição: bastante madeira', '2026-09-29 09:35:53', 'uploads/morador_6abbb0a94074d3.54264948.png', 'vivianjos@gmail.com', 'Em análise', 'UPDATE', '2026-09-29 12:37:50', NULL),
(40, 2, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: galhos | Quantidade aproximada: 13 galhos | Descrição: asdasdasdas', '2026-09-18 22:51:38', 'uploads/morador_6aadeaaac97ab1.39015246.jpg', 'antoniohbdasilva2@gmail.com', 'Em análise', 'UPDATE', '2026-09-29 12:48:20', 'secretaria@ecoagenda.com'),
(41, 11, 'vivianjos@gmail.com', 'Tipo de resíduo: teste 3 | Quantidade aproximada: teste 3 | Descrição: teste 3', '2026-09-29 17:46:32', NULL, 'vivianjos@gmail.com', 'Em análise', 'UPDATE', '2026-09-29 20:06:36', 'secretaria@ecoagenda.com'),
(42, 11, 'vivianjos@gmail.com', 'Tipo de resíduo: teste 3 | Quantidade aproximada: teste 3 | Descrição: teste 3', '2026-09-29 17:46:32', NULL, 'vivianjos@gmail.com', 'Encaminhado', 'UPDATE', '2026-09-29 20:07:19', 'motorista@ecoagenda.com'),
(43, 2, 'antoniohbdasilva2@gmail.com', 'Tipo de resíduo: galhos | Quantidade aproximada: 13 galhos | Descrição: asdasdasdas', '2026-09-18 22:51:38', 'uploads/morador_6aadeaaac97ab1.39015246.jpg', 'antoniohbdasilva2@gmail.com', 'Encaminhado', 'UPDATE', '2026-09-29 20:08:50', 'motorista@ecoagenda.com'),
(44, 11, 'vivianjos@gmail.com', 'Tipo de resíduo: teste 3 | Quantidade aproximada: teste 3 | Descrição: teste 3', '2026-09-29 17:46:32', NULL, 'vivianjos@gmail.com', 'Em andamento', 'UPDATE', '2026-09-29 20:09:18', 'motorista@ecoagenda.com'),
(45, 10, 'vivianjos@gmail.com', 'Tipo de resíduo: teste 2 | Quantidade aproximada: teste 2 | Descrição: teste', '2026-09-29 17:42:17', NULL, 'vivianjos@gmail.com', 'Em análise', 'UPDATE', '2026-09-29 20:38:37', 'secretaria@ecoagenda.com');

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamento_morador_endereco`
--

CREATE TABLE `agendamento_morador_endereco` (
  `agendamento_id` int(11) NOT NULL,
  `endereco_id` int(11) NOT NULL,
  `morador_email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `agendamento_morador_endereco`
--

INSERT INTO `agendamento_morador_endereco` (`agendamento_id`, `endereco_id`, `morador_email`) VALUES
(1, 2, 'victorm10upload@gmail.com'),
(2, 1, 'antoniohbdasilva2@gmail.com'),
(3, 1, 'antoniohbdasilva2@gmail.com'),
(4, 5, 'vitinlegal@gmail.com'),
(5, 1, 'antoniohbdasilva2@gmail.com'),
(6, 5, 'vitinlegal@gmail.com'),
(7, 6, 'vivianjos@gmail.com'),
(8, 6, 'vivianjos@gmail.com'),
(9, 6, 'vivianjos@gmail.com'),
(10, 6, 'vivianjos@gmail.com'),
(11, 6, 'vivianjos@gmail.com');

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

--
-- Despejando dados para a tabela `coleta`
--

INSERT INTO `coleta` (`motorista_email`, `agendamento_id`, `data_inicio`, `data_chegada`, `data_finalizacao`, `foto`) VALUES
('motorista@ecoagenda.com', 1, '2026-09-18 22:44:26', NULL, '2026-09-18 22:46:17', 'uploads/motorista_6aade96984d593.32923230.jpg'),
('motorista@ecoagenda.com', 2, '2026-09-30 01:08:50', NULL, NULL, NULL),
('motorista@ecoagenda.com', 3, '2026-09-26 23:44:18', NULL, '2026-09-26 18:44:30', 'uploads/motorista_6ab83cbec871f4.40290833.jpg'),
('motorista@ecoagenda.com', 4, '2026-09-23 01:05:08', NULL, '2026-09-22 20:05:40', 'uploads/motorista_6ab309c43d93a7.24430600.jpg'),
('motorista@ecoagenda.com', 5, '2026-09-29 15:01:24', NULL, '2026-09-29 10:01:32', 'uploads/motorista_6abbb6acc13897.79334361.png'),
('motorista@ecoagenda.com', 10, '2026-09-29 20:38:37', NULL, NULL, NULL),
('motorista@ecoagenda.com', 11, '2026-09-30 01:07:19', NULL, '2026-09-29 20:09:18', 'uploads/motorista_6abc451e34f481.25685946.png');

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
(1, 'antoniohbdasilva2@gmail.com', '83330060', 'PR', 'Pinhais', 'Rua José Linhares', 'Jardim Amélia', '67', 'casa com garagem'),
(2, 'victorm10upload@gmail.com', '83328165', 'PR', 'Pinhais', 'Rua Íris', 'Jardim Karla', '559', 'casa'),
(3, 'guigui@gmail.com', '82840320', 'PR', 'Curitiba', 'Rua Rio Guaporé', 'Bairro Alto', '1212', 'casa'),
(4, 'vitinlegal@gmail.com', '83330060', 'PR', 'Pinhais', 'Rua José Linhares', 'Jardim Amélia', '67', 'casa com garagem'),
(5, 'vitinlegal@gmail.com', '83328165', 'PR', 'Pinhais', 'Rua Íris', 'Jardim Karla', '67', 'casa'),
(6, 'vivianjos@gmail.com', '83330060', 'PR', 'Pinhais', 'Rua José Linhares', 'Jardim Amélia', '112', 'casa com garagem');

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
('antoniohbdasilva2@gmail.com', '10076674940', '41995686212', '2008-03-12'),
('guigui@gmail.com', '11111111111', '41999999999', '2009-03-12'),
('morador@ecoagenda.com', '55566677788', '(41) 99999-2222', '1990-01-10'),
('victorm10upload@gmail.com', '14274143945', '41676767676', '2008-02-01'),
('vitinlegal@gmail.com', '76767676767', '41999999999', '1967-07-06'),
('vivianjos@gmail.com', '11536339903', '41987333535', '2007-06-26');

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
(1, 'antoniohbdasilva2@gmail.com'),
(2, 'victorm10upload@gmail.com'),
(3, 'guigui@gmail.com'),
(4, 'vitinlegal@gmail.com'),
(5, 'vitinlegal@gmail.com'),
(6, 'vivianjos@gmail.com');

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
('motorista@ecoagenda.com', '12345678901', '11122233344', '(41) 99999-1111', 1),
('roberto@gmail.com', '98765432198', '12345678911', '4111111111', 1);

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
('secretaria@ecoagenda.com'),
('vitoria@gmail.com');

-- --------------------------------------------------------

--
-- Estrutura para tabela `secretaria_agendamento`
--

CREATE TABLE `secretaria_agendamento` (
  `secretaria_email` varchar(255) NOT NULL,
  `agendamento_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `secretaria_agendamento`
--

INSERT INTO `secretaria_agendamento` (`secretaria_email`, `agendamento_id`) VALUES
('secretaria@ecoagenda.com', 1),
('secretaria@ecoagenda.com', 2),
('secretaria@ecoagenda.com', 3),
('secretaria@ecoagenda.com', 4),
('secretaria@ecoagenda.com', 5),
('secretaria@ecoagenda.com', 10),
('secretaria@ecoagenda.com', 11);

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
('antoniohbdasilva2@gmail.com', '$2y$10$dCmi7Vsz.I0vfr4iqggAqezs1sEl6G.mpiIyz469KnDGve5N9eMpu', 'antonio honorio'),
('guigui@gmail.com', '$2y$10$3wTKTf386/aZJxzQB08nB.9tmxVwHXyl0TaFMfVzNmPKq2zvMgmmi', 'gui baladinha'),
('morador@ecoagenda.com', '$2y$12$l7VXBTAehG5/w0A5gKUKru80OIQXL/Jz5.gEWox2tvPKWVTHVri.i', 'Morador EcoAgenda'),
('motorista@ecoagenda.com', '$2y$12$l7VXBTAehG5/w0A5gKUKru80OIQXL/Jz5.gEWox2tvPKWVTHVri.i', 'Motorista EcoAgenda'),
('roberto@gmail.com', '$2y$10$jQWyPQRajRwFTFEUkXRmseKJAaBsvS7PHiSiZWipzDasZL9esXvhK', 'roberto'),
('secretaria@ecoagenda.com', '$2y$12$l7VXBTAehG5/w0A5gKUKru80OIQXL/Jz5.gEWox2tvPKWVTHVri.i', 'Secretaria EcoAgenda'),
('victorm10upload@gmail.com', '$2y$10$swA6uorNe5ZOgQl.p34u.ea2wSSICJFqGP9FuCTdv6octYvvoq8Nm', 'victor matheus'),
('vitinlegal@gmail.com', '$2y$10$Hs3.h5UjZpCWsA5vc3UgIeN8sqcSvaOX4GfXKqCcNTSs7i4voylAG', 'vitin legal'),
('vitoria@gmail.com', '$2y$10$Ii4MujhwGTaOklAq1ivbQuhKP8mI7iCroM2SUa3C9Ew3QLu0IdMCG', 'Vitoria'),
('vivianjos@gmail.com', '$2y$10$1ot6Ebev4g67qNjxKSCP8O841EGgaDpeTNz1Yv5gt45wC/jBr1Tt2', 'vitoria anjos');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `agendamento_historico`
--
ALTER TABLE `agendamento_historico`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT de tabela `endereco`
--
ALTER TABLE `endereco`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
