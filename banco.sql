CREATE TABLE usuarios (
    id             RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    nome           VARCHAR2(100),
    email          VARCHAR2(100) UNIQUE NOT NULL,
    senha_hash     VARCHAR2(255) NOT NULL,
    tipo_usuario   VARCHAR2(30) CHECK (tipo_usuario IN ('comum', 'defesa_civil', 'ong')),
    telefone       VARCHAR2(20),
    latitude       NUMBER(9,6),
    longitude      NUMBER(9,6),
    criado_em      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sensores (
    id           RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    localizacao  VARCHAR2(100),
    latitude     NUMBER(9,6),
    longitude    NUMBER(9,6),
    tipo         VARCHAR2(50),
    ativo        CHAR(1) CHECK (ativo IN ('S', 'N')),
    instalado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE leituras_sensor (
    id         RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    sensor_id  RAW(16) NOT NULL,
    valor      NUMBER,
    unidade    VARCHAR2(10),
    lido_em    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_leitura_sensor FOREIGN KEY (sensor_id) REFERENCES sensores(id)
);

CREATE TABLE alertas (
    id         RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    sensor_id  RAW(16) NOT NULL,
    tipo       VARCHAR2(50),
    mensagem   CLOB,
    nivel      VARCHAR2(20) CHECK (nivel IN ('baixo', 'moderado', 'critico')),
    criado_em  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolvido  CHAR(1) DEFAULT 'N' CHECK (resolvido IN ('S', 'N')),
    CONSTRAINT fk_alerta_sensor FOREIGN KEY (sensor_id) REFERENCES sensores(id)
);

CREATE TABLE sos (
    id          RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    usuario_id  RAW(16) NOT NULL,
    latitude    NUMBER(9,6),
    longitude   NUMBER(9,6),
    status      VARCHAR2(20) CHECK (status IN ('pendente', 'em_atendimento', 'resolvido')),
    criado_em   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sos_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE abrigos (
    id              RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    nome            VARCHAR2(100),
    capacidade      NUMBER,
    ocupacao_atual  NUMBER,
    latitude        NUMBER(9,6),
    longitude       NUMBER(9,6),
    responsavel     VARCHAR2(100)
);

CREATE TABLE drones (
    id           RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
    nome         VARCHAR2(50),
    status       VARCHAR2(20) CHECK (status IN ('ativo', 'em_missao', 'offline')),
    local_atual  VARCHAR2(100),
    latitude     NUMBER(9,6),
    longitude    NUMBER(9,6)
);