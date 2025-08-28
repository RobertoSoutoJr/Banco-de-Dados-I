-- Ativa foreign keys no inicio do script
PRAGMA foreign_keys = no;

-- Criando TABELA USUARIO
CREATE TABLE Usuario(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT NOT NULL,
    senha TEXT NOT NULL
);

-- Criando TABELA CLIENTE
CREATE TABLE Cliente (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    telefone TEXT,
    usuario_id INTEGER NOT NULL UNIQUE,
    FOREIGN KEY (usuario_id) REFERENCES usuadio(id) ON DELETE CASCADE
);

-- Criando TABELA PRODUTO

CREATE TABLE Produto(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    descricao TEXT,
    preco REAL NOT NULL CHECK(preco>= 0)
);

-- Criando TABELA VENDA

CREATE TABLE Venda(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    data TEXT NOT NULL,
    usuario_id INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE SET NULL
);

-- Criando TABELA venda_Produto / tabela associatia para N:M [produto <-> venda]

CREATE TABLE venda_Produto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    venda_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario REAL NOT NULL CHECK (preco_unitario > 0),
    --PRIMARY KEY (venda_id, produto_id), -- CHAVE COMPOSTA
    FOREIGN KEY (venda_id) REFERENCES venda(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE CASCADE
);



-- Inserindo Dados na TABELA Usuario
-- Venda 5: Paulo comprou
INSERT INTO venda_Produto (venda_id, produto_id, quantidade, preco_unitario) VALUES
(5, 5, 1, 149.90),    -- 1 Relógio Digital
(5, 7, 1, 349.90);    -- 1 Jaqueta de Couro

-- Venda 6: Juliana comprou
INSERT INTO venda_Produto (venda_id, produto_id, quantidade, preco_unitario) VALUES
(6, 6, 1, 249.90),    -- 1 Fone Bluetooth
(6, 8, 2, 99.90);     -- 2 Óculos de Sol

-- Venda 7: João comprou novamente
INSERT INTO venda_Produto (venda_id, produto_id, quantidade, preco_unitario) VALUES
(7, 2, 1, 129.90),    -- 1 Calça Jeans
(7, 5, 1, 149.90);    -- 1 Relógio Digital


-- Inserindo Dados na TABELA Cliente
INSERT INTO Cliente (nome, telefone, usuario_id) VALUES
('Paulo Mendes', '11911112222', 4),
('Juliana Costa', '11933334444', 5);

-- Inserindo Dados na TABELA Produto
INSERT INTO Produto (nome, descricao, preco) VALUES
('Relógio Digital', 'Relógio resistente à água', 149.90),
('Fone Bluetooth', 'Fone de ouvido sem fio', 249.90),
('Jaqueta de Couro', 'Jaqueta preta tamanho G', 349.90),
('Óculos de Sol', 'Óculos com proteção UV', 99.90);

-- Inserindo Dados na TABELA Venda
INSERT INTO Venda (data, usuario_id, cliente_id) VALUES
('2025-08-26', 4, 4), -- Paulo com Fernanda
('2025-08-27', 5, 5), -- Juliana com Ricardo
('2025-08-27', 2, 1); -- João novamente com Ana

-- Inserindo Dados na TABELA venda_Produto
INSERT INTO venda_Produto (venda_id, produto_id, quantidade, preco_unitario) VALUES
(5, 5, 1, 149.90),    -- 1 Relógio Digital
(5, 7, 1, 349.90);    -- 1 Jaqueta de Couro

INSERT INTO venda_Produto (venda_id, produto_id, quantidade, preco_unitario) VALUES
(6, 6, 1, 249.90),    -- 1 Fone Bluetooth
(6, 8, 2, 99.90);     -- 2 Óculos de Sol

INSERT INTO venda_Produto (venda_id, produto_id, quantidade, preco_unitario) VALUES
(7, 2, 1, 129.90),    -- 1 Calça Jeans
(7, 5, 1, 149.90);    -- 1 Relógio Digital


