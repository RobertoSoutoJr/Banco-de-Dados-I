PRAGMA foreign_keys = ON;

-- Tabela Participante
CREATE TABLE Participante (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    telefone TEXT
);

-- Tabela Evento
CREATE TABLE Evento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    descricao TEXT,
    local TEXT NOT NULL,
    data TEXT NOT NULL
);

-- Tabela Inscricao (associativa Evento x Participante)
CREATE TABLE Inscricao (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_evento INTEGER NOT NULL,
    id_participante INTEGER NOT NULL,
    data_inscricao TEXT,
    status TEXT,
    FOREIGN KEY (id_evento) REFERENCES Evento(id) ON DELETE CASCADE,
    FOREIGN KEY (id_participante) REFERENCES Participante(id) ON DELETE CASCADE,
    UNIQUE (id_evento, id_participante) -- evita inscrição duplicada do mesmo participante no mesmo evento
);

-- Tabela Pagamento (1:1 com Inscricao)
CREATE TABLE Pagamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_inscricao INTEGER UNIQUE, -- garante relação 1:1
    valor REAL,
    data_pagamento TEXT,
    status TEXT,
    FOREIGN KEY (id_inscricao) REFERENCES Inscricao(id) ON DELETE CASCADE
);





-- Inserindo participantes
INSERT INTO Participante (nome, email, telefone) VALUES
('João Silva', 'joao.silva@email.com', '11999990001'),
('Maria Oliveira', 'maria.oliveira@email.com', '11999990002'),
('Carlos Souza', 'carlos.souza@email.com', '11999990003');

-- Inserindo eventos
INSERT INTO Evento (nome, descricao, local, data) VALUES
('Workshop de Python', 'Aprenda Python do básico ao avançado', 'Auditório Central', '2025-09-10'),
('Seminário de Data Science', 'Técnicas e cases de Data Science', 'Sala 101', '2025-10-05'),
('Congresso de Tecnologia', 'Últimas tendências em tecnologia', 'Centro de Convenções', '2025-11-20');

-- Inserindo inscrições (associando participantes e eventos)
INSERT INTO Inscricao (id_evento, id_participante, data_inscricao, status) VALUES
(1, 1, '2025-08-25', 'confirmada'),
(1, 2, '2025-08-26', 'confirmada'),
(2, 2, '2025-08-27', 'confirmada'),
(3, 3, '2025-08-28', 'cancelada');

-- Inserindo pagamentos (1:1 com inscrições)
INSERT INTO Pagamento (id_inscricao, valor, data_pagamento, status) VALUES
(1, 150.00, '2025-08-26', 'pago'),
(2, 150.00, '2025-08-27', 'pendente'),
(3, 200.00, '2025-08-28', 'pago');




-- GERANDO MAIS INSERTS --

-- Inserindo mais participantes
INSERT INTO Participante (nome, email, telefone) VALUES
('Ana Pereira', 'ana.pereira@email.com', '11999990004'),
('Bruno Lima', 'bruno.lima@email.com', '11999990005');

-- Inserindo mais eventos
INSERT INTO Evento (nome, descricao, local, data) VALUES
('Hackathon de IA', 'Desafio de programação com Inteligência Artificial', 'Laboratório de TI', '2025-12-05'),
('Palestra de Segurança da Informação', 'Boas práticas de segurança digital', 'Auditório B', '2025-12-15');

-- Inserindo mais inscrições
INSERT INTO Inscricao (id_evento, id_participante, data_inscricao, status) VALUES
(2, 1, '2025-09-01', 'confirmada'),  -- João Silva se inscreveu no Seminário de Data Science
(4, 4, '2025-09-02', 'confirmada'),  -- Ana Pereira se inscreveu na Palestra de Segurança da Informação
(5, 5, '2025-09-03', 'confirmada'),  -- Bruno Lima se inscreveu no Hackathon de IA
(3, 2, '2025-09-04', 'confirmada');  -- Maria Oliveira se inscreveu no Congresso de Tecnologia

-- Inserindo mais pagamentos
INSERT INTO Pagamento (id_inscricao, valor, data_pagamento, status) VALUES
(4, 180.00, '2025-09-05', 'pago'),   -- João Silva pagamento Seminário
(5, 120.00, '2025-09-06', 'pendente'), -- Ana Pereira pagamento Palestra
(6, 250.00, '2025-09-07', 'pago'),    -- Bruno Lima pagamento Hackathon
(7, 200.00, '2025-09-08', 'pendente'); -- Maria Oliveira pagamento Congresso


